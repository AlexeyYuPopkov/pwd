import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:pwd/common/domain/model/remote_configuration/local_storage_target.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';
import 'package:realm/realm.dart';

abstract interface class RealmProvider {
  Future<Realm> getRealm({
    required LocalStorageTarget target,
  });

  Future<Realm> getTempRealm({
    required LocalStorageTarget target,
    required Uint8List bytes,
  });

  Future<void> deleteCacheFileIfPresent({
    required CacheTarget target,
  });

  Future<void> deleteTempFolderIfPresent({
    required CacheTarget target,
  });

  Future<Uint8List> readAsBytes({
    required LocalStorageTarget target,
  });
}
