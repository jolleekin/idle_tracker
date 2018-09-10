import 'dart:html';

import 'package:idle_tracker/idle_tracker.dart';

void main() {
  IdleTracker(
      timeout: const Duration(seconds: 5),
      periodicIdleCall: true,
      startsAsIdle: true,
      onIdle: onIdle,
      onActive: onActive)
    ..start();
}

var count = 0;
final output = document.querySelector('#output');

void log(String message) {
  if (output.children.length >= 40) {
    output.innerHtml = '';
  }
  output.append(DivElement()..text = message);
}

void onActive() {
  count = 0;
  log('Welcome back!');
}

void onIdle() {
  if (count++ < 10) log('Hey, are you there?');
}
