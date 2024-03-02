import 'package:code_connect_common/code_connect_common.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:rust_core/result.dart';

import '../data/api.dart';
import '../utils/formatters.dart';

class FindTeamPage extends StatefulWidget {
  const FindTeamPage({super.key});

  @override
  State<FindTeamPage> createState() => _FindTeamPageState();
}

class _FindTeamPageState extends State<FindTeamPage> {
  final controller = TextEditingController(text: mockDescription);
  final teamFinder = CodeConnectApi();

  TeamComposition? composition;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: switch ((loading, composition)) {
            (true, _) => buildLoading(),
            (_, TeamComposition composition) => buildData(composition),
            _ => buildInput(),
          },
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
            decoration: const InputDecoration(
              hintText: 'Describe the project to get team composition',
            ),
          ),
          const SizedBox(height: 24),
          TextBuilder(
            controller: controller,
            builder: (text) => ElevatedButton(
              onPressed: text.isNotEmpty ? () => findTeam(text) : null,
              child: const Text('Submit'),
            ),
          ),
        ],
      );

  Widget buildLoading() => const Column(
        children: [
          Text('Finding team for the provided description...'),
          SizedBox(height: 24),
          CircularProgressIndicator(),
        ],
      );

  Widget buildData(TeamComposition composition) => SingleChildScrollView(
        child: Text(composition.describe()),
      );

  String? validateProjectDescription(String? value) {
    if (value == null || value.isEmpty) {
      return 'Cannot compose a team for a project with no description.';
    }

    return null;
  }

  void findTeam(String projectDescription) async {
    void showError(error) {
      VoidCallback closeBanner = () {};
      final banner = MaterialBanner(
        content: Text(error.toString()),
        actions: [
          CloseButton(onPressed: () => closeBanner()),
        ],
      );
      final controller = ScaffoldMessenger.of(context).showMaterialBanner(banner);
      closeBanner = controller.close;
    }

    Future<Result<TeamComposition, TeamFinderError>?> tryFindTeam() async {
      try {
        return await teamFinder.find(projectDescription);
      } on DioException catch (error) {
        if (context.mounted) {
          showError(error);
        }
        return null;
      }
    }

    void processResult(Result<TeamComposition, TeamFinderError> result) {
      switch (result) {
        case Ok(:var ok):
          setState(() {
            composition = ok;
          });
        case Err():
          showError('Could not get team composition. Try again in a few minutes.');
      }
    }

    setState(() {
      loading = true;
    });

    try {
      final result = await tryFindTeam();
      if (result != null) processResult(result);
    } finally {
      setState(() {
        loading = false;
      });
    }
  }
}

class TextBuilder extends StatelessWidget {
  const TextBuilder({
    super.key,
    required this.controller,
    required this.builder,
  });

  final TextEditingController controller;
  final Widget Function(String text) builder;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) => builder(controller.text),
    );
  }
}

const mockDescription =
    'I want to build a system that lets users purchase catering diet based on food preferences they provide in an app.';
