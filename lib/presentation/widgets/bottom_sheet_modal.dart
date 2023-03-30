import 'package:flutter/material.dart';
import 'package:maptec/presentation/widgets/custom_widgets/draggable_bottom_sheet.dart';
import 'package:maptec/blocs/input_search_bloc.dart';
import 'package:maptec/presentation/widgets/map.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomSheetModal extends StatelessWidget {
  dynamic _data;
  String? letra;
  int typeSearch;

  BottomSheetModal({super.key, this.typeSearch = 1});

  @override
  Widget build(BuildContext context) {
    final themeScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final input = Provider.of<InputSearchBloc>(context);
    _data = input.selectedData;
    letra = _data?.edificio?.nombre.split('"')[1];
    typeSearch = input.typeSearch;
    final maxExt = typeSearch != 1
        ? MediaQuery.of(context).size.height * 0.6
        : double.infinity;

    return DraggableBottomSheet(
      minExtent: 92,
      useSafeArea: false,
      curve: Curves.easeIn,
      previewWidget: _previewWidget(themeScheme, textTheme),
      expandedWidget: _expandedWidget(themeScheme, textTheme, context),
      backgroundWidget: const MapWidget(),
      duration: const Duration(milliseconds: 0),
      maxExtent: maxExt,
      onDragging: (pos) {},
    );
  }

  _previewWidget(ColorScheme themeScheme, TextTheme textTheme) {
    return Visibility(
      visible: _data != null,
      child: Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
          decoration: BoxDecoration(
            color: themeScheme.surface,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24.0)),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                  color: themeScheme.primary,
                  borderRadius: BorderRadius.circular(8)),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Hero(
                    tag: 'edificio',
                    child: Image(
                      image: AssetImage(
                          "assets/image/edificios/${letra ?? "A"}.jpg"),
                      width: 88,
                      height: 64,
                      fit: BoxFit.fill,
                    )),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Text(
                    _data?.nombre ?? 'Aquí aparecerá el nombre de la entidad',
                    style: textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                ),
              ],
            )
          ])),
    );
  }

  _expandedWidget(
      ColorScheme themeScheme, TextTheme textTheme, BuildContext context) {
    //Checamos si hay data, se colapsa si es que esta abierto
    if (_data == null) {
      DraggableBottomSheet.staticCollapsed = true;
    } else {
      DraggableBottomSheet.staticCollapsed = false;
    }
    return Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        decoration: BoxDecoration(
          color: themeScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //Pestaña decorativa
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 16, top: 8),
                  width: 32,
                  height: 4,
                  decoration: BoxDecoration(
                      color: themeScheme.primary,
                      borderRadius: BorderRadius.circular(8)),
                ),
              ],
            ),

            //Contenido
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: typeSearch != 1
                    ? typeSearch != 4
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Hero(
                          tag: 'edificio',
                          child: Image(
                            image: AssetImage(
                                "assets/image/edificios/${letra ?? "A"}.jpg"),
                            //height: 200,
                            width: MediaQuery.of(context).size.width - 32,
                            fit: BoxFit.fill,
                          )),

                      const SizedBox(
                        height: 12,
                      ),

                      //Nombre
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Text(
                            _data?.nombre ??
                                'Aquí aparecerá el nombre de la entidad',
                            style: textTheme.titleLarge,
                            overflow: TextOverflow.visible,
                            softWrap: true,
                          )),
                        ],
                      ),
                    ],
                  ),
                  ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: [
                      //Edificio
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          LabelLarge("Edificio: ", themeScheme.primary),
                          const SizedBox(
                            width: 8,
                          ),
                          LabelLarge(letra ?? 'Letra', themeScheme.onSurface),
                        ],
                      ),

                      //Jefe de departamento
                      Visibility(
                        visible: typeSearch == 1
                            ? _data?.jefeDepartamento != null
                            : false,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 12,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                LabelLarge("Jefe de departamento:",
                                    themeScheme.primary),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                    child: LabelLarge(
                                  "${typeSearch == 1 ? _data?.jefeDepartamento?.nombre ?? "C. Nomnbre Apellido" : " "}",
                                  themeScheme.onSurface,
                                )),
                              ],
                            ),
                          ],
                        ),
                      ),

                      //Correo electrónico
                      Visibility(
                        visible: typeSearch == 1
                            ? _data?.jefeDepartamento != null
                            : typeSearch == 4
                                ? _data?.correo != null
                                : false,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 12,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                LabelLarge("Correo electrónico: ",
                                    themeScheme.primary),
                                const SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: TextButton(
                                    onPressed: () {
                                      if (typeSearch == 1) {
                                        if (_data?.jefeDepartamento?.correo !=
                                            null) {
                                          _launchEmail(
                                              "${_data?.jefeDepartamento?.correo}",
                                              context,
                                              themeScheme);
                                        }
                                      } else if (typeSearch == 4) {
                                        if (_data?.correo != null) {
                                          _launchEmail("${_data?.correo}",
                                              context, themeScheme);
                                        }
                                      }
                                    },
                                    child: LabelLarge(
                                        typeSearch == 1
                                            ? "${_data?.jefeDepartamento?.correo}"
                                            : typeSearch == 4
                                                ? "${_data?.correo}"
                                                : 'correo@cuautla.tecnm.mx',
                                        themeScheme.onSurface,
                                        decoration: true),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      //Link de información externa
                      Visibility(
                        visible:
                            typeSearch == 1 ? _data?.linkInfo != null : false,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 16,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                backgroundColor: themeScheme.secondary,
                              ),
                              onPressed: () {
                                _launchURL(
                                    _data?.linkInfo ??
                                        'https://www.cuautla.tecnm.mx/organigrama',
                                    context,
                                    themeScheme);
                              },
                              child: LabelLarge(
                                  "Más información", themeScheme.onSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Visibility(
                    visible: typeSearch == 1
                        ? _data?.cita != null && _data?.video != null
                        : false,
                    child: ButtonBar(
                      alignment: MainAxisAlignment.spaceAround,
                      children: [
                        //Agendar cita
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            backgroundColor: themeScheme.primary,
                          ),
                          onPressed: () {
                            _launchURL(
                                _data?.cita?.urlCita ??
                                    'https://www.cuautla.tecnm.mx/ventanilla',
                                context,
                                themeScheme);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: themeScheme.onPrimary,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              LabelLarge(
                                  "Reserva una cita", themeScheme.onPrimary),
                            ],
                          ),
                        ),
                        //Video en YouTube
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            backgroundColor: const Color(0xFFE62117),
                          ),
                          onPressed: () {
                            _launchURL(
                                _data?.video?.urlVideo ??
                                    'https://www.youtube.com/channel/UCw4gM0YbsRGLtijurDCJ9jg',
                                context,
                                themeScheme);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.play_circle_outline,
                                color: Color(0xFFF9F9F9),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              LabelLarge("Ver video", const Color(0xFFF9F9F9)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  _launchEmail(
      String email, BuildContext context, ColorScheme themeScheme) async {
    Uri uri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: themeScheme.error,
        content: Text("No se pudo abrir el enlace",
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: themeScheme.onError)),
      ));
    }
  }

  _launchURL(String url, BuildContext context, ColorScheme themeScheme) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: themeScheme.error,
        content: Text("No se pudo abrir el enlace",
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: themeScheme.onError)),
      ));
    }
  }
}

class LabelLarge extends StatelessWidget {
  String text;
  Color color;
  bool? decoration;

  LabelLarge(this.text, this.color, {Key? key, this.decoration = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: color,
          decoration:
              decoration! ? TextDecoration.underline : TextDecoration.none),
      overflow: TextOverflow.visible,
      softWrap: true,
    );
  }
}
