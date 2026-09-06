import 'package:{{package_name}}/src/app/features/{{feature_name}}/domain/dtos/{{action_name}}_params.dart';
import 'package:{{package_name}}/src/app/features/{{feature_name}}/domain/entities/{{entity_name}}_entity.dart';
import 'package:{{package_name}}/src/app/features/{{feature_name}}/domain/repositories/{{feature_name}}_repository_interface.dart';
import 'package:{{package_name}}/src/app/features/{{feature_name}}/domain/usecases/{{action_name}}_usecase.dart';
import 'package:{{package_name}}/src/core/errors/default_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';

class Mock{{#pascalCase}}{{feature_name}}{{/pascalCase}}Repository extends Mock implements I{{#pascalCase}}{{feature_name}}{{/pascalCase}}Repository {}

void main() {
  group('{{#pascalCase}}{{action_name}}{{/pascalCase}}Usecase', () {
    late {{#pascalCase}}{{action_name}}{{/pascalCase}}Usecase usecase;
    late Mock{{#pascalCase}}{{feature_name}}{{/pascalCase}}Repository mockRepository;

    setUpAll(() {
      registerFallbackValue({{#pascalCase}}{{action_name}}{{/pascalCase}}Params.empty());
    });

    setUp(() {
      mockRepository = Mock{{#pascalCase}}{{feature_name}}{{/pascalCase}}Repository();
      usecase = {{#pascalCase}}{{action_name}}{{/pascalCase}}Usecase({{#camelCase}}{{feature_name}}{{/camelCase}}Repository: mockRepository);
    });

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

    test('should return entity when repository call succeeds', () async {
      when(() => mockRepository.{{#camelCase}}{{action_name}}{{/camelCase}}(params)).thenAnswer((_) async => const Success(entity));

      final result = await usecase.call(params);

      expect(result.isSuccess(), isTrue);
      expect(result.getOrNull(), equals(entity));
      verify(() => mockRepository.{{#camelCase}}{{action_name}}{{/camelCase}}(params)).called(1);
    });

    test('should return Failure when repository call fails', () async {
      const exception = DefaultException(message: 'Something went wrong');
      when(() => mockRepository.{{#camelCase}}{{action_name}}{{/camelCase}}(params)).thenAnswer((_) async => const Failure(exception));

      final result = await usecase.call(params);

      expect(result.isError(), isTrue);
      expect(result.exceptionOrNull(), equals(exception));
    });
  });
}
