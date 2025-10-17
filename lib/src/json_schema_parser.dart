/// JSON parser with schema validation for structured responses.
library;

import 'dart:convert';
import 'models/schema_definition.dart';
import 'exceptions/json_schema_exceptions.dart';

/// A utility class for parsing and validating JSON responses against schemas.
class JsonSchemaParser {
  const JsonSchemaParser();

  /// Parses a JSON string into a Map, with optional schema validation.
  static Map<String, dynamic> parseObject(
    String jsonString, {
    SchemaDefinition? schema,
    bool validateSchema = true,
  }) {
    try {
      // Clean the JSON string
      final cleanJson = _cleanJsonString(jsonString);

      // Parse JSON
      final decoded = jsonDecode(cleanJson);

      if (decoded is! Map<String, dynamic>) {
        throw const JsonParsingException(
            'Expected JSON object, got different type');
      }

      // Validate against schema if provided
      if (schema != null && validateSchema) {
        _validateObject(decoded, schema);
      }

      return decoded;
    } on FormatException catch (e) {
      throw JsonParsingException('Invalid JSON format: ${e.message}');
    } catch (e) {
      if (e is JsonSchemaException) rethrow;
      throw JsonParsingException('Failed to parse JSON: $e');
    }
  }

  /// Parses a JSON string into a List, with optional schema validation.
  static List<dynamic> parseArray(
    String jsonString, {
    SchemaDefinition? schema,
    bool validateSchema = true,
  }) {
    try {
      // Clean the JSON string
      final cleanJson = _cleanJsonString(jsonString);

      // Parse JSON
      final decoded = jsonDecode(cleanJson);

      if (decoded is! List) {
        throw const JsonParsingException(
            'Expected JSON array, got different type');
      }

      // Validate against schema if provided
      if (schema != null && validateSchema) {
        _validateArray(decoded, schema);
      }

      return decoded;
    } on FormatException catch (e) {
      throw JsonParsingException('Invalid JSON format: ${e.message}');
    } catch (e) {
      if (e is JsonSchemaException) rethrow;
      throw JsonParsingException('Failed to parse JSON: $e');
    }
  }

  /// Parses a JSON string into a List of Maps (array of objects).
  static List<Map<String, dynamic>> parseObjectArray(
    String jsonString, {
    SchemaDefinition? itemSchema,
    bool validateSchema = true,
  }) {
    try {
      final array = parseArray(jsonString, validateSchema: false);

      final result = <Map<String, dynamic>>[];

      for (int i = 0; i < array.length; i++) {
        final item = array[i];

        if (item is! Map<String, dynamic>) {
          throw JsonParsingException('Array item at index $i is not an object');
        }

        // Validate each item against schema if provided
        if (itemSchema != null && validateSchema) {
          _validateObject(item, itemSchema);
        }

        result.add(item);
      }

      return result;
    } catch (e) {
      if (e is JsonSchemaException) rethrow;
      throw JsonParsingException('Failed to parse object array: $e');
    }
  }

  /// Attempts to extract JSON from a response that may contain additional text.
  static String extractJson(String response) {
    // Try to find JSON object first
    final objectMatch = RegExp(r'\{.*\}', dotAll: true).firstMatch(response);
    if (objectMatch != null) {
      return objectMatch.group(0)!;
    }

    // Try to find JSON array
    final arrayMatch = RegExp(r'\[.*\]', dotAll: true).firstMatch(response);
    if (arrayMatch != null) {
      return arrayMatch.group(0)!;
    }

    // If no JSON structure found, return cleaned response
    return _cleanJsonString(response);
  }

  /// Validates a JSON object against a schema definition.
  static void validateObject(
      Map<String, dynamic> object, SchemaDefinition schema) {
    _validateObject(object, schema);
  }

  /// Validates a JSON array against a schema definition.
  static void validateArray(List<dynamic> array, SchemaDefinition schema) {
    _validateArray(array, schema);
  }

  // Private helper methods

  static String _cleanJsonString(String jsonString) {
    return jsonString
        .replaceAll(RegExp(r'```json\s*'), '')
        .replaceAll(RegExp(r'```\s*'), '')
        .trim();
  }

  static void _validateObject(
      Map<String, dynamic> object, SchemaDefinition schema) {
    if (schema.type != SchemaType.object) {
      throw JsonSchemaValidationException(
        'Schema type mismatch: expected object, got ${schema.type}',
      );
    }

    // Check required fields
    for (final requiredField in schema.required) {
      if (!object.containsKey(requiredField)) {
        throw JsonSchemaValidationException(
          'Missing required field: $requiredField',
        );
      }
    }

    // Validate each property
    for (final entry in object.entries) {
      final propertyName = entry.key;
      final propertyValue = entry.value;

      final propertySchema = schema.properties[propertyName];
      if (propertySchema == null) {
        if (!schema.additionalProperties) {
          throw JsonSchemaValidationException(
            'Unexpected property: $propertyName',
          );
        }
        continue;
      }

      _validateProperty(propertyValue, propertySchema, propertyName);
    }
  }

  static void _validateArray(List<dynamic> array, SchemaDefinition schema) {
    if (schema.type != SchemaType.array) {
      throw JsonSchemaValidationException(
        'Schema type mismatch: expected array, got ${schema.type}',
      );
    }

    // Get items schema from properties
    final itemsProperty = schema.properties['items'];
    if (itemsProperty != null) {
      for (int i = 0; i < array.length; i++) {
        _validateProperty(array[i], itemsProperty, 'array[$i]');
      }
    }
  }

  static void _validateProperty(
    dynamic value,
    PropertyDefinition property,
    String propertyName,
  ) {
    switch (property.type) {
      case SchemaType.string:
        if (value is! String) {
          throw JsonSchemaValidationException(
            'Property $propertyName: expected string, got ${value.runtimeType}',
          );
        }
        break;
      case SchemaType.number:
        if (value is! num) {
          throw JsonSchemaValidationException(
            'Property $propertyName: expected number, got ${value.runtimeType}',
          );
        }
        if (property.minimum != null && value < property.minimum!) {
          throw JsonSchemaValidationException(
            'Property $propertyName: value $value is below minimum ${property.minimum}',
          );
        }
        if (property.maximum != null && value > property.maximum!) {
          throw JsonSchemaValidationException(
            'Property $propertyName: value $value is above maximum ${property.maximum}',
          );
        }
        break;
      case SchemaType.integer:
        if (value is! int) {
          throw JsonSchemaValidationException(
            'Property $propertyName: expected integer, got ${value.runtimeType}',
          );
        }
        break;
      case SchemaType.boolean:
        if (value is! bool) {
          throw JsonSchemaValidationException(
            'Property $propertyName: expected boolean, got ${value.runtimeType}',
          );
        }
        break;
      case SchemaType.array:
        if (value is! List) {
          throw JsonSchemaValidationException(
            'Property $propertyName: expected array, got ${value.runtimeType}',
          );
        }
        // Validate array items if schema is provided
        if (property.items != null) {
          for (int i = 0; i < value.length; i++) {
            _validateProperty(value[i], property.items!, '$propertyName[$i]');
          }
        }
        break;
      case SchemaType.object:
        if (value is! Map<String, dynamic>) {
          throw JsonSchemaValidationException(
            'Property $propertyName: expected object, got ${value.runtimeType}',
          );
        }
        break;
      case SchemaType.null_:
        if (value != null) {
          throw JsonSchemaValidationException(
            'Property $propertyName: expected null, got ${value.runtimeType}',
          );
        }
        break;
    }

    // Validate enum values
    if (property.enumValues != null && !property.enumValues!.contains(value)) {
      throw JsonSchemaValidationException(
        'Property $propertyName: value "$value" is not in allowed values ${property.enumValues}',
      );
    }
  }
}
