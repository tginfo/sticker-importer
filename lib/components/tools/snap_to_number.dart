int snapToNumber(int n) {
  if (n > 18) {
    return (n - 18) * 10000;
  }
  if (n > 9) {
    return (n - 9) * 1000;
  }
  return n * 100;
}
