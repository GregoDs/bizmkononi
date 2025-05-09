class Functions {
  String? noSpecialCharactersValidator(String? value, {String allowedCharacters = ''}) {
  if (value == null || value.isEmpty) {
    return 'Please enter some text';
  }

  // Construct the pattern dynamically based on allowed characters
  final pattern = '^[a-zA-Z0-9\\s$allowedCharacters]+\$';
  if (!RegExp(pattern).hasMatch(value)) {
    return 'Special characters are not allowed';
  }
  return null;
}

  String? combineValidators(
      String? value, List<String? Function(String?)> validators) {
    for (final validator in validators) {
      final result = validator(value);
      if (result != null) {
        return result; // Return the first error encountered
      }
    }
    return null; // All validations passed
  }

  String? phoneNumberValidator(String? value) {
    if (value != null && value.isNotEmpty && value.length != 10) {
      return 'Please enter a valid phone number';
    }

    return null;
  }
}
