class Validator {
  ///validate field is not empty
  static String? validateField({required String value}) {
    if (value.isEmpty) {
      return 'Field can\'t be empty';
    }

    return null;
  }
}
