import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pwd/common/common_sizes.dart';
import 'package:pwd/common/presentation/common_highlighted_row.dart';
import 'package:pwd/common/tools/di_storage/di_storage.dart';
import 'package:pwd/notes/domain/model/note_item.dart';
import 'package:pwd/common/presentation/blocking_loading_indicator.dart';
import 'package:pwd/notes/domain/notes_provider_impl.dart';
import 'package:pwd/notes/presentation/edit_note/edit_note_page.dart';
import 'package:pwd/notes/presentation/router/main_route_data.dart';

import 'bloc/note_page_bloc.dart';

class NotePage extends StatelessWidget {
  final Future Function(BuildContext, MainRouteData) onRoute;

  const NotePage({
    Key? key,
    required this.onRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final gateway = DiStorage.shared.resolve<NotesProvider>();
        return NotePageBloc(
          gateway: gateway,
        );
      },
      child: BlocConsumer<NotePageBloc, NotePageState>(
        listener: _listener,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(context.pageTitle),
              actions: [
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => _onEditButton(
                    context,
                    noteItem: NoteItem.newItem(),
                  ),
                  child: const IconButton(
                    icon: Icon(Icons.add),
                    onPressed: null,
                  ),
                ),
              ],
            ),
            body: SafeArea(
              child: BlocBuilder<NotePageBloc, NotePageState>(
                builder: (context, state) {
                  // debugPrint('rebuilding ...');
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        // Text('text'),
                        CupertinoButton(
                          onPressed: () {},
                          child: const Text('test button'),
                        ),
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final item = state.data.notes[index];
                            return CommonHighlightedRow(
                              highlightedColor: Colors.grey.shade200,
                              onTap: () => _onEditButton(
                                context,
                                noteItem: item,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: CommonSizes.doubleIndent,
                                  vertical: CommonSizes.doubleIndent,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.id,
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                    Text(
                                      item.title,
                                      style:
                                          const TextStyle(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                            height: CommonSizes.indent,
                          ),
                          itemCount: state.data.notes.length,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _listener(BuildContext context, NotePageState state) {
    BlockingLoadingIndicator.of(context).isLoading = state is LoadingState;
  }

  void _onEditButton(BuildContext context, {required NoteItem noteItem}) =>
      onRoute(
        context,
        MainRouteData.onEdit(noteItem: noteItem),
      ).then(
        (result) {
          if (result is NoteItem) {
            context.read<NotePageBloc>().add(
                  NotePageEvent.shouldUpdateNote(
                    noteItem: result,
                  ),
                );
          }
        },
      );
}

extension on BuildContext {
  String get pageTitle => 'Note';
}
