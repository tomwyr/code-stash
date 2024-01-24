const medalsQuery = r'''
query Medals {
  medals {
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
