extension PasswordValidation on String {
  String? validatePassword() {
    final digitRegEx = RegExp(r'[0-9]');
    final letterRegEx = RegExp(r'[a-zA-Z]');
    final specialCharRegEx = RegExp(r'[!@#$%^&*(),.?":{}|<>+\-_=~]');

    if (isEmpty) {
      return 'Required';
    }
    if (!specialCharRegEx.hasMatch(this)) {
      return 'Password must have at least one special character';
    }
    if (!digitRegEx.hasMatch(this)) {
      return 'Password must have at least one digit';
    }
    if (!letterRegEx.hasMatch(this)) {
      return 'Password must have at least one letter';
    }
    if (length < 8) {
      return 'Password must be at least 8 characters';
    }

    return null;
  }
}
