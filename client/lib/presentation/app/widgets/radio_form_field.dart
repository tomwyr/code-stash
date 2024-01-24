import 'package:flutter/material.dart';

typedef RadioItemBuilder<T> = Widget Function(BuildContext context, Widget radio);

class RadioItem<T> {
  RadioItem({
    required this.value,
    required this.child,
  });

  final T value;
  final Widget child;
}

class RadioInputDecoration {
  const RadioInputDecoration({
    this.label,
    this.errorText,
  });

  final Widget? label;
  final String? errorText;
}

class RadioFormField<T> extends StatelessWidget {
  const RadioFormField({
    Key? key,
    required this.items,
    required this.onChanged,
    this.initialValue,
    this.decoration = const InputDecoration(),
  }) : super(key: key);

  final T? initialValue;
  final List<RadioItem<T>> items;
  final ValueChanged<T> onChanged;
  final InputDecoration decoration;

  @override
  Widget build(BuildContext context) => InputDecorator(
        decoration: decoration,
        child: FormField<T>(
          builder: (state) => Wrap(
            children: items.map((item) => _buildItem(item, state)).toList(),
          ),
        ),
      );

  Widget _buildItem(RadioItem<T> item, FormFieldState<T> state) => InkWell(
        onTap: () => _onItemTap(item, state),
        customBorder: const CircleBorder(),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: item.value == state.value ? 1 : 0.25,
          child: item.child,
        ),
      );

  void _onItemTap(RadioItem<T> item, FormFieldState<T> state) {
    if (state.value == item.value) return;

    state.didChange(item.value);
    onChanged(item.value);
  }
}
