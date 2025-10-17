/// Main class for generating JSON schema-based prompts.
library;

import 'models/prompt_config.dart';
import 'models/schema_definition.dart';
import 'exceptions/json_schema_exceptions.dart';

/// A utility class for creating structured prompts with JSON schema specifications.
class JsonSchemaPrompt {
  const JsonSchemaPrompt();

  /// Creates a prompt configuration for a single object response.
  static PromptConfig forObject({
    required String instruction,
    required Map<String, PropertyDefinition> properties,
    List<String> required = const [],
    String? description,
    List<Map<String, dynamic>> examples = const [],
    bool strictMode = true,
    List<String> additionalInstructions = const [],
  }) {
    final schema = SchemaDefinition(
      type: SchemaType.object,
      properties: properties,
      required: required,
      description: description,
      examples: examples,
    );

    return PromptConfig(
      instruction: instruction,
      schema: schema,
      strictMode: strictMode,
      additionalInstructions: additionalInstructions,
    );
  }

  /// Creates a prompt configuration for an array response.
  static PromptConfig forArray({
    required String instruction,
    required PropertyDefinition itemSchema,
    String? description,
    List<Map<String, dynamic>> examples = const [],
    bool strictMode = true,
    List<String> additionalInstructions = const [],
  }) {
    final schema = SchemaDefinition(
      type: SchemaType.array,
      properties: {'items': itemSchema},
      description: description,
      examples: examples,
    );

    return PromptConfig(
      instruction: instruction,
      schema: schema,
      strictMode: strictMode,
      additionalInstructions: additionalInstructions,
    );
  }

  /// Creates a prompt configuration for an array of objects.
  static PromptConfig forObjectArray({
    required String instruction,
    required Map<String, PropertyDefinition> objectProperties,
    List<String> required = const [],
    String? description,
    List<Map<String, dynamic>> examples = const [],
    bool strictMode = true,
    List<String> additionalInstructions = const [],
  }) {
    final schema = SchemaDefinition(
      type: SchemaType.array,
      properties: {
        'items': PropertyDefinition(
          type: SchemaType.object,
          description: 'Array item schema',
        )
      },
      description: description,
      examples: examples,
    );

    // Add array-specific instructions
    final arrayInstructions = [
      'Return an array of objects with the specified structure',
      'Each object in the array must follow the same schema',
      ...additionalInstructions,
    ];

    return PromptConfig(
      instruction: instruction,
      schema: schema,
      strictMode: strictMode,
      additionalInstructions: arrayInstructions,
    );
  }

  /// Validates a prompt configuration.
  static void validateConfig(PromptConfig config) {
    if (config.instruction.trim().isEmpty) {
      throw const PromptGenerationException('Instruction cannot be empty');
    }

    if (config.schema.properties.isEmpty &&
        config.schema.type == SchemaType.object) {
      throw const PromptGenerationException(
          'Object schema must have at least one property');
    }

    // Validate required fields exist in properties
    for (final requiredField in config.schema.required) {
      if (!config.schema.properties.containsKey(requiredField)) {
        throw PromptGenerationException(
          'Required field "$requiredField" not found in properties',
        );
      }
    }
  }

  /// Generates a complete prompt string from configuration.
  static String generate(PromptConfig config) {
    validateConfig(config);
    return config.generatePrompt();
  }
}
