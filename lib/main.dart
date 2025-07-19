import 'package:base_clean_arch_bloc/app_widget.dart';
import 'package:base_clean_arch_bloc/src/core/DI/dependency_injector.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = 'pt_BR';

  setupDependencyInjector(
    /// Ao ativar essa flag, você vai ter um log das chamadas e respostas da API
    /// no console do seu editor de codigo, por padrão é desabilitado.
    loggerApi: true,
  );
  runApp(const AppWidget());
}
