/*
 * Copyright (c) 2022-2022.
 * System Technologies <support@st.by>.
 * Alexey Popkov <popkov_oy@st.by> is author  this file.
 * The file router_delegate_tools.dart is part of UnifiedProject.
 * UnifiedProject can not be copied and/or distributed without the express permission of System Technologies.
 */

import 'package:flutter/material.dart';
import 'package:pwd/view/router/common/page_configuration.dart';

abstract class RouterDelegateTools {
  MaterialPage createMaterialPage({
    required Widget child,
    required PageConfiguration config,
  }) =>
      MaterialPage(
        child: child,
        key: ValueKey(config.name),
        name: config.name,
        arguments: config,
      );
}
