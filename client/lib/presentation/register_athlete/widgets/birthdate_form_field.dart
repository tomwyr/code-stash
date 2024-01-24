import 'package:flutter/material.dart';

import '../register_athlete_component.dart';
import '../register_athlete_form.dart';

class BirthdateFormField extends StatefulWidget {
  const BirthdateFormField({Key? key}) : super(key: key);

  @override
  State<BirthdateFormField> createState() => _BirthdateFormFieldState();
}

class _BirthdateFormFieldState extends State<BirthdateFormField> {
  final _textController = TextEditingController();

  DateTime? _currentValue;

  @override
  Widget build(BuildContext context) => TextFormField(
        enabled: true,
        readOnly: true,
        controller: _textController,
        onTap: _onSelectBirthdate,
        decoration: InputDecoration(
          label: const Text('Birthdate'),
          errorText: context.registerAthleteSelect((state) => state.birthdateError)?.message,
        ),
      );

  void _onSelectBirthdate() async {
    final result = await _showBirthdatePicker();

    if (result == null || result == _currentValue) return;

    _currentValue = result;

    _textController.text = context.registerAthleteBloc.birthdateFormat.format(result);

    context.registerAthleteBloc.onBirthdateChange(result);
  }

  Future<DateTime?> _showBirthdatePicker() => showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(const Duration(days: 11300)),
        lastDate: DateTime.now().add(const Duration(days: 100)),
      );
}
