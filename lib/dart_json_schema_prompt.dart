/// A Dart package for creating prompts and handling outputs in JSON schema format.
///
/// This library provides utilities for:
/// - Creating structured prompts with JSON schema specifications
/// - Parsing JSON responses into strongly typed objects
/// - Handling both single objects and lists
/// - Validating JSON schema compliance
library dart_json_schema_prompt;

export 'src/json_schema_prompt.dart';
export 'src/json_schema_parser.dart';
export 'src/property_builder.dart';
export 'src/models/prompt_config.dart';
export 'src/models/schema_definition.dart';
export 'src/exceptions/json_schema_exceptions.dart';
