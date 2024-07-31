import 'package:equatable/equatable.dart';

import 'package:pwd/home/presentation/home_tabbar/folder_model.dart';

final class HomeFoldersBlocData extends Equatable {
  final int index;
  final List<FolderModel> folders;

  const HomeFoldersBlocData._({required this.index, required this.folders});

  factory HomeFoldersBlocData.initial() {
    return const HomeFoldersBlocData._(
      index: 0,
      folders: [],
    );
  }

  @override
  List<Object?> get props => [folders, index];

  HomeFoldersBlocData copyWith({
    int? index,
    List<FolderModel>? folders,
  }) {
    if (index != null) {
      assert(index >= 0);
      if (index < 0) {
        return this;
      }
    }

    return HomeFoldersBlocData._(
      index: index ?? this.index,
      folders: folders ?? this.folders,
    );
  }
}
