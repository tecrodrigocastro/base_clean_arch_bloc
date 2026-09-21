import 'package:base_clean_arch_bloc/app_widget.dart';
import 'package:base_clean_arch_bloc/src/core/DI/dependency_injector.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:marionette_flutter/marionette_flutter.dart';
import 'package:marionette_logger/marionette_logger.dart';

void main() {
  /// Coleta os logs emitidos via `Logger` para que o marionette_mcp
  /// (agente de IA conectado ao app em runtime) consiga lê-los com `get_logs`.
  final logCollector = LoggerLogCollector();

  /// `MarionetteBinding` só roda em debug - em release o app usa o binding
  /// padrão do Flutter normalmente. Veja https://github.com/leancodepl/marionette_mcp
  if (kDebugMode) {
    MarionetteBinding.ensureInitialized(
      MarionetteConfiguration(logCollector: logCollector),
    );
  } else {
    WidgetsFlutterBinding.ensureInitialized();
  }

  Intl.defaultLocale = 'pt_BR';

  final logger = Logger(output: MultiOutput([ConsoleOutput(), logCollector]));

  setupDependencyInjector(
    /// Ao ativar essa flag, você vai ter um log das chamadas e respostas da API
    /// no console do seu editor de codigo, por padrão é desabilitado.
    loggerApi: true,

    /// Ativa o uso de mocks, ou seja, os dados do login serão simulados localmente sem a necessidade de uma API real.
    /// As credenciais válidas para login são:
    /// - Email: `teste@teste.com`
    /// - Senha: `123456Aa!`
    useMocks: true,
    logger: logger,
  );
  runApp(const AppWidget());
}
