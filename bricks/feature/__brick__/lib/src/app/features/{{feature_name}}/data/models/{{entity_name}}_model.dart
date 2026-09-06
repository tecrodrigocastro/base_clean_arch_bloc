import 'dart:convert';

import 'package:{{package_name}}/src/app/features/{{feature_name}}/domain/entities/{{entity_name}}_entity.dart';

class {{#pascalCase}}{{entity_name}}{{/pascalCase}}Model extends {{#pascalCase}}{{entity_name}}{{/pascalCase}}Entity {
  const {{#pascalCase}}{{entity_name}}{{/pascalCase}}Model({
{{#fields}}
    required super.{{name}},
{{/fields}}
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
{{#fields}}
      '{{name}}': {{name}},
{{/fields}}
    };
  }

  factory {{#pascalCase}}{{entity_name}}{{/pascalCase}}Model.fromMap(Map<String, dynamic> map) {
    try {
      return {{#pascalCase}}{{entity_name}}{{/pascalCase}}Model(
{{#fields}}
        {{name}}: map['{{name}}'] as {{{type}}},
{{/fields}}
      );
    } catch (e, stackTrace) {
      throw Exception('Error parsing {{#pascalCase}}{{entity_name}}{{/pascalCase}}Model: $e\nStack trace: $stackTrace');
    }
  }

  String toJson() => json.encode(toMap());

  factory {{#pascalCase}}{{entity_name}}{{/pascalCase}}Model.fromJson(String source) =>
      {{#pascalCase}}{{entity_name}}{{/pascalCase}}Model.fromMap(json.decode(source) as Map<String, dynamic>);
}
