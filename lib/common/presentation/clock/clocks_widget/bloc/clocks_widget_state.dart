part of 'clocks_widget_bloc.dart';

sealed class ClocksWidgetState extends Equatable {
  final ClocksWidgetData data;

  const ClocksWidgetState({required this.data});

  @override
  List<Object?> get props => [data];

  const factory ClocksWidgetState.common({required ClocksWidgetData data}) =
      CommonState;

  const factory ClocksWidgetState.editing({
    required ClocksWidgetData data,
    required ClockModel clock,
  }) = EditingState;
}

final class CommonState extends ClocksWidgetState {
  const CommonState({required super.data});
}

final class EditingState extends ClocksWidgetState {
  final ClockModel clock;
  const EditingState({required super.data, required this.clock});
}

// Data
final class ClocksWidgetData extends Equatable {
  final List<ClockModel> clocks;

  const ClocksWidgetData._({
    required this.clocks,
  });

  factory ClocksWidgetData.initial() => const ClocksWidgetData._(clocks: []);

  @override
  List<Object?> get props => [clocks];

  ClocksWidgetData copyWith({
    List<ClockModel>? clocks,
  }) =>
      ClocksWidgetData._(
        clocks: clocks ?? this.clocks,
      );
}
