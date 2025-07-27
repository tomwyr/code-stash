import 'package:appwrite/appwrite.dart';
import 'package:mobx/mobx.dart';

import '../data/appwrite.dart';
import '../models/app_info.dart';

part 'app_info.g.dart';

final appInfoStore = AppInfoStore();

class AppInfoStore = AppInfoStoreBase with _$AppInfoStore;

abstract class AppInfoStoreBase with Store {
  RealtimeSubscription? _appInfoSubscription;

  final _realtime = createRealtime();
  final _databases = createDatabases();

  var _initialized = false;

  @readonly
  AppInfo? _appInfo;

  @action
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    _appInfoSubscription = _realtime.subscribe([appInfoChannel])
      ..stream.listen((_) => _refreshAppInfo());
  }

  @action
  void dispose() {
    _appInfoSubscription?.close();
    _initialized = false;
    _appInfo = null;
  }

  @action
  Future<void> _refreshAppInfo() async {
    final doc = await _databases.getDocument(
      databaseId: databaseId,
      collectionId: appInfoId,
      documentId: DocumentId.appInfo,
    );
    final appInfo = AppInfo.fromJson(doc.data);

    _appInfo = appInfo;
  }
}
