import 'dart:io';

import 'package:mason/mason.dart';

void run(HookContext context) async {
  final feature = context.vars['feature_name'];

  final format = await Process.run('dart', ['format', 'lib/src/app/features/$feature', 'test/unit/$feature']);
  if (format.exitCode != 0) {
    context.logger.warn('dart format failed - run it manually: dart format lib/src/app/features/$feature test/unit/$feature');
  }

  context.logger.info('');
  context.logger.info('Feature "$feature" scaffolded. Remaining manual steps:');
  context.logger.info('1. Wire it up in lib/src/core/DI/dependency_injector.dart (see the auth block for the shape).');
  context.logger.info('2. Add a route in lib/routes.dart if it needs a page.');
  context.logger.info('3. Run: flutter analyze && flutter test test/unit/$feature/');
}
