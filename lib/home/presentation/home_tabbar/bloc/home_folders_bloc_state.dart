import 'package:equatable/equatable.dart';
import 'home_folders_bloc_data.dart';

sealed class HomeFoldersBlocState extends Equatable {
  final HomeFoldersBlocData data;

  const HomeFoldersBlocState({required this.data});

  @override
  List<Object?> get props => [data];

  const factory HomeFoldersBlocState.common({
    required HomeFoldersBlocData data,
  }) = CommonState;

  const factory HomeFoldersBlocState.loading({
    required HomeFoldersBlocData data,
  }) = LoadingState;

  const factory HomeFoldersBlocState.error({
    required HomeFoldersBlocData data,
    required Object e,
  }) = ErrorState;
}

final class CommonState extends HomeFoldersBlocState {
  const CommonState({required super.data});
}

final class LoadingState extends HomeFoldersBlocState {
  const LoadingState({required super.data});
}

final class ErrorState extends HomeFoldersBlocState {
  final Object e;
  const ErrorState({
    required super.data,
    required this.e,
  });
}
