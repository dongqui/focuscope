class Observer<T> {
  final List<_ConditionalListener<T>> _listeners = [];
  T? _lastState;

  void addListener(void Function(T, T?) listener,
      {bool Function(T, T?)? filter}) {
    _listeners.add(_ConditionalListener(listener, filter));
  }

  void removeListener(void Function(T, T?) listener) {
    _listeners.removeWhere((l) => l.listener == listener);
  }

  void notifyListeners(T state) {
    if (_lastState != state) {
      for (var l in _listeners) {
        if (l.filter == null || l.filter!(state, _lastState)) {
          l.listener(state, _lastState);
        }
      }
      _lastState = state;
    }
  }
}

class _ConditionalListener<T> {
  final void Function(T, T?) listener;
  final bool Function(T, T?)? filter;
  _ConditionalListener(this.listener, this.filter);
}
