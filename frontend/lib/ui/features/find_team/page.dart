import 'package:code_connect_common/code_connect_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import '../../../utils/formatters.dart';
import '../../utils/auto_dispose.dart';
import '../../widgets/text_builder.dart';
import 'store.dart';
import 'texts.dart';

class FindTeamPage extends StatefulWidget {
  const FindTeamPage({super.key});

  @override
  State<FindTeamPage> createState() => _FindTeamPageState();
}

class _FindTeamPageState extends State<FindTeamPage> with AutoDispose {
  final texts = findTeamTexts;
  final store = FindTeamStore();

  late final controller = TextEditingController(
    text: texts.exampleDescription,
  )..disposeBy(this);

  @override
  void initState() {
    super.initState();
    errorReaction();
  }

  void errorReaction() {
    reaction(
      (_) => store.error,
      (error) {
        if (error != null) {
          showError(texts.findingError);
        }
      },
    )..disposeBy(this);
  }

  void showError(String error) {
    VoidCallback closeBanner = () {};
    final banner = MaterialBanner(
      content: Text(error),
      actions: [
        CloseButton(onPressed: () => closeBanner()),
      ],
    );
    final controller = ScaffoldMessenger.of(context).showMaterialBanner(banner);
    closeBanner = controller.close;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Observer(
            builder: (context) => switch (store) {
              FindTeamStore(loading: true) => buildLoading(),
              FindTeamStore(:var composition?) => buildData(composition),
              _ => buildInput(),
            },
          ),
        ),
      ),
    );
  }

  Widget buildInput() => Column(
        children: [
          TextFormField(
            maxLines: null,
            controller: controller,
            validator: validateProjectDescription,
            decoration: InputDecoration(
              hintText: texts.inputHint,
            ),
          ),
          const SizedBox(height: 24),
          TextBuilder(
            controller: controller,
            builder: (text) => ElevatedButton(
              onPressed: text.isNotEmpty ? () => store.findTeam(text) : null,
              child: Text(texts.submitLabel),
            ),
          ),
        ],
      );

  Widget buildLoading() => Column(
        children: [
          Text(texts.loadingPlaceholder),
          SizedBox(height: 24),
          CircularProgressIndicator(),
        ],
      );

  Widget buildData(TeamComposition composition) => SingleChildScrollView(
        child: Text(composition.describe()),
      );

  String? validateProjectDescription(String? value) {
    if (value == null || value.isEmpty) {
      return texts.inputEmptyError;
    }

    return null;
  }
}
