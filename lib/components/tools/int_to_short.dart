String intToShort(int n) {
  final ks = n ~/ 1000;
  if (ks == 0) return n.toString();

  return '${ks}K';
}
