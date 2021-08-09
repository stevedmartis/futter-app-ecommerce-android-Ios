extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }

  String capitalizeAll() {
    return "${this[0].toUpperCase()}${this.substring(0)}";
  }
}
