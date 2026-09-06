part of '{{feature_name}}_bloc.dart';

abstract class {{#pascalCase}}{{feature_name}}{{/pascalCase}}Event extends Equatable {
  const {{#pascalCase}}{{feature_name}}{{/pascalCase}}Event();

  @override
  List<Object?> get props => [];
}

class {{#pascalCase}}{{feature_name}}{{/pascalCase}}{{#pascalCase}}{{action_name}}{{/pascalCase}}Requested extends {{#pascalCase}}{{feature_name}}{{/pascalCase}}Event {
  final {{#pascalCase}}{{action_name}}{{/pascalCase}}Params params;

  const {{#pascalCase}}{{feature_name}}{{/pascalCase}}{{#pascalCase}}{{action_name}}{{/pascalCase}}Requested({required this.params});

  @override
  List<Object?> get props => [params];
}
