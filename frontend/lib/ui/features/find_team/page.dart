import 'package:code_connect_common/code_connect_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import '../../../utils/formatters.dart';
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
  final store = FindTeamStore();

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Observer(
        builder: (context) {
          if (store.composition case var composition?) {
            return buildResult(composition);
          }

          return _Form(
            loading: store.loading,
            onSubmit: store.findTeam,
          );
        },
      ),
    );
  }

  Widget buildResult(TeamComposition composition) => SingleChildScrollView(
        child: Text(composition.describe()),
      );
}

class _Form extends StatefulWidget {
  const _Form({
    required this.loading,
    required this.onSubmit,
  });

  final bool loading;
  final void Function(String text) onSubmit;

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> with AutoDispose {
  final inputKey = GlobalKey<_TextInputState>();
  late final controller = TextEditingController()..disposeBy(this);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Header(),
        const SizedBox(height: 24),
        Text(
          _texts.title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        _TextInput(
          key: inputKey,
          loading: widget.loading,
          controller: controller,
        ),
        const SizedBox(height: 24),
        if (!widget.loading)
          _SubmitButton(
            textController: controller,
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
    return Center(
      child: TextBuilder(
        controller: textController,
        builder: (text) => ElevatedButton(
          onPressed: onSubmit,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(width: 16),
              const SizedBox(width: 2),
              Text(_texts.submitLabel),
              const SizedBox(width: 2),
              Icon(Icons.keyboard_arrow_right, size: 20),
            ],
          ),
        ),
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
          SizedBox(height: 24),
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
        ],
      ),
    );
  }
}
