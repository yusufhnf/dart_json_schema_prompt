import 'package:dart_json_schema_prompt/dart_json_schema_prompt.dart';
import 'package:test/test.dart';

void main() {
  group('JsonSchemaPrompt Tests', () {
    test('should create a simple object prompt', () {
      final prompt = JsonSchemaPrompt.forObject(
        instruction: 'Create a user profile',
        properties: {
          'name': PropertyBuilder.string(description: 'User name'),
          'age': PropertyBuilder.integer(minimum: 0),
        },
        required: ['name'],
      );

      expect(prompt.instruction, equals('Create a user profile'));
      expect(prompt.schema.type, equals(SchemaType.object));
      expect(prompt.schema.properties.length, equals(2));
      expect(prompt.schema.required, equals(['name']));
    });

    test('should create an array prompt', () {
      final prompt = JsonSchemaPrompt.forArray(
        instruction: 'List products',
        itemSchema: PropertyBuilder.object(description: 'Product object'),
      );

      expect(prompt.schema.type, equals(SchemaType.array));
      expect(prompt.schema.properties.containsKey('items'), isTrue);
    });

    test('should generate valid prompt string', () {
      final prompt = JsonSchemaPrompt.forObject(
        instruction: 'Create user data',
        properties: {
          'name': PropertyBuilder.string(),
          'active': PropertyBuilder.boolean(),
        },
        required: ['name'],
      );

      final generatedPrompt = JsonSchemaPrompt.generate(prompt);

      expect(generatedPrompt, contains('Create user data'));
      expect(generatedPrompt, contains('ONLY valid JSON'));
      expect(generatedPrompt, contains('"name"'));
      expect(generatedPrompt, contains('"active"'));
    });

    test('should validate prompt configuration', () {
      expect(
        () => JsonSchemaPrompt.generate(PromptConfig(
          instruction: '',
          schema: SchemaDefinition(
            type: SchemaType.object,
            properties: {},
          ),
        )),
        throwsA(isA<PromptGenerationException>()),
      );
    });

    test('should handle required fields validation', () {
      expect(
        () => JsonSchemaPrompt.generate(PromptConfig(
          instruction: 'Test',
          schema: SchemaDefinition(
            type: SchemaType.object,
            properties: {
              'name': PropertyBuilder.string(),
            },
            required: ['name', 'nonexistent'],
          ),
        )),
        throwsA(isA<PromptGenerationException>()),
      );
    });

    test('should create object array prompt', () {
      final prompt = JsonSchemaPrompt.forObjectArray(
        instruction: 'Create product list',
        objectProperties: {
          'id': PropertyBuilder.string(),
          'price': PropertyBuilder.number(minimum: 0),
        },
        required: ['id'],
      );

      expect(prompt.schema.type, equals(SchemaType.array));
      expect(prompt.additionalInstructions,
          contains('Return an array of objects with the specified structure'));
    });
  });
}
