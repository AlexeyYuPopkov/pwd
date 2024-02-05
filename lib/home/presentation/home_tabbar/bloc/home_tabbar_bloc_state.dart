import 'package:equatable/equatable.dart';
import 'home_tabbar_bloc_data.dart';

sealed class HomeTabbarBlocState extends Equatable {
  final HomeTabbarBlocData data;

  const HomeTabbarBlocState({required this.data});

  @override
  List<Object?> get props => [data];

  const factory HomeTabbarBlocState.common({
    required HomeTabbarBlocData data,
  }) = CommonState;

  const factory HomeTabbarBlocState.loading({
    required HomeTabbarBlocData data,
  }) = LoadingState;

  const factory HomeTabbarBlocState.error({
    required HomeTabbarBlocData data,
    required Object e,
  }) = ErrorState;
}

final class CommonState extends HomeTabbarBlocState {
  const CommonState({required super.data});
}

final class LoadingState extends HomeTabbarBlocState {
  const LoadingState({required super.data});
}

final class ErrorState extends HomeTabbarBlocState {
  final Object e;
  const ErrorState({
    required super.data,
    required this.e,
  });
}
