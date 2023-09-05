import 'package:mobx/mobx.dart';

import '../data/appwrite.dart';
import '../models/issue.dart';
import '../models/new_issue.dart';

part 'new_issue.g.dart';

final newIssueStore = NewIssueStore();

class NewIssueStore = NewIssueStoreBase with _$NewIssueStore;

abstract class NewIssueStoreBase with Store {
  @readonly
  bool _loading = false;

  @readonly
  Issue? _createdIssue;

  @action
  Future<void> createIssue(NewIssue newIssue) async {
    if (_loading) return;
    _loading = true;

    try {
      final doc = await databases.createDocument(
        databaseId: databaseId,
        collectionId: issuesId,
        documentId: DocumentId.unique,
        data: newIssue.toJson(),
      );

      _createdIssue = Issue.fromJson(doc.data);
    } finally {
      _loading = false;
    }
  }

  @action
  void dispose() {
    _loading = false;
    _createdIssue = null;
  }
}
