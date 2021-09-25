extension ExtendedIterable<E> on Iterable<E> {
  Iterable<T> mapIndex<T>(T Function(E element, int index) f) {
    var i = 0;
    return map((e) => f(e, i++));
  }

  void forEachIndex(void Function(E, int index) f) {
    var i = 0;
    for (var e in this) {
      f(e, i++);
    }
  }
}
