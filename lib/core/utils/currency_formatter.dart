/// Formatter utility for displaying currency values cleanly in PKR.
class CurrencyFormatter {
  CurrencyFormatter._();

  static String format(double amount, {String symbol = 'PKR '}) {
    final whole = amount.toInt();
    final withCommas = whole.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    return '$symbol$withCommas';
  }
}
