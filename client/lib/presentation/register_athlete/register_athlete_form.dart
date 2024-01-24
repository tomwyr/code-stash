enum RegisterAthleteFormError {
  valueEmpty,
  birthdateUnderage,
}

extension RegisterAthleteFormErrorMessage on RegisterAthleteFormError {
  String get message {
    switch (this) {
      case RegisterAthleteFormError.valueEmpty:
        return 'This field is required';
      case RegisterAthleteFormError.birthdateUnderage:
        return 'Has to 18 years old';
    }
  }
}
