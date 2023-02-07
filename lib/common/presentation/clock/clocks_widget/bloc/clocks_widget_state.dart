part of 'clocks_widget_bloc.dart';

abstract class ClocksWidgetState extends Equatable {
  final NotePageData data;

  const ClocksWidgetState({required this.data});

  bool get isEditing => this is EditingState;
  @override
  List<Object?> get props => [data];

  const factory ClocksWidgetState.common({required NotePageData data}) =
      CommonState;

  const factory ClocksWidgetState.editing({required NotePageData data}) =
      EditingState;
}

class CommonState extends ClocksWidgetState {
  const CommonState({required super.data});
}

class EditingState extends ClocksWidgetState {
  const EditingState({required super.data});
}

// Data
class NotePageData extends Equatable {
  final List<ClockModel> parameters;

  const NotePageData._({
    required this.parameters,
  });

  factory NotePageData.initial() => const NotePageData._(parameters: []);

  @override
  List<Object?> get props => [parameters];

  NotePageData copyWith({
    List<ClockModel>? parameters,
  }) =>
      NotePageData._(
        parameters: parameters ?? this.parameters,
      );
}

class DefaultClockModel extends ClockModel {
  DefaultClockModel._({required super.label, required super.timezoneOffset});

  factory DefaultClockModel({
    required String label,
  }) =>
      DefaultClockModel._(
        label: label,
        timezoneOffset: DateTime.now().timeZoneOffset,
      );
}