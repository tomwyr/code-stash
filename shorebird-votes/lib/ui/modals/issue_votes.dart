import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../stores/issues.dart';
import 'common/app_modal.dart';

class IssueVotesModal extends StatelessWidget {
  const IssueVotesModal({
    super.key,
    required this.issueId,
  });

  final String issueId;

  static void show(
    BuildContext context, {
    required String issueId,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => IssueVotesModal(issueId: issueId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final issue = issuesStore.issues.firstWhere((issue) => issue.id == issueId);

        return AppModal(
          title: 'Issue votes',
          content: LimitedBox(
            maxHeight: 200,
            child: ListView(
              children: [
                if (issue.votes.isEmpty)
                  const ListTile(
                    title: Text(
                      'No votes yet',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                else ...[
                  for (final vote in issue.votes)
                    ListTile(
                      title: Text(vote.userName),
                    ),
                ],
              ],
            ),
          ),
          actionLabel: 'Close',
          onAction: Navigator.of(context).pop,
        );
      },
    );
  }
}
