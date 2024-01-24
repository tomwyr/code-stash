import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import '../../models/new_issue.dart';
import '../../stores/new_issue.dart';
import 'common/app_modal.dart';

class NewIssueModal extends StatefulWidget {
  const NewIssueModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const NewIssueModal(),
      ),
    );
  }

  @override
  State<NewIssueModal> createState() => _NewIssueModalState();
}

class _NewIssueModalState extends State<NewIssueModal> {
  late final ReactionDisposer _disposer;

  var _currentValue = '';

  @override
  void initState() {
    super.initState();
    _disposer = when(
      (_) => newIssueStore.createdIssue != null,
      () => Navigator.of(context).pop(),
    );
  }

  @override
  void dispose() {
    _disposer();
    newIssueStore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final loading = newIssueStore.loading;

        return AppModal(
          title: 'New Issue',
          content: TextField(
            autofocus: true,
            enabled: !loading,
            decoration: const InputDecoration(
              hintText: 'Enter the issue ...',
            ),
            onChanged: (value) {
              setState(() => _currentValue = value.trim());
            },
          ),
          actionLabel: 'Add',
          onAction: !loading && _currentValue.isNotEmpty
              ? () => newIssueStore.createIssue(NewIssue(
                    title: _currentValue,
                  ))
              : null,
        );
      },
    );
  }
}
