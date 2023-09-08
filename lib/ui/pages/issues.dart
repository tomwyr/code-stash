import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../models/issue.dart';
import '../../stores/auth.dart';
import '../../stores/issues.dart';
import '../modals/issue_votes.dart';
import '../modals/new_issue.dart';

class IssuesPage extends StatefulWidget {
  const IssuesPage({super.key});

  @override
  State<IssuesPage> createState() => _IssuesPageState();
}

class _IssuesPageState extends State<IssuesPage> {
  @override
  void initState() {
    super.initState();
    issuesStore.initialize();
  }

  @override
  void dispose() {
    issuesStore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Issues'),
        actions: [
          Observer(
            builder: (context) => IconButton(
              onPressed: !authStore.loading ? authStore.logOut : null,
              icon: const Icon(Icons.exit_to_app),
            ),
          ),
        ],
      ),
      body: Observer(
        builder: (context) {
          final (loadingIssues, issues) = (issuesStore.loadingIssues, issuesStore.issues);

          if (loadingIssues) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (issues.isEmpty) {
            return const Center(
              child: Text('No issues found.'),
            );
          }

          return ListView.builder(
            itemCount: issues.length,
            itemBuilder: (context, index) => IssueTile(
              issue: issues[index],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => NewIssueModal.show(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class IssueTile extends StatelessWidget {
  const IssueTile({
    super.key,
    required this.issue,
  });

  final Issue issue;

  @override
  Widget build(BuildContext context) {
    final Issue(id: issueId, :title, votes: votes) = issue;
    final userId = authStore.user.id;
    final votedByUser = votes.any((vote) => vote.userId == userId);

    final color = votedByUser ? Colors.green : null;

    return ListTile(
      onTap: () => IssueVotesModal.show(context, issueId: issueId),
      title: Text(title),
      trailing: Observer(
        builder: (context) {
          final loading = issuesStore.togglingVotes.contains(issueId);

          if (loading) {
            return Container(
              width: 16,
              height: 16,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: const CircularProgressIndicator(
                strokeWidth: 2,
              ),
            );
          }

          return IconButton(
            onPressed: () => issuesStore.toggleIssueVote(issueId),
            icon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.arrow_drop_up,
                  color: color,
                ),
                Text(
                  '${votes.length}',
                  style: TextStyle(
                    fontSize: 14,
                    color: color,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
