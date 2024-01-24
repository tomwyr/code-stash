const athleteRegisteredSubscription = '''
subscription AthleteRegistered {
  athleteRegistered {
    id
    name
    gender
    birthdate
    country {
      id
      name
      code
    }
  }
}
''';
