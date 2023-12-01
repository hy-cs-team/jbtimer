extension FormatExtensions on int {
  String get recordFormat {
    int total = this;
    int ms = total % 1000;
    total ~/= 1000;

    int s = total % 60;
    total ~/= 60;

    int m = total;

    String fromSecond =
        '${s.toString().padLeft(2, '0')}.${ms.toString().padLeft(3, '0')}';
    if (m == 0) {
      return fromSecond;
    }
    return '$m:$fromSecond';
  }
}
