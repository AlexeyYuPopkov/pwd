import 'package:flutter/material.dart';

final class NotesListVariant extends StatelessWidget {
  final Future Function(BuildContext, Object) onRoute;

  const NotesListVariant({
    super.key,
    required this.onRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(color: Colors.green),
    );
  }
}
