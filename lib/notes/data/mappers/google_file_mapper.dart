import 'package:googleapis/drive/v3.dart' as drive;
import 'package:pwd/notes/domain/model/google_drive_file.dart';

final class GoogleFileMapper {
  static GoogleDriveFile? toDomain(drive.File src) {
    final id = src.id;
    final name = src.name;

    final isValid =
        id != null && id.isNotEmpty && name != null && name.isNotEmpty;

    return isValid
        ? GoogleDriveFile(
            id: id,
            checksum: src.md5Checksum ?? '',
            name: name,
          )
        : null;
  }
}
