import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

import '../../../stores/app_info.dart';
import 'update_checker.dart';

class UpdateNotifier extends StatefulWidget {
  const UpdateNotifier({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<UpdateNotifier> createState() => _UpdateNotifierState();
}

class _UpdateNotifierState extends State<UpdateNotifier> with ChangeNotifier {
  late final ReactionDisposer _disposer;

  var _lastPatchTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    appInfoStore.initialize();
    _disposer = reaction(
      (_) => appInfoStore.appInfo?.patchTime,
      _onPatchTimeChanged,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _disposer();
    appInfoStore.dispose();
  }

  void _onPatchTimeChanged(DateTime? patchTime) {
    if (patchTime != null && patchTime.isAfter(_lastPatchTime)) {
      _lastPatchTime = patchTime;
      notifyListeners();
    }
  }

  @override
  Widget build(BuildContext context) {
    return UpdateChecker(
      checkUpdateNotifier: this,
      child: widget.child,
    );
  }
}
