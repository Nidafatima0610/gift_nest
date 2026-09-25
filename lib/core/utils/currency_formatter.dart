/// Formatter utility for displaying currency values cleanly.
class CurrencyFormatter {
  CurrencyFormatter._();

  static String format(double amount, {String symbol = '\$'}) {
    return '$symbol${amount.toStringAsFixed(2)}';
  }
}
