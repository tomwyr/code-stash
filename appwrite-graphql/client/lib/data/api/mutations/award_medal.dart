const awardMedalMutation = r'''
mutation AwardMedal($input: MedalInput!) {
  awardMedal(input: $input) {
    id
    date
    event
    type
    athlete {
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
    discipline {
      id
      name
      code
    }
  }
}
''';
