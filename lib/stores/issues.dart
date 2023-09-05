import 'package:appwrite/appwrite.dart';
import 'package:mobx/mobx.dart';

import '../data/appwrite.dart';
import '../models/issue.dart';
import '../models/issue_vote.dart';
import 'auth.dart';

part 'issues.g.dart';

final issuesStore = IssuesStore();

class IssuesStore = IssuesStoreBase with _$IssuesStore;

abstract class IssuesStoreBase with Store {
  RealtimeSubscription? _issuesSubscription;

  final _realtime = createRealtime();
  final _databases = createDatabases();

  var _initialized = false;

  @readonly
  bool _loadingIssues = false;

  @readonly
  List<String> _togglingVotes = [];

  @readonly
  List<Issue> _issues = [];

  @action
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    try {
      await _loadIssues();
      _subscribeIssues();
    } catch (_) {
      _initialized = false;
    }
  }

  @action
  void dispose() {
    _issuesSubscription?.close();
  }

  @action
  Future<void> toggleIssueVote(String issueId) async {
    if (_togglingVotes.contains(issueId)) return;
    _togglingVotes = [..._togglingVotes, issueId];

    try {
      final issue = _toggleUserVote(issueId);
      final updatedIssue = await _updateIssue(issue);
      final updatedIssues = _replaceIssueInList(updatedIssue);

      _issues = updatedIssues;
    } finally {
      _togglingVotes = [..._togglingVotes]..remove(issueId);
    }
  }

  @action
  Future<void> _loadIssues() async {
    if (_loadingIssues) return;
    _loadingIssues = true;

    try {
      _issues = await _getIssues();
    } finally {
      _loadingIssues = false;
    }
  }

  void _subscribeIssues() {
    _issuesSubscription = _realtime.subscribe([issuesChannel])
      ..stream.listen((_) => _refreshIssues());
  }

  @action
  Future<void> _refreshIssues() async {
    _issues = await _getIssues();
  }

  Future<List<Issue>> _getIssues() async {
    final docList = await _databases.listDocuments(
      databaseId: databaseId,
      collectionId: issuesId,
    );
    return docList.documents.map((doc) => Issue.fromJson(doc.data)).toList();
  }

  Issue _toggleUserVote(String issueId) {
    final user = authStore.user;
    final issue = _issues.firstWhere((issue) => issue.id == issueId);

    final userVote = IssueVote(
      userId: user.id,
    );
    final votes = [...issue.votes, userVote];

    return issue.copyWith(votes: votes);
  }

  Future<Issue> _updateIssue(Issue issue) async {
    final doc = await _databases.updateDocument(
      databaseId: databaseId,
      collectionId: issuesId,
      documentId: issue.id,
      data: issue.toJson()..remove(idKey),
    );

    return Issue.fromJson(doc.data);
  }

  List<Issue> _replaceIssueInList(Issue newIssue) {
    final result = <Issue>[];

    for (final issue in _issues) {
      result.add(issue.id == newIssue.id ? newIssue : issue);
    }

    return result;
  }
}
