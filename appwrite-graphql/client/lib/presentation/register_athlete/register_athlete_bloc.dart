import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:appwrite_graphql_client/data/repositories/athlete_repository.dart';
import 'package:appwrite_graphql_client/data/repositories/country_repository.dart';
import 'package:appwrite_graphql_client/models/inputs/athlete_input.dart';
import 'package:appwrite_graphql_client/models/types/country.dart';
import 'package:appwrite_graphql_client/models/types/gender.dart';
import 'package:appwrite_graphql_client/utils/extensions/string_extensions.dart';
import 'register_athlete_form.dart';
import 'register_athlete_state.dart';

class RegisterAthleteBloc extends Cubit<RegisterAthleteState> {
  RegisterAthleteBloc({
    required this.countryRepository,
    required this.athleteRepository,
  }) : super(const RegisterAthleteState.initial());

  final CountryRepository countryRepository;
  final AthleteRepository athleteRepository;

  final birthdateFormat = DateFormat('yyyy-MM-dd');

  String? _firstName;
  String? _lastName;
  Gender? _gender;
  Country? _country;
  DateTime? _birthdate;

  void onInit() async {
    emit(state.copyWith(
      isLoading: true,
    ));

    try {
      final countries = await countryRepository.getCountries();

      emit(state.copyWith(
        countries: countries,
      ));
    } finally {
      emit(state.copyWith(
        isLoading: false,
      ));
    }
  }

  void onFirstNameChange(String? value) {
    _firstName = value;

    final error = _validateNotEmpty(value);

    emit(state.copyWith(
      firstNameError: error,
    ));
  }

  void onLastNameChange(String? value) {
    _lastName = value;

    final error = _validateNotEmpty(value);

    emit(state.copyWith(
      lastNameError: error,
    ));
  }

  void onGenderChange(Gender? value) {
    _gender = value;

    final error = _validateNotEmpty(value);

    emit(state.copyWith(
      genderError: error,
    ));
  }

  void onCountryChange(Country? value) {
    _country = value;

    final error = _validateNotEmpty(value);

    emit(state.copyWith(
      countryError: error,
    ));
  }

  void onBirthdateChange(DateTime? value) {
    _birthdate = value;

    final error = _validateNotEmpty(value) ?? _validateAdult(value!);

    emit(state.copyWith(
      birthdateError: error,
    ));
  }

  void onSubmit() {
    if (state.didRegister) return;

    _validateEmptyInputs();

    if (!state.canSubmit) return;

    _registerAthlete();
  }

  RegisterAthleteFormError? _validateNotEmpty<T>(T? value) {
    final isEmpty = value == null || (value is String && value.isEmpty);

    return isEmpty ? RegisterAthleteFormError.valueEmpty : null;
  }

  RegisterAthleteFormError? _validateAdult(DateTime value) {
    final now = DateTime.now();

    final adultMinBirthdate = DateTime(now.year - 18, now.month, now.day);
    final isAdult = value.isAfter(adultMinBirthdate);

    return isAdult ? RegisterAthleteFormError.birthdateUnderage : null;
  }

  void _validateEmptyInputs() {
    if (_firstName == null) onFirstNameChange(_firstName);
    if (_lastName == null) onLastNameChange(_lastName);
    if (_gender == null) onGenderChange(_gender);
    if (_country == null) onCountryChange(_country);
    if (_birthdate == null) onBirthdateChange(_birthdate);
  }

  void _registerAthlete() async {
    emit(state.copyWith(
      isLoading: true,
    ));

    try {
      final input = _createAthleteInput();

      await athleteRepository.registerAthlete(input);

      emit(state.copyWith(
        didRegister: true,
      ));
    } finally {
      emit(state.copyWith(
        isLoading: false,
      ));
    }
  }

  AthleteInput _createAthleteInput() {
    final upperFirstName = _firstName!.toUpperCase();
    final titleLastName = _lastName!.toTitleCase();
    final name = '$titleLastName $upperFirstName';

    final birthdate = birthdateFormat.format(_birthdate!);

    return AthleteInput(
      name: name,
      gender: _gender!,
      birthdate: birthdate,
      countryCode: _country!.code,
    );
  }
}
