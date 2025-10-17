/// Schema definition model for JSON schema specifications.
library;

/// Defines the structure and constraints for a JSON schema.
class SchemaDefinition {
  const SchemaDefinition({
    required this.type,
    required this.properties,
    this.required = const [],
    this.description,
    this.examples = const [],
    this.additionalProperties = false,
  });

  /// The type of the schema (object, array, string, number, etc.).
  final SchemaType type;

  /// Properties definition for object types.
  final Map<String, PropertyDefinition> properties;

  /// List of required property names.
  final List<String> required;

  /// Optional description of the schema.
  final String? description;

  /// Example values for the schema.
  final List<Map<String, dynamic>> examples;

  /// Whether additional properties are allowed.
  final bool additionalProperties;

  /// Creates a JSON schema representation.
  Map<String, dynamic> toJsonSchema() {
    final schema = <String, dynamic>{
      'type': type.name,
    };

    if (description != null) {
      schema['description'] = description;
    }

    if (type == SchemaType.object) {
      schema['properties'] = properties.map(
        (key, value) => MapEntry(key, value.toJsonSchema()),
      );

      if (required.isNotEmpty) {
        schema['required'] = required;
      }

      schema['additionalProperties'] = additionalProperties;
    }

    if (type == SchemaType.array) {
      // For arrays, we expect at least one property to define the items schema
      if (properties.isNotEmpty) {
        final itemsSchema = properties.values.first.toJsonSchema();
        schema['items'] = itemsSchema;
      }
    }

    return schema;
  }

  /// Creates a human-readable prompt instruction.
  String toPromptInstruction() {
    final buffer = StringBuffer();

    buffer.writeln(
        'Return ONLY a valid JSON ${type.name} with the following structure:');

    if (type == SchemaType.object) {
      buffer.writeln('{');
      final propertyEntries = properties.entries.toList();
      for (int i = 0; i < propertyEntries.length; i++) {
        final entry = propertyEntries[i];
        final isRequired = required.contains(entry.key);
        final requiredMark = isRequired ? '' : ' (optional)';

        buffer.write('  "${entry.key}": ');
        buffer.write(entry.value.getExampleValue());
        buffer.write(requiredMark);

        if (entry.value.description != null) {
          buffer.write(' // ${entry.value.description}');
        }

        if (i < propertyEntries.length - 1) {
          buffer.writeln(',');
        } else {
          buffer.writeln();
        }
      }
      buffer.writeln('}');
    } else if (type == SchemaType.array) {
      buffer.writeln('[');
      if (properties.isNotEmpty) {
        final itemSchema = properties.values.first;
        buffer.writeln('  ${itemSchema.getExampleValue()},');
        buffer.writeln('  // ... more items');
      }
      buffer.writeln(']');
    }

    if (examples.isNotEmpty) {
      buffer.writeln('\nExample output:');
      buffer.writeln(examples.first.toString());
    }

    return buffer.toString();
  }
}

/// Defines a property within a JSON schema.
class PropertyDefinition {
  const PropertyDefinition({
    required this.type,
    this.description,
    this.format,
    this.enumValues,
    this.minimum,
    this.maximum,
    this.items,
    this.defaultValue,
  });

  /// The data type of the property.
  final SchemaType type;

  /// Description of the property.
  final String? description;

  /// Format specification (e.g., 'date-time', 'email').
  final String? format;

  /// Allowed values for enum types.
  final List<dynamic>? enumValues;

  /// Minimum value for numeric types.
  final num? minimum;

  /// Maximum value for numeric types.
  final num? maximum;

  /// Schema for array items.
  final PropertyDefinition? items;

  /// Default value for the property.
  final dynamic defaultValue;

  /// Creates a JSON schema representation of this property.
  Map<String, dynamic> toJsonSchema() {
    final schema = <String, dynamic>{
      'type': type.name,
    };

    if (description != null) {
      schema['description'] = description;
    }
    if (format != null) {
      schema['format'] = format;
    }
    if (enumValues != null) {
      schema['enum'] = enumValues;
    }
    if (minimum != null) {
      schema['minimum'] = minimum;
    }
    if (maximum != null) {
      schema['maximum'] = maximum;
    }
    if (defaultValue != null) {
      schema['default'] = defaultValue;
    }

    if (type == SchemaType.array && items != null) {
      schema['items'] = items!.toJsonSchema();
    }

    return schema;
  }

  /// Gets an example value for this property type.
  String getExampleValue() {
    switch (type) {
      case SchemaType.string:
        return '"string value"';
      case SchemaType.number:
        return '0.0';
      case SchemaType.integer:
        return '0';
      case SchemaType.boolean:
        return 'true';
      case SchemaType.array:
        return '[]';
      case SchemaType.object:
        return '{}';
      case SchemaType.null_:
        return 'null';
    }
  }
}

/// Supported JSON schema types.
enum SchemaType {
  string,
  number,
  integer,
  boolean,
  array,
  object,
  null_;

  /// Gets the string representation for JSON schema.
  String get name {
    switch (this) {
      case SchemaType.null_:
        return 'null';
      default:
        return toString().split('.').last;
    }
  }
}
