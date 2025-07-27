class Queries {
  static String techStack(String projectDescription) => '''
What tech stack would be best to develop the following application:
$projectDescription
'''
      .trim();

  static final skills = '''
What programming languages would be needed to use this tech stack. List the languages separated by comma.
'''
      .trim();
}
