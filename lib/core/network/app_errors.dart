import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' show ClientException;

class AppErrors {
  AppErrors._();

  static const String noInternet =
      'No Internet connection. Please check your network and try again.';

  static const String unknown =
      'Something went wrong while communicating with the server.';

  static const String serverNotResponding =
      'Server is not responding right now. Please try again in a few minutes.';

  static String messageFromException(Object error) {
    if (error is TimeoutException) {
      return serverNotResponding;
    }

    if (error is SocketException) {
      return noInternet;
    }

    if (error is ClientException) {
      return _isConnectionMessage(error.message) ? noInternet : unknown;
    }

    final normalized = error.toString().toLowerCase();
    if (_isConnectionMessage(normalized)) {
      return noInternet;
    }

    if (normalized.contains('timeout') ||
        normalized.contains('timed out')) {
      return serverNotResponding;
    }

    return unknown;
  }

  static bool _isConnectionMessage(String text) {
    final normalized = text.toLowerCase();
    return normalized.contains('failed host lookup') ||
        normalized.contains('connection refused') ||
        normalized.contains('network is unreachable') ||
        normalized.contains('network unreachable') ||
        normalized.contains('socketexception') ||
        normalized.contains('connection error') ||
        normalized.contains('not connected') ||
        normalized.contains('websocket') ||
        normalized.contains('no address associated with hostname');
  }
}
