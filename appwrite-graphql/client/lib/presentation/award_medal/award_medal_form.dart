enum AwardMedalFormError {
  valueEmpty,
}

extension AwardMedalFormErrorMessage on AwardMedalFormError {
  String get message {
    switch (this) {
      case AwardMedalFormError.valueEmpty:
        return 'This field is required';
    }
  }
}
