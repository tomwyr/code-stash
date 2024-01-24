import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

class UpdateChecker extends StatefulWidget {
  const UpdateChecker({
    super.key,
    required this.child,
    this.checkUpdateNotifier,
  });

  final Widget child;
  final ChangeNotifier? checkUpdateNotifier;

  @override
  State<UpdateChecker> createState() => _UpdateCheckerState();
}

class _UpdateCheckerState extends State<UpdateChecker> with ShorebirdMixin {
  late final checkUpdateNotifier = widget.checkUpdateNotifier;

  ScaffoldMessengerState get scaffold => ScaffoldMessenger.of(context);

  @override
  void initState() {
    super.initState();
    Future(checkForUpdate);
    checkUpdateNotifier?.addListener(checkForUpdate);
  }

  @override
  void dispose() {
    checkUpdateNotifier?.removeListener(checkForUpdate);
    super.dispose();
  }

  void checkForUpdate() async {
    if (isCodePushAvailable()) {
      if (await canDownloadPatch() && await showDownloadAvailable()) {
        final download = downloadPatch();
        await showPatchDownloading(download);
      }

      if (await canInstallPatch()) {
        await showInstallAvailable();
      }
    }
  }

  Future<bool> showDownloadAvailable() async {
    var result = false;

    late ScaffoldFeatureController controller;
    controller = scaffold.showMaterialBanner(MaterialBanner(
      content: const Text('Update available to download.'),
      actions: [
        TextButton(
          child: const Text('Dismiss'),
          onPressed: () {
            controller.close();
          },
        ),
        TextButton(
          child: const Text('Download'),
          onPressed: () {
            result = true;
            controller.close();
          },
        ),
      ],
    ));

    await controller.closed;

    return result;
  }

  Future<void> showPatchDownloading(Future<void> download) async {
    final controller = scaffold.showMaterialBanner(const MaterialBanner(
      content: Row(
        children: [
          Text('Downloading...'),
          SizedBox(width: 12),
          SizedBox.square(
            dimension: 12,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ],
      ),
      actions: [SizedBox.shrink()],
    ));

    await download;

    controller.close();
  }

  Future<void> showInstallAvailable() async {
    late ScaffoldFeatureController controller;
    controller = scaffold.showMaterialBanner(MaterialBanner(
      content: const Text('Update ready to install. Restart app to update.'),
      actions: [
        TextButton(
          child: const Text('Close'),
          onPressed: () {
            controller.close();
          },
        ),
      ],
    ));

    await controller.closed;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

mixin ShorebirdMixin {
  final _shorebird = ShorebirdCodePush();

  late final isCodePushAvailable = _shorebird.isShorebirdAvailable;
  late final canDownloadPatch = _shorebird.isNewPatchAvailableForDownload;
  late final downloadPatch = _shorebird.downloadUpdateIfAvailable;
  late final canInstallPatch = _shorebird.isNewPatchReadyToInstall;
}
