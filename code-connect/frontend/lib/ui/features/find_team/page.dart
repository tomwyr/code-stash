import 'package:code_connect_common/code_connect_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../app/layout.dart';
import '../../app/theme.dart';
import '../../app/widgets.dart';
import '../../widgets/auto_dispose.dart';
import '../../widgets/error_displayer.dart';
import '../../widgets/text_builder.dart';
import 'store.dart';

part 'input.dart';
part 'texts.dart';

class FindTeamPage extends StatefulWidget {
  const FindTeamPage({super.key});

  @override
  State<FindTeamPage> createState() => _FindTeamPageState();
}

class _FindTeamPageState extends State<FindTeamPage> with AutoDispose {
  var store = FindTeamStore();
  var controller = TextEditingController();

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
          context.showError(_texts.findingError);
        }
      },
    )..disposeBy(this);
  }

  void clearResult() {
    setState(() {
      store = FindTeamStore();
      controller = TextEditingController();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBody(
      child: Observer(
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Header(),
            const SizedBox(height: 24),
            if (store.composition case var composition?)
              Flexible(
                child: _Result(
                  composition: composition,
                  onClearResult: clearResult,
                ),
              )
            else
              Flexible(
                child: _Form(
                  loading: store.loading,
                  controller: controller,
                  onSubmit: store.findTeam,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form({
    required this.loading,
    required this.controller,
    required this.onSubmit,
  });

  final bool loading;
  final TextEditingController controller;
  final void Function(String text) onSubmit;

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> with AutoDispose {
  final inputKey = GlobalKey<_TextInputState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          _texts.formTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        _TextInput(
          key: inputKey,
          loading: widget.loading,
          controller: widget.controller,
        ),
        const SizedBox(height: 24),
        if (!widget.loading)
          _SubmitButton(
            textController: widget.controller,
            onSubmit: onSubmit,
          )
        else
          _Loading(),
      ],
    );
  }

  void onSubmit() {
    final result = inputKey.currentState!.validate();
    if (result != null) {
      widget.onSubmit(result);
    }
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!context.mobileLayout) ...[
          AppHeader(),
          const SizedBox(height: 12),
        ],
        Text(
          _texts.subHeader,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w400,
              ),
        ),
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required this.textController,
    required this.onSubmit,
  });

  final TextEditingController textController;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Center(
        child: TextBuilder(
          controller: textController,
          builder: (text) => _ActionButton(
            title: _texts.submitLabel,
            icon: Icons.keyboard_arrow_right,
            onSubmit: onSubmit,
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.title,
    required this.icon,
    required this.onSubmit,
  });

  final String title;
  final IconData icon;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onSubmit,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(width: 16),
          const SizedBox(width: 2),
          Text(title),
          const SizedBox(width: 2),
          Icon(icon, size: 20),
        ],
      ),
    );
  }
}

class _TextInput extends StatefulWidget {
  const _TextInput({
    super.key,
    required this.loading,
    required this.controller,
  });

  final bool loading;
  final TextEditingController controller;

  @override
  State<_TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<_TextInput> with AutoDispose {
  final formKey = GlobalKey<FormFieldState>();
  late final focus = FocusNode()..disposeBy(this);

  late final controller = widget.controller;

  var tooShortError = false;

  String? validate() {
    final text = controller.text.trim();

    final error = validateInput(text);
    if (error == null) return text;

    switch (error) {
      case InputError.empty:
        formKey.currentState?.validate();
        focus.requestFocus();
      case InputError.tooShort:
        showLengthError();
        focus.requestFocus();
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(hideLengthError);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: formKey,
      focusNode: focus,
      controller: controller,
      readOnly: widget.loading,
      maxLines: null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) => switch (validateInput(value)) {
        InputError.empty => _texts.inputEmptyError,
        InputError.tooShort || null => null
      },
      decoration: InputDecoration(
        hintText: _texts.inputHint,
        hintMaxLines: 5,
        hintStyle: TextStyle(
          color: colors.hint,
          fontWeight: FontWeight.w400,
        ),
        errorText: tooShortError ? _texts.inputTooShortError : null,
      ),
    );
  }

  void showLengthError() {
    if (!tooShortError) {
      setState(() => tooShortError = true);
    }
  }

  void hideLengthError() {
    if (tooShortError) {
      setState(() => tooShortError = false);
    }
  }
}

class _Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 12),
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: colors.complementary,
            ),
          ),
          SizedBox(height: 12),
          Text(
            _texts.loadingPlaceholder,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _Result extends StatelessWidget {
  const _Result({
    required this.composition,
    required this.onClearResult,
  });

  final TeamComposition composition;
  final VoidCallback onClearResult;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          composition.projectDescription,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
        ),
        const SizedBox(height: 24),
        Text(
          _texts.resultTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        Flexible(
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: [
              for (var role in composition.roles) _RoleTile(role: role),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Center(
          child: _ActionButton(
            title: _texts.startOverLabel,
            icon: Icons.restart_alt,
            onSubmit: onClearResult,
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _RoleTile extends StatelessWidget {
  const _RoleTile({required this.role});

  final ProjectRole role;

  EdgeInsets get avatarTopPadding => EdgeInsets.only(top: 4);

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(8);

    return Material(
      shape: RoundedRectangleBorder(borderRadius: radius),
      child: InkWell(
        onTap: () => launchUrlString(role.member.profileUrl),
        borderRadius: radius,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Padding(
            padding: EdgeInsets.all(context.mobileLayout ? 12 : 16) - avatarTopPadding,
            child: buildContent(context),
          ),
        ),
      ),
    );
  }

  Widget buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (context.mobileLayout)
          Row(
            children: [
              buildAvatar(),
              const SizedBox(width: 12),
              Flexible(
                child: buildMatchedSkill(context),
              ),
            ],
          )
        else
          Center(
            child: Column(
              children: [
                buildAvatar(),
                const SizedBox(height: 4),
                buildMatchedSkill(context),
              ],
            ),
          ),
        Expanded(
          child: buildSkills(context),
        ),
      ],
    );
  }

  Widget buildAvatar() {
    return Padding(
      padding: avatarTopPadding,
      child: ClipOval(
        child: Image.network(
          role.member.avatarUrl,
          width: 48,
          height: 48,
        ),
      ),
    );
  }

  Widget buildMatchedSkill(BuildContext context) {
    return Text(
      role.member.name,
      style: Theme.of(context).textTheme.titleMedium,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget buildSkills(BuildContext context) {
    final matchedSkill = role.skill.language;
    final otherSkills = role.member.skills
        .where((skill) => skill != role.skill)
        .map((skill) => skill.language)
        .join(', ');

    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Column(
            crossAxisAlignment:
                context.mobileLayout ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Text(
                _texts.matchedSkillSubtitle,
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: 2),
              Text(
                matchedSkill,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                _texts.otherSkillsSubtitle,
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: 2),
              Text(
                otherSkills,
                textAlign: context.mobileLayout ? TextAlign.start : TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
