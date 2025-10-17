/// Exception classes for JSON schema prompt operations.
library;

/// Base exception for JSON schema prompt operations.
abstract class JsonSchemaException implements Exception {
  const JsonSchemaException(this.message);

  final String message;

  @override
  String toString() => 'JsonSchemaException: $message';
}

/// Exception thrown when JSON parsing fails.
class JsonParsingException extends JsonSchemaException {
  const JsonParsingException(super.message);

  @override
  String toString() => 'JsonParsingException: $message';
}

/// Exception thrown when JSON schema validation fails.
class JsonSchemaValidationException extends JsonSchemaException {
  const JsonSchemaValidationException(super.message);

  @override
  String toString() => 'JsonSchemaValidationException: $message';
}

/// Exception thrown when prompt generation fails.
class PromptGenerationException extends JsonSchemaException {
  const PromptGenerationException(super.message);

  @override
  String toString() => 'PromptGenerationException: $message';
}
