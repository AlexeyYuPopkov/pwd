import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pwd/common/presentation/shimmer/common_shimmer.dart';
import 'package:pwd/notes/presentation/note_details/bloc/note_details_screen_bloc.dart';
import 'package:pwd/notes/presentation/note_details/bloc/note_details_screen_state.dart';
import 'package:pwd/notes/presentation/note_details/note_details_screen.dart';
import 'package:pwd/notes/presentation/note_details/widgets/note_line.dart';

final class NoteDetailsScreenFinders {
  late final screen = find.byType(NoteDetailsScreen);

  NoteDetailsScreenBloc bloc(WidgetTester tester) =>
      tester.element(firstBlocConsumer).read<NoteDetailsScreenBloc>();

  late final firstBlocConsumer = find.descendant(
    of: screen,
    matching: find
        .byType(BlocConsumer<NoteDetailsScreenBloc, NoteDetailsScreenState>)
        .first,
  );

  late final shimmers = find.descendant(
    of: firstBlocConsumer,
    matching: find.byType(CommonShimmer),
  );

  late final notes = find.descendant(
    of: firstBlocConsumer,
    matching: find.byType(NoteLine),
  );
}
