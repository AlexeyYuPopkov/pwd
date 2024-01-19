import 'package:googleapis/drive/v3.dart' as drive;
import 'package:pwd/notes/domain/model/google_file.dart';

final class GoogleFileMapper {
  static GoogleFile? toDomain(drive.File src) {
    final id = src.id;
    final name = src.name;

    final isValid =
        id != null && id.isNotEmpty && name != null && name.isNotEmpty;

    return isValid
        ? GoogleFile(
            id: id,
            checksum: src.md5Checksum ?? '',
            name: name,
          )
        : null;
  }
}
