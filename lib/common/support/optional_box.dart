import 'package:equatable/equatable.dart';

final class OptionalBox<T> extends Equatable {
  final T? data;

  const OptionalBox(this.data);

  factory OptionalBox.empty() => OptionalBox<T>(null);

  @override
  List<Object?> get props => [data];
}
