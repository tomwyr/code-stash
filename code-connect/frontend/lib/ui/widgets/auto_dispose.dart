import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

mixin AutoDispose<T extends StatefulWidget> on State<T> {
  final _disposers = <VoidCallback>{};

  void register(VoidCallback disposer) {
    _disposers.add(disposer);
  }

  @override
  void dispose() {
    super.dispose();
    for (var disposer in _disposers) disposer();
  }
}

extension ReactionDisposerDisposeBy on ReactionDisposer {
  void disposeBy(AutoDispose autoDispose) {
    autoDispose.register(this);
  }
}

extension TextEditingControllerDisposeBy on TextEditingController {
  void disposeBy(AutoDispose autoDispose) {
    autoDispose.register(dispose);
  }
}

extension FocusNodeDispose on FocusNode {
  void disposeBy(AutoDispose autoDispose) {
    autoDispose.register(dispose);
  }
}
