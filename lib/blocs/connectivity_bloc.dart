import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:rxdart/rxdart.dart';
import 'package:maptec/main.dart';

enum NetworkStatus { online, offline }

class ConnectivityBloc extends ChangeNotifier {
  late StreamSubscription _connectionSubscription;

  NetworkStatus status = NetworkStatus.online;

  ConnectivityBloc() {
    _connectionSubscription =
        internetChecker.internetStatus().listen((newStatus) {
      status = newStatus;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _connectionSubscription.cancel();
    super.dispose();
  }
}

class CheckInternetConnection {
  final Connectivity _connectivity = Connectivity();

  /// We assume the initial status is Online
  final _controller = BehaviorSubject.seeded(NetworkStatus.online);
  StreamSubscription? _connectionSubscription;

  CheckInternetConnection() {
    _checkInternetConnection();
  }

  Stream<NetworkStatus> internetStatus() {
    _connectionSubscription ??= _connectivity.onConnectivityChanged
        .listen((_) => _checkInternetConnection());
    return _controller.stream;
  }

  Future<void> _checkInternetConnection() async {
    try {
      // Sometimes the callback is called when we reconnect to wifi,
      // but the internet is not really functional
      // This delay try to wait until we are really connected to internet
      await Future.delayed(const Duration(seconds: 3));
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _controller.sink.add(NetworkStatus.online);
      } else {
        _controller.sink.add(NetworkStatus.offline);
      }
    } on SocketException catch (_) {
      _controller.sink.add(NetworkStatus.offline);
    }
  }

  Future<void> close() async {
    await _connectionSubscription?.cancel();
    await _controller.close();
  }
}
