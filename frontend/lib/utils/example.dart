import 'dart:io';

import '../api.dart';
import 'formatters.dart';
import 'package:flutter/material.dart';
import 'package:rust_core/result.dart';

void example() async {
  debugPrint('');
  debugPrint('Describe the project to get team composition:');
  final description = stdin.readLineSync();

  debugPrint('');
  debugPrint('Finding team for the provided description...');

  if (description == null || description.isEmpty) {
    debugPrint('');
    debugPrint('Cannot compose a team for a project with no description.');
    return;
  }

  debugPrint('');
  final result = await CodeConnectApi().findTeam(description);
  switch (result) {
    case Ok(ok: var team):
      debugPrint(team.describe());
    case Err():
      debugPrint('Could not get team composition. Try again in a few minutes.');
  }
}
