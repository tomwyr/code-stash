import '../../../code_connect_common.dart';

void registerCommonJsonTypes() {
  addJsonType(TeamFinderError.fromJson);
  addJsonType(FindTeamInput.fromJson);
  addJsonType(TeamComposition.fromJson);
  addJsonType(ProjectRole.fromJson);
  addJsonType(TeamMember.fromJson);
}
