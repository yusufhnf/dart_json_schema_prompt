/// Configuration model for prompt generation.
library;

import 'schema_definition.dart';

/// Configuration for generating structured prompts with JSON schema.
class PromptConfig {
  const PromptConfig({
    required this.instruction,
    required this.schema,
    this.includeSchema = true,
    this.includeExamples = true,
    this.strictMode = true,
    this.additionalInstructions = const [],
  });

  /// The main instruction or question for the AI.
  final String instruction;

  /// The expected JSON schema for the response.
  final SchemaDefinition schema;

  /// Whether to include the JSON schema in the prompt.
  final bool includeSchema;

  /// Whether to include examples in the prompt.
  final bool includeExamples;

  /// Whether to enforce strict JSON-only responses.
  final bool strictMode;

  /// Additional instructions to append to the prompt.
  final List<String> additionalInstructions;

  /// Generates the complete prompt string.
  String generatePrompt() {
    final buffer = StringBuffer();

    // Add main instruction
    buffer.writeln(instruction);
    buffer.writeln();

    // Add schema instructions
    if (includeSchema) {
      buffer.writeln(schema.toPromptInstruction());
      buffer.writeln();
    }

    // Add strict mode instructions
    if (strictMode) {
      buffer.writeln('IMPORTANT REQUIREMENTS:');
      buffer.writeln(
          '- Return ONLY valid JSON, no additional text or explanations');
      buffer.writeln('- All property names must match exactly as specified');
      buffer.writeln('- Ensure all required fields are included');
      buffer.writeln('- Use appropriate data types for each field');
      buffer.writeln();
    }

    // Add additional instructions
    if (additionalInstructions.isNotEmpty) {
      buffer.writeln('Additional requirements:');
      for (final instruction in additionalInstructions) {
        buffer.writeln('- $instruction');
      }
      buffer.writeln();
    }

    return buffer.toString().trim();
  }

  /// Creates a copy with modified parameters.
  PromptConfig copyWith({
    String? instruction,
    SchemaDefinition? schema,
    bool? includeSchema,
    bool? includeExamples,
    bool? strictMode,
    List<String>? additionalInstructions,
  }) {
    return PromptConfig(
      instruction: instruction ?? this.instruction,
      schema: schema ?? this.schema,
      includeSchema: includeSchema ?? this.includeSchema,
      includeExamples: includeExamples ?? this.includeExamples,
      strictMode: strictMode ?? this.strictMode,
      additionalInstructions:
          additionalInstructions ?? this.additionalInstructions,
    );
  }
}
