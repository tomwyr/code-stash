const registerAthleteMutation = r'''
mutation RegisterAthlete($input: AthleteInput!) {
  registerAthlete(input: $input) {
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
