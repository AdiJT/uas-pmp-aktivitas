class ValidationRule<T> {
  final String message;
  final bool Function(T) rule;

  ValidationRule({required this.message, required this.rule});

  ValidationResult validate(T value) {
    if (rule(value) == true) return ValidationResult.success();

    return ValidationResult.failed(this.message);
  }
}

class ValidationResult {
  final bool success;
  final String? errorMessage;

  ValidationResult(this.success, this.errorMessage);

  ValidationResult.success()
      : success = true,
        errorMessage = null;
  ValidationResult.failed(String this.errorMessage)
      : success = false;
}

final notNullOrEmpty = ValidationRule<String?>(
    message: "Input Belum diisi",
    rule: (s) => s != null && s.trim().isNotEmpty);

final mustBeNumber = ValidationRule<String?>(
    message: "Harus Angka",
    rule: (s) => s != null && s.contains(RegExp(r'^[0-9]+$')));

final noTrailSpace = ValidationRule<String?>(
    message: "Tidak boleh ada spasi di awal atau akhir",
    rule: (s) => s != null && s.trim() == s);

final noSpaceInMiddle = ValidationRule<String?>(
    message: "Tidak boleh ada spasi di tengah",
    rule: (s) => s != null && s.trim().split(" ").length == 1);

final noDoubleSpace = ValidationRule<String?>(
    message: "Tidak boleh ada spasi lebih dari 1 di tengah",
    rule: (s) =>
        s != null &&
        s.trim().contains(RegExp(r'[^\s]([ ]{2,})[^\s]')) == false);

final noNumber = ValidationRule<String?>(
    message: "Tidak boleh ada angka",
    rule: (s) => s != null && s.contains(RegExp(r'^[0-9]')) == false);

ValidationRule<String?> parseSuccess<T>(T? Function(String?) parse) {
  return ValidationRule(
      message: "Format input salah", rule: (s) => parse(s) != null);
}

ValidationRule<String?> lengthEqual(int length) {
  return ValidationRule<String?>(
      message: "Panjang tidak sama dengan $length",
      rule: (s) {
        if (s != null && s.length == length) return true;

        return false;
      });
}

ValidationRule<String?> lengthLessThan(int maxLength) {
  return ValidationRule(
      message: "Panjang lebih dari $maxLength",
      rule: (s) {
        if (s != null && s.length <= maxLength) return true;
        return false;
      });
}

ValidationRule<String?> lengthMoreThan(int minLength) {
  return ValidationRule(
      message: "Panjang kurang dari $minLength",
      rule: (s) => s != null && s.length >= minLength);
}
