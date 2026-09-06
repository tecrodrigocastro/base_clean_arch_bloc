part of '{{feature_name}}_bloc.dart';

abstract class {{#pascalCase}}{{feature_name}}{{/pascalCase}}State extends Equatable {
  const {{#pascalCase}}{{feature_name}}{{/pascalCase}}State();

  @override
  List<Object?> get props => [];
}

class {{#pascalCase}}{{feature_name}}{{/pascalCase}}Initial extends {{#pascalCase}}{{feature_name}}{{/pascalCase}}State {}

class {{#pascalCase}}{{feature_name}}{{/pascalCase}}Loading extends {{#pascalCase}}{{feature_name}}{{/pascalCase}}State {}

class {{#pascalCase}}{{feature_name}}{{/pascalCase}}{{#pascalCase}}{{action_name}}{{/pascalCase}}Success extends {{#pascalCase}}{{feature_name}}{{/pascalCase}}State {
  final {{#pascalCase}}{{entity_name}}{{/pascalCase}}Entity entity;

  const {{#pascalCase}}{{feature_name}}{{/pascalCase}}{{#pascalCase}}{{action_name}}{{/pascalCase}}Success(this.entity);

  @override
  List<Object?> get props => [entity];
}

class {{#pascalCase}}{{feature_name}}{{/pascalCase}}{{#pascalCase}}{{action_name}}{{/pascalCase}}Failure extends {{#pascalCase}}{{feature_name}}{{/pascalCase}}State {
  final BaseException exception;

  const {{#pascalCase}}{{feature_name}}{{/pascalCase}}{{#pascalCase}}{{action_name}}{{/pascalCase}}Failure({required this.exception});

  @override
  List<Object?> get props => [exception];
}
