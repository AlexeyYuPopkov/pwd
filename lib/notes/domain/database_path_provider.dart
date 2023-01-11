import 'package:flutter/foundation.dart';

abstract class DatabasePathProvider {
  Future<String> get path;
  Future<Uint8List?> get bytes;
}
