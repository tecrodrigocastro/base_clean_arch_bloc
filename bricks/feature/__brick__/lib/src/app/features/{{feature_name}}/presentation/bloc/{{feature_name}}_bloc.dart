import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:result_dart/result_dart.dart';
import 'package:{{package_name}}/src/app/features/{{feature_name}}/domain/dtos/{{action_name}}_params.dart';
import 'package:{{package_name}}/src/app/features/{{feature_name}}/domain/entities/{{entity_name}}_entity.dart';
import 'package:{{package_name}}/src/app/features/{{feature_name}}/domain/usecases/{{action_name}}_usecase.dart';
import 'package:{{package_name}}/src/app/features/{{feature_name}}/domain/validators/{{action_name}}_params_validators.dart';
import 'package:{{package_name}}/src/core/errors/errors.dart';
import 'package:{{package_name}}/src/core/extensions/lucid_validator_extensions.dart';

part '{{feature_name}}_event.dart';
part '{{feature_name}}_state.dart';

class {{#pascalCase}}{{feature_name}}{{/pascalCase}}Bloc extends Bloc<{{#pascalCase}}{{feature_name}}{{/pascalCase}}Event, {{#pascalCase}}{{feature_name}}{{/pascalCase}}State> {
  final {{#pascalCase}}{{action_name}}{{/pascalCase}}Usecase _{{#camelCase}}{{action_name}}{{/camelCase}}Usecase;

  {{#pascalCase}}{{feature_name}}{{/pascalCase}}Bloc({required {{#pascalCase}}{{action_name}}{{/pascalCase}}Usecase {{#camelCase}}{{action_name}}{{/camelCase}}Usecase})
      : _{{#camelCase}}{{action_name}}{{/camelCase}}Usecase = {{#camelCase}}{{action_name}}{{/camelCase}}Usecase,
        super({{#pascalCase}}{{feature_name}}{{/pascalCase}}Initial()) {
    on<{{#pascalCase}}{{feature_name}}{{/pascalCase}}{{#pascalCase}}{{action_name}}{{/pascalCase}}Requested>((event, emit) async {
      emit({{#pascalCase}}{{feature_name}}{{/pascalCase}}Loading());

      final validator = {{#pascalCase}}{{action_name}}{{/pascalCase}}ParamsValidators();

      final newState = await validator
          .validateResult(event.params)
          .flatMap(_{{#camelCase}}{{action_name}}{{/camelCase}}Usecase.call)
          .fold({{#pascalCase}}{{feature_name}}{{/pascalCase}}{{#pascalCase}}{{action_name}}{{/pascalCase}}Success.new, (exception) => {{#pascalCase}}{{feature_name}}{{/pascalCase}}{{#pascalCase}}{{action_name}}{{/pascalCase}}Failure(exception: exception as BaseException));

      emit(newState);
    });
  }
}
