import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../app/layout.dart';
import '../../app/theme.dart';
import 'store.dart';

part 'texts.dart';

class FindHistoryList extends StatefulWidget {
  const FindHistoryList({super.key});

  @override
  State<FindHistoryList> createState() => _FindHistoryListState();
}

class _FindHistoryListState extends State<FindHistoryList> {
  final store = FindHistoryStore();

  @override
  void initState() {
    super.initState();
    store.loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(appTokens.contentPadding),
          child: Text(
            _texts.title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Expanded(
          child: Observer(
            builder: (context) {
              final history = store.history;
              return ListView.separated(
                itemCount: history.length,
                itemBuilder: (context, index) => _ListItem(item: history[index]),
                separatorBuilder: (context, index) => SizedBox(height: 12),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ListItem extends StatelessWidget {
  const _ListItem({
    required this.item,
  });

  final String item;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.button,
      color: colors.card,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.all(appTokens.contentPadding),
          child: Text(
            item,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
