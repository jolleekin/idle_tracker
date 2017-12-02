# idle_tracker

A tiny package that tracks idleness in a web application.

## Usage

A simple usage example:

    import 'package:idle_tracker/idle_tracker.dart';

    void main() {
      new IdleTracker(
          timeout: const Duration(seconds: 5),
          periodicIdleCall: true,
          startsAsIdle: true,
          onIdle: () => print('Hey, are you there?'),
          onActive: () => print('Welcome back!'))
        ..start();
    }

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/jolleekin/idle_tracker/issues
