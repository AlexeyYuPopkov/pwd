import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pwd/common/common_sizes.dart';
import 'package:pwd/view/router/main_page_action.dart';

import 'bloc/note_page_bloc.dart';

class NotePage extends StatelessWidget {
  final void Function(BuildContext, MainPageAction) onRoute;

  const NotePage({
    Key? key,
    required this.onRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.pageTitle),
        actions: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () => onRoute(context, const MainPageAction.onEdit()),
            child: const IconButton(
              icon: Icon(Icons.add),
              onPressed: null,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => NotePageBloc(),
          child: BlocConsumer<NotePageBloc, NotePageState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Text('text'),
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return const SizedBox();
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                        height: CommonSizes.indent,
                      ),
                      itemCount: state.data.items.length,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

extension on BuildContext {
  String get pageTitle => 'Note';
}
