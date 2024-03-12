import 'package:code_connect_common/code_connect_common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import '../../../utils/formatters.dart';
import '../../app/theme.dart';
import '../../widgets/auto_dispose.dart';
import '../../widgets/error_displayer.dart';
import '../../widgets/text_builder.dart';
import 'store.dart';

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
  late final textParams = (
    key: GlobalKey<FormFieldState>(),
    focus: FocusNode()..disposeBy(this),
    controller: TextEditingController()..disposeBy(this),
  );

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
          loading: widget.loading,
          params: textParams,
        ),
        const SizedBox(height: 24),
        if (!widget.loading)
          _SubmitButton(
            textController: textParams.controller,
            onSubmit: onSubmit,
          )
        else
          _Loading(),
      ],
    );
  }

  void onSubmit(String text) {
    if (text.isNotEmpty) {
      widget.onSubmit(text);
    } else {
      textParams.key.currentState?.validate();
      textParams.focus.requestFocus();
    }
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Transform.translate(
              offset: Offset(-8, 0),
              child: Icon(
                Icons.keyboard_arrow_right,
                color: colors.complementary,
                size: 28,
              ),
            ),
            Transform.translate(
              offset: Offset(-12, 0),
              child: Text(
                _texts.header,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
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
  final void Function(String text) onSubmit;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextBuilder(
        controller: textController,
        builder: (text) => ElevatedButton(
          onPressed: () => onSubmit(text),
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

typedef _TextInputParams = ({
  GlobalKey key,
  FocusNode focus,
  TextEditingController controller,
});

class _TextInput extends StatelessWidget {
  const _TextInput({
    required this.loading,
    required this.params,
  });

  final bool loading;
  final _TextInputParams params;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: params.key,
      focusNode: params.focus,
      controller: params.controller,
      readOnly: loading,
      maxLines: null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return _texts.inputEmptyError;
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: _texts.inputHint,
        hintMaxLines: 5,
        hintStyle: TextStyle(
          color: colors.hint,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
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
