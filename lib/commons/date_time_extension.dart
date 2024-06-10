const _monthName = [
  "Januari",
  "Febuari",
  "Maret",
  "April",
  "Mei",
  "Juni",
  "Juli",
  "Agustus",
  "September",
  "Oktober",
  "November",
  "Desember"
];

String _getMonthName(int month) {
  if (month < 1 || month > 12) throw ArgumentError("Invalid Month Value", "month");

  return _monthName[month - 1];
}

bool _isLeapYear(int year) {
  if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) return true;

  return false;
}

extension DateTimeExtension on DateTime {
  String toIdStyleStringWithMonthName() => "$day ${_getMonthName(month)} $year";
  String toIdStyleString() =>
      "${day.toString().padLeft(2, '0')}-${month.toString().padLeft(2, '0')}-${year.toString().padLeft(4, '0')}";
}

extension DateTimeParsing on String? {
  ///Format : dd-mm-yyyy
  DateTime? parseIdStyle() {
    if (this == null || this!.isEmpty) return null;

    var stringSplit = this!.split("-");
    if (stringSplit.length != 3) return null;

    try {
      var strDay = stringSplit[0];
      var strMonth = stringSplit[1];
      var strYear = stringSplit[2];

      if (strDay.length != 2) return null;
      if (strMonth.length != 2) return null;
      if (strYear.length != 4) return null;

      int day = int.parse(strDay);
      int month = int.parse(strMonth);
      int year = int.parse(strYear);

      if (year < 0 || month < 1 || month > 12 || year > DateTime.now().year) {
        return null;
      }

      const longMonth = [1, 3, 5, 7, 8, 10, 12];
      const shortMonth = [4, 6, 9, 11];

      if (longMonth.contains(month) && day > 31) return null;
      if (shortMonth.contains(month) && day > 30) return null;

      if (month == 2) {
        if (_isLeapYear(year) == true && day > 29) return null;
        if (_isLeapYear(year) == false && day > 28) return null;
      }

      return DateTime(year, month, day);
    } catch (e) {
      return null;
    }
  }
}
