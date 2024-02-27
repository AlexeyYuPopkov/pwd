import 'package:flutter/material.dart';
import 'package:pwd/common/domain/model/remote_configuration/remote_configuration.dart';

import 'git_configuration_form.dart';

final class GitConfigurationScreen extends StatelessWidget {
  final GitConfiguration? initial;
  const GitConfigurationScreen({super.key, required this.initial});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: GitConfigurationForm(initial: initial),
        ),
      ),
    );
  }
}
