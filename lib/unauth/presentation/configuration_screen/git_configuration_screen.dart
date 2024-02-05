import 'package:flutter/material.dart';

import 'git_configuration_form.dart';

final class GitConfigurationScreen extends StatelessWidget {
  const GitConfigurationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const SafeArea(child: GitConfigurationForm()),
    );
  }
}
