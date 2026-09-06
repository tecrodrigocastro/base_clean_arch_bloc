import 'dart:io';

import 'package:mason/mason.dart';
import 'package:yaml/yaml.dart' as yaml;

String _emptyValueFor(String type) {
  switch (type) {
    case 'String':
      return "''";
    case 'int':
      return '0';
    case 'double':
      return '0.0';
    case 'num':
      return '0';
    case 'bool':
      return 'false';
    default:
      return 'null';
  }
}

String _sampleValueFor(String type) {
  switch (type) {
    case 'String':
      return "'test'";
    case 'int':
      return '1';
    case 'double':
      return '1.0';
    case 'num':
      return '1';
    case 'bool':
      return 'true';
    default:
      return 'null';
  }
}

void run(HookContext context) {
  final raw = context.vars['fields'] as String? ?? '';
  final rawFields = raw.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

  final fields = <Map<String, dynamic>>[];
  for (var i = 0; i < rawFields.length; i++) {
    final segment = rawFields[i].split(':');
    final type = segment.length > 1 ? segment[1].trim() : 'String';
    fields.add({
      'name': segment[0].trim(),
      'type': type,
      'last': i == rawFields.length - 1,
      'emptyValue': _emptyValueFor(type),
      'sampleValue': _sampleValueFor(type),
      'isString': type == 'String',
    });
  }

  var entityName = (context.vars['entity_name'] as String?)?.trim() ?? '';
  if (entityName.isEmpty) {
    entityName = context.vars['feature_name'] as String;
  }

  var packageName = 'base_clean_arch_bloc';
  final pubspecFile = File('pubspec.yaml');
  if (pubspecFile.existsSync()) {
    final doc = yaml.loadYaml(pubspecFile.readAsStringSync());
    if (doc is Map && doc['name'] is String) {
      packageName = doc['name'] as String;
    }
  }

  context.vars = {
    ...context.vars,
    'fields': fields,
    'entity_name': entityName,
    'package_name': packageName,
  };
}
