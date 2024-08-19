extension IterableFirstWhereOrNull<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E) test) {
    try {
      return firstWhere(test);
    } catch (e) {
      return null;
    }
  }
}
