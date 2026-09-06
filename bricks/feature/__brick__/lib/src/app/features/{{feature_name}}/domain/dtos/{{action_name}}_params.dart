class {{#pascalCase}}{{action_name}}{{/pascalCase}}Params {
{{#fields}}
  {{{type}}} {{name}};
{{/fields}}

  {{#pascalCase}}{{action_name}}{{/pascalCase}}Params({
{{#fields}}
    required this.{{name}},
{{/fields}}
  });

  Map<String, dynamic> toJson() {
    return {
{{#fields}}
      '{{name}}': {{name}},
{{/fields}}
    };
  }

{{#fields}}
  void set{{#pascalCase}}{{name}}{{/pascalCase}}({{{type}}} value) {
    {{name}} = value;
  }

{{/fields}}
  static {{#pascalCase}}{{action_name}}{{/pascalCase}}Params empty() {
    return {{#pascalCase}}{{action_name}}{{/pascalCase}}Params(
{{#fields}}
      {{name}}: {{{emptyValue}}},
{{/fields}}
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is {{#pascalCase}}{{action_name}}{{/pascalCase}}Params{{#fields}} &&
        other.{{name}} == {{name}}{{/fields}};
  }

  @override
  int get hashCode {
    return {{#fields}}{{name}}.hashCode{{^last}} ^ {{/last}}{{/fields}};
  }

  @override
  String toString() {
    return '{{#pascalCase}}{{action_name}}{{/pascalCase}}Params({{#fields}}{{name}}: ${{name}}{{^last}}, {{/last}}{{/fields}})';
  }
}
