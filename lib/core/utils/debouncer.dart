import 'dart:async';

import 'package:flutter/foundation.dart';

class Debouncer {
  Debouncer({this.duration = const Duration(milliseconds: 500)});

  final Duration duration;
  Timer? _timer;

  void call(VoidCallback action, {Duration? duration}) {
    _timer?.cancel();
    _timer = Timer(duration ?? this.duration, action);
  }

  void cancel() => _timer?.cancel();
}
