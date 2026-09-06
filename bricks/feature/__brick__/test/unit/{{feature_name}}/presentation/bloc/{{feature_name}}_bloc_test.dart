import 'package:bloc_test/bloc_test.dart';
import 'package:{{package_name}}/src/app/features/{{feature_name}}/domain/dtos/{{action_name}}_params.dart';
import 'package:{{package_name}}/src/app/features/{{feature_name}}/domain/entities/{{entity_name}}_entity.dart';
import 'package:{{package_name}}/src/app/features/{{feature_name}}/domain/repositories/{{feature_name}}_repository_interface.dart';
import 'package:{{package_name}}/src/app/features/{{feature_name}}/domain/usecases/{{action_name}}_usecase.dart';
import 'package:{{package_name}}/src/app/features/{{feature_name}}/presentation/bloc/{{feature_name}}_bloc.dart';
import 'package:{{package_name}}/src/core/errors/default_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

class Mock{{#pascalCase}}{{feature_name}}{{/pascalCase}}Repository extends Mock implements I{{#pascalCase}}{{feature_name}}{{/pascalCase}}Repository {}

void main() {
  group('{{#pascalCase}}{{feature_name}}{{/pascalCase}}Bloc', () {
    late Mock{{#pascalCase}}{{feature_name}}{{/pascalCase}}Repository mockRepository;
    late {{#pascalCase}}{{action_name}}{{/pascalCase}}Usecase usecase;

    final params = {{#pascalCase}}{{action_name}}{{/pascalCase}}Params(
{{#fields}}
      {{name}}: {{{sampleValue}}},
{{/fields}}
    );

    const entity = {{#pascalCase}}{{entity_name}}{{/pascalCase}}Entity(
{{#fields}}
      {{name}}: {{{sampleValue}}},
{{/fields}}
    );

    setUpAll(() {
      registerFallbackValue(params);
    });

    setUp(() {
      mockRepository = Mock{{#pascalCase}}{{feature_name}}{{/pascalCase}}Repository();
      usecase = {{#pascalCase}}{{action_name}}{{/pascalCase}}Usecase({{#camelCase}}{{feature_name}}{{/camelCase}}Repository: mockRepository);
    });

    blocTest<{{#pascalCase}}{{feature_name}}{{/pascalCase}}Bloc, {{#pascalCase}}{{feature_name}}{{/pascalCase}}State>(
      'emits [Loading, Success] when {{#camelCase}}{{action_name}}{{/camelCase}} succeeds',
      build: () {
        when(() => mockRepository.{{#camelCase}}{{action_name}}{{/camelCase}}(params)).thenAnswer((_) async => const Success(entity));
        return {{#pascalCase}}{{feature_name}}{{/pascalCase}}Bloc({{#camelCase}}{{action_name}}{{/camelCase}}Usecase: usecase);
      },
      act: (bloc) => bloc.add({{#pascalCase}}{{feature_name}}{{/pascalCase}}{{#pascalCase}}{{action_name}}{{/pascalCase}}Requested(params: params)),
      expect: () => [
        {{#pascalCase}}{{feature_name}}{{/pascalCase}}Loading(),
        const {{#pascalCase}}{{feature_name}}{{/pascalCase}}{{#pascalCase}}{{action_name}}{{/pascalCase}}Success(entity),
      ],
    );

    blocTest<{{#pascalCase}}{{feature_name}}{{/pascalCase}}Bloc, {{#pascalCase}}{{feature_name}}{{/pascalCase}}State>(
      'emits [Loading, Failure] when {{#camelCase}}{{action_name}}{{/camelCase}} fails',
      build: () {
        const exception = DefaultException(message: 'Something went wrong');
        when(() => mockRepository.{{#camelCase}}{{action_name}}{{/camelCase}}(params)).thenAnswer((_) async => const Failure(exception));
        return {{#pascalCase}}{{feature_name}}{{/pascalCase}}Bloc({{#camelCase}}{{action_name}}{{/camelCase}}Usecase: usecase);
      },
      act: (bloc) => bloc.add({{#pascalCase}}{{feature_name}}{{/pascalCase}}{{#pascalCase}}{{action_name}}{{/pascalCase}}Requested(params: params)),
      expect: () => [
        {{#pascalCase}}{{feature_name}}{{/pascalCase}}Loading(),
        isA<{{#pascalCase}}{{feature_name}}{{/pascalCase}}{{#pascalCase}}{{action_name}}{{/pascalCase}}Failure>(),
      ],
    );
  });
}
