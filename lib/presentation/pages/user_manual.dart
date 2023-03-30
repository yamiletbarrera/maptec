import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

class UserManual extends StatefulWidget {
  UserManual({Key? key, required this.pdfAssetPath}) : super(key: key);
  final String pdfAssetPath;

  @override
  State<UserManual> createState() => _UserManualState();
}

class _UserManualState extends State<UserManual> {
  int paginaActual = 0;
  int paginaTotal = 0;
  final Completer<PDFViewController> _pdfViewController =
      Completer<PDFViewController>();

  final StreamController<String> _pageCountController =
      StreamController<String>();

  @override
  Widget build(BuildContext context) {
    final themeScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manual de usuario'),
        actions: <Widget>[
          StreamBuilder<String>(
              stream: _pageCountController.stream,
              builder: (_, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  return Center(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(4)),
                          color: themeScheme.primary),
                      child: Text(snapshot.data!,
                          style: TextStyle(color: themeScheme.onPrimary)),
                    ),
                  );
                }
                return const SizedBox();
              }),
        ],
      ),
      body: PDF(
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageFling: false,
        onPageChanged: (int? current, int? total) {
          _pageCountController.add('${current! + 1} - $total');

          setState(() {
            paginaActual = current;
            paginaTotal = total!;
          });
        },
        onViewCreated: (PDFViewController pdfViewController) async {
          _pdfViewController.complete(pdfViewController);
          final int currentPage = await pdfViewController.getCurrentPage() ?? 0;
          final int? pageCount = await pdfViewController.getPageCount();
          _pageCountController.add('${currentPage + 1} - $pageCount');
        },
      ).fromAsset(
        widget.pdfAssetPath,
        errorWidget: (dynamic error) => Center(child: Text(error.toString())),
      ),
      floatingActionButton: FutureBuilder<PDFViewController>(
        future: _pdfViewController.future,
        builder: (_, AsyncSnapshot<PDFViewController> snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return Container(
              width: MediaQuery.of(context).size.width - 32,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Visibility(
                    visible: paginaActual != 0,
                    child: FloatingActionButton(
                      backgroundColor: themeScheme.primary,
                      foregroundColor: themeScheme.onPrimary,
                      heroTag: '-',
                      tooltip: "Retroceder página",
                      child: const Icon(Icons.arrow_back),
                      onPressed: () async {
                        final PDFViewController pdfController = snapshot.data!;
                        final int currentPage =
                            (await pdfController.getCurrentPage())! - 1;
                        final int numberOfPages =
                            await pdfController.getPageCount() ?? 0;

                        setState(() {
                          paginaActual = currentPage;
                          paginaTotal = numberOfPages;
                        });

                        if (currentPage >= 0) {
                          await pdfController.setPage(currentPage);
                        }
                      },
                    ),
                  ),
                  Visibility(
                    visible: paginaTotal != paginaActual + 1,
                    child: FloatingActionButton(
                      backgroundColor: themeScheme.primary,
                      foregroundColor: themeScheme.onPrimary,
                      heroTag: '+',
                      tooltip: "Avanzar página",
                      child: const Icon(Icons.arrow_forward),
                      onPressed: () async {
                        final PDFViewController pdfController = snapshot.data!;
                        final int currentPage =
                            (await pdfController.getCurrentPage())! + 1;
                        final int numberOfPages =
                            await pdfController.getPageCount() ?? 0;

                        setState(() {
                          paginaActual = currentPage;
                          paginaTotal = numberOfPages;
                        });

                        if (numberOfPages > currentPage) {
                          await pdfController.setPage(currentPage);
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
