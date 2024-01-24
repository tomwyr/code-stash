import 'package:copy_with_extension/copy_with_extension.dart';

import 'package:appwrite_graphql_client/models/types/country.dart';
import 'register_athlete_form.dart';

part 'register_athlete_state.g.dart';

@CopyWith()
class RegisterAthleteState {
  const RegisterAthleteState({
    required this.isLoading,
    required this.didRegister,
    required this.countries,
    required this.firstNameError,
    required this.lastNameError,
    required this.genderError,
    required this.countryError,
    required this.birthdateError,
  });

  const RegisterAthleteState.initial()
      : this(
          isLoading: false,
          didRegister: false,
          countries: const [],
          firstNameError: null,
          lastNameError: null,
          genderError: null,
          countryError: null,
          birthdateError: null,
        );

  final bool isLoading;
  final bool didRegister;
  final List<Country> countries;

  final RegisterAthleteFormError? firstNameError;
  final RegisterAthleteFormError? lastNameError;
  final RegisterAthleteFormError? genderError;
  final RegisterAthleteFormError? countryError;
  final RegisterAthleteFormError? birthdateError;

  bool get canSubmit => [
        firstNameError,
        lastNameError,
        genderError,
        countryError,
        birthdateError,
      ].every((error) => error == null);
}
