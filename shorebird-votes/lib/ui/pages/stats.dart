import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../models/issue.dart';
import '../../stores/issues.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  String? _selectedIssueId;

  void _onIssueSelected(String issueId) {
    setState(() {
      _selectedIssueId = issueId != _selectedIssueId ? issueId : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stats'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Observer(
          builder: (context) {
            final issues = issuesStore.issues;

            return Column(
              children: [
                SizedBox(
                  height: 300,
                  child: IssuesChart(
                    issues: issues,
                    selectedIssueId: _selectedIssueId,
                    onIssueSelected: _onIssueSelected,
                  ),
                ),
                const SizedBox(height: 48),
                Expanded(
                  child: IssuesChartList(
                    issues: issues,
                    selectedIssueId: _selectedIssueId,
                    onIssueSelected: _onIssueSelected,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class IssuesChart extends StatefulWidget {
  const IssuesChart({
    super.key,
    required this.issues,
    required this.selectedIssueId,
    required this.onIssueSelected,
  });

  final List<Issue> issues;
  final String? selectedIssueId;
  final ValueChanged<String> onIssueSelected;

  @override
  State<IssuesChart> createState() => _IssuesChartState();
}

class _IssuesChartState extends State<IssuesChart> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const noTitles = AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    );

    final maxVotesCount = widget.issues.map((issue) => issue.votes.length).reduce(max).toDouble();

    return BarChart(
      BarChartData(
        minY: 0,
        maxY: maxVotesCount,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: const FlTitlesData(
          bottomTitles: noTitles,
          rightTitles: noTitles,
          topTitles: noTitles,
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
            ),
          ),
        ),
        barGroups: [
          for (final (index, issue) in widget.issues.indexed)
            BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  width: 16,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                  toY: issue.votes.isNotEmpty ? issue.votes.length.toDouble() : 0.01,
                  color: widget.selectedIssueId == null || issue.id == widget.selectedIssueId
                      ? theme.colorScheme.primary
                      : theme.colorScheme.primaryContainer,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class IssuesChartList extends StatelessWidget {
  const IssuesChartList({
    super.key,
    required this.issues,
    required this.selectedIssueId,
    required this.onIssueSelected,
  });

  final List<Issue> issues;
  final String? selectedIssueId;
  final ValueChanged<String> onIssueSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      children: [
        for (final issue in issuesStore.issues)
          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            selectedTileColor: theme.colorScheme.primaryContainer,
            selected: issue.id == selectedIssueId,
            onTap: () => onIssueSelected(issue.id),
            title: Text(issue.title),
            trailing: Text('${issue.votes.length}'),
          ),
      ],
    );
  }
}

extension ListExtensions<T> on List<T> {
  Iterable<(int index, T element)> get indexed sync* {
    for (var index = 0; index < length; index++) {
      yield (index, this[index]);
    }
  }
}
