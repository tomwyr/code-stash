import 'package:flutter/material.dart';

import 'package:appwrite_graphql_client/utils/extensions/build_context_extensions.dart';
import 'package:appwrite_graphql_client/utils/functions.dart';
import 'award_medal_component.dart';
import 'widgets/athlete_form_field.dart';
import 'widgets/discipline_form_field.dart';
import 'widgets/event_form_field.dart';
import 'widgets/medal_type_form_field.dart';
import 'widgets/submit_button.dart';

class AwardMedalPage extends StatefulWidget {
  const AwardMedalPage({Key? key}) : super(key: key);

  @override
  State<AwardMedalPage> createState() => _AwardMedalPageState();
}

class _AwardMedalPageState extends State<AwardMedalPage> {
  @override
  void initState() {
    super.initState();
    runPostFrame(_listenMedalAwarded);
  }

  void _listenMedalAwarded() async {
    await context.awardMedalBloc.stream.where((state) => state.didAward).take(1).drain();

    if (!mounted) return;

    context.pop();
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          const SizedBox(height: 24),
          Text(
            'Award Medal',
            style: Theme.of(context).textTheme.headline6,
          ),
          AwardMedalContentLoadingIndicator(
            child: _buildContent(),
          ),
          const SizedBox(height: 16),
        ],
      );

  Widget _buildContent() => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: const [
            EventFormField(),
            SizedBox(height: 8),
            MedalTypeFormField(),
            SizedBox(height: 8),
            DisciplineFormField(),
            SizedBox(height: 8),
            AthleteFormField(),
            SizedBox(height: 24),
            SubmitButton(),
          ],
        ),
      );
}

class AwardMedalContentLoadingIndicator extends StatelessWidget {
  const AwardMedalContentLoadingIndicator({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) => Visibility(
        maintainState: true,
        maintainSize: true,
        maintainAnimation: true,
        visible: context.awardMedalSelect((state) => !state.isLoading && !state.didAward),
        replacement: const CircularProgressIndicator(),
        child: child,
      );
}
