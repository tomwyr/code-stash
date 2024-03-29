part of 'page.dart';

const inputMinLength = 30;

enum InputError {
  empty,
  tooShort,
}

InputError? validateInput(String? value) {
  if (value == null || value.isEmpty) {
    return InputError.empty;
  }
  if (value.length < inputMinLength) {
    return InputError.tooShort;
  }
  return null;
}
