const athletesQuery = r'''
query Athletes {
  athletes {
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
