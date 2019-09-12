class Ticker {
  Stream<int> tick({int ticks}) {
    return Stream.periodic(Duration(seconds: 1), (iteration) => ticks - iteration - 1)
        .take(ticks);
  }
}
