class Observer<T> {
  final List<void Function(T)> _listeners = [];

  void addListener(void Function(T) listener) {
    _listeners.add(listener);
  }

  void removeListener(void Function(T) listener) {
    _listeners.remove(listener);
  }

  void notifyListeners(T state) {
    for (var listener in _listeners) {
      listener(state);
    }
  }
}
