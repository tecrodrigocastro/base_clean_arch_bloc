import 'package:equatable/equatable.dart';

class {{#pascalCase}}{{entity_name}}{{/pascalCase}}Entity extends Equatable {
{{#fields}}
  final {{{type}}} {{name}};
{{/fields}}

  const {{#pascalCase}}{{entity_name}}{{/pascalCase}}Entity({
{{#fields}}
    required this.{{name}},
{{/fields}}
  });

  @override
  String toString() {
    return '{{#pascalCase}}{{entity_name}}{{/pascalCase}}Entity({{#fields}}{{name}}: ${{name}}{{^last}}, {{/last}}{{/fields}})';
  }

  @override
  List<Object?> get props => [{{#fields}}{{name}}{{^last}}, {{/last}}{{/fields}}];
}
