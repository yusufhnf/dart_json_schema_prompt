/// Utility class for creating property definitions with common patterns.
library;

import 'models/schema_definition.dart';

/// Builder class for creating PropertyDefinition objects with common patterns.
class PropertyBuilder {
  /// Creates a string property.
  static PropertyDefinition string({
    String? description,
    List<String>? enumValues,
    String? format,
    String? defaultValue,
  }) {
    return PropertyDefinition(
      type: SchemaType.string,
      description: description,
      enumValues: enumValues,
      format: format,
      defaultValue: defaultValue,
    );
  }

  /// Creates a number property.
  static PropertyDefinition number({
    String? description,
    num? minimum,
    num? maximum,
    num? defaultValue,
  }) {
    return PropertyDefinition(
      type: SchemaType.number,
      description: description,
      minimum: minimum,
      maximum: maximum,
      defaultValue: defaultValue,
    );
  }

  /// Creates an integer property.
  static PropertyDefinition integer({
    String? description,
    num? minimum,
    num? maximum,
    int? defaultValue,
  }) {
    return PropertyDefinition(
      type: SchemaType.integer,
      description: description,
      minimum: minimum,
      maximum: maximum,
      defaultValue: defaultValue,
    );
  }

  /// Creates a boolean property.
  static PropertyDefinition boolean({
    String? description,
    bool? defaultValue,
  }) {
    return PropertyDefinition(
      type: SchemaType.boolean,
      description: description,
      defaultValue: defaultValue,
    );
  }

  /// Creates an array property.
  static PropertyDefinition array({
    String? description,
    required PropertyDefinition items,
  }) {
    return PropertyDefinition(
      type: SchemaType.array,
      description: description,
      items: items,
    );
  }

  /// Creates an object property.
  static PropertyDefinition object({
    String? description,
  }) {
    return PropertyDefinition(
      type: SchemaType.object,
      description: description,
    );
  }
}
