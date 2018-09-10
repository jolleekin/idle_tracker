import 'dart:async';
import 'dart:html';

void _noop() {}

typedef void _VoidFunc0();

class IdleTracker {
  /// The duration of inactivity that signals idleness.
  final Duration timeout;

  /// The event types to track.
  final List<String> eventTypes;

  /// Whether the `onIdle` callback passed into the constructor should be invoked
  /// repeatedly with [timeout] intervals while [isIdle] is `true`.
  final bool periodicIdleCall;

  final bool startsAsIdle;

  final _VoidFunc0 _onIdle;
  final _VoidFunc0 _onActive;

  bool _isIdle;
  Timer _timer;

  /// [onIdle] is the callback to be invoked when [isIdle] becomes `true`.
  /// If [periodicIdleCall] is `true`, this callback is repeatedly invoked with
  /// [timeout] intervals while [isIdle] is `true`.
  ///
  /// [onActive] is the callback to be invoked when [isIdle] becomes `false`.
  ///
  /// [startsAsIdle] specifies the initial state.
  IdleTracker(
      {this.timeout,
      void onIdle(),
      void onActive(),
      this.periodicIdleCall = false,
      this.startsAsIdle = false,
      this.eventTypes = const [
        'keydown',
        'mousedown',
        'mousemove',
        'touchstart'
      ]})
      : _onIdle = onIdle ?? _noop,
        _onActive = onActive ?? _noop;

  /// Whether the current state is idle.
  bool get isIdle => _isIdle;

  /// Whether idleness is being tracked.
  bool get isTracking => _timer != null;

  /// Restarts tracking. Equivalent to calling [stop] and then [start].
  void restart() {
    stop();
    start();
  }

  /// Starts tracking. This method does nothing if [isTracking] is `true`.
  ///
  /// The initial state is determined by [startsAsIdle].
  void start() {
    if (isTracking) return;
    _isIdle = startsAsIdle;
    if (_isIdle) _createTimer();
    for (var t in eventTypes) {
      window.addEventListener(t, _resetTimer);
    }
  }

  /// Stops tracking. This method does nothing if [isTracking] is `false`.
  void stop() {
    if (!isTracking) return;
    _timer.cancel();
    _timer = null;
    for (var t in eventTypes) {
      window.removeEventListener(t, _resetTimer);
    }
  }

  void _createTimer() {
    _timer = periodicIdleCall
        ? Timer.periodic(timeout, _onTimeout)
        : Timer(timeout, _onTimeout);
  }

  void _onTimeout([_]) {
    _isIdle = true;
    _onIdle();
  }

  void _resetTimer(_) {
    if (_isIdle) {
      _isIdle = false;
      _onActive();
    }
    _timer?.cancel();
    _createTimer();
  }
}
