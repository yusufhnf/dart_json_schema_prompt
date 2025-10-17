import 'package:dart_json_schema_prompt/dart_json_schema_prompt.dart';
import 'package:test/test.dart';

void main() {
  group('JsonSchemaParser Tests', () {
    test('should parse valid JSON object', () {
      const jsonString = '''
      {
        "name": "John Doe",
        "age": 30,
        "active": true
      }
      ''';

      final result = JsonSchemaParser.parseObject(jsonString);

      expect(result['name'], equals('John Doe'));
      expect(result['age'], equals(30));
      expect(result['active'], equals(true));
    });

    test('should parse JSON array', () {
      const jsonString = '''
      [
        {"id": 1, "name": "Item 1"},
        {"id": 2, "name": "Item 2"}
      ]
      ''';

      final result = JsonSchemaParser.parseArray(jsonString);

      expect(result, hasLength(2));
      expect(result[0]['id'], equals(1));
      expect(result[1]['name'], equals('Item 2'));
    });

    test('should parse object array', () {
      const jsonString = '''
      [
        {"name": "Alice", "score": 95.5},
        {"name": "Bob", "score": 87.2}
      ]
      ''';

      final result = JsonSchemaParser.parseObjectArray(jsonString);

      expect(result, hasLength(2));
      expect(result[0], isA<Map<String, dynamic>>());
      expect(result[1]['name'], equals('Bob'));
    });

    test('should clean JSON with code blocks', () {
      const jsonString = '''
      ```json
      {
        "name": "Test",
        "value": 42
      }
      ```
      ''';

      final result = JsonSchemaParser.parseObject(jsonString);
      expect(result['name'], equals('Test'));
      expect(result['value'], equals(42));
    });

    test('should extract JSON from mixed text', () {
      const response = '''
      Here is the requested JSON:
      {"name": "Extracted", "success": true}
      That's the result.
      ''';

      final extracted = JsonSchemaParser.extractJson(response);
      final parsed = JsonSchemaParser.parseObject(extracted);

      expect(parsed['name'], equals('Extracted'));
      expect(parsed['success'], equals(true));
    });

    test('should throw error for invalid JSON', () {
      const invalidJson = '{"name": "Invalid" missing_comma "age": 30}';

      expect(
        () => JsonSchemaParser.parseObject(invalidJson),
        throwsA(isA<JsonParsingException>()),
      );
    });

    test('should validate against schema', () {
      final schema = SchemaDefinition(
        type: SchemaType.object,
        properties: {
          'name': PropertyBuilder.string(),
          'age': PropertyBuilder.integer(minimum: 0, maximum: 150),
        },
        required: ['name'],
      );

      // Valid object
      const validJson = '{"name": "Alice", "age": 25}';
      expect(
        () => JsonSchemaParser.parseObject(validJson, schema: schema),
        returnsNormally,
      );

      // Missing required field
      const missingField = '{"age": 25}';
      expect(
        () => JsonSchemaParser.parseObject(missingField, schema: schema),
        throwsA(isA<JsonSchemaValidationException>()),
      );

      // Invalid type
      const wrongType = '{"name": "Alice", "age": "twenty-five"}';
      expect(
        () => JsonSchemaParser.parseObject(wrongType, schema: schema),
        throwsA(isA<JsonSchemaValidationException>()),
      );
    });

    test('should validate number constraints', () {
      final schema = SchemaDefinition(
        type: SchemaType.object,
        properties: {
          'score': PropertyBuilder.number(minimum: 0, maximum: 100),
        },
        required: ['score'],
      );

      // Valid range
      const validScore = '{"score": 85.5}';
      expect(
        () => JsonSchemaParser.parseObject(validScore, schema: schema),
        returnsNormally,
      );

      // Below minimum
      const belowMin = '{"score": -10}';
      expect(
        () => JsonSchemaParser.parseObject(belowMin, schema: schema),
        throwsA(isA<JsonSchemaValidationException>()),
      );

      // Above maximum
      const aboveMax = '{"score": 150}';
      expect(
        () => JsonSchemaParser.parseObject(aboveMax, schema: schema),
        throwsA(isA<JsonSchemaValidationException>()),
      );
    });

    test('should validate enum values', () {
      final schema = SchemaDefinition(
        type: SchemaType.object,
        properties: {
          'status': PropertyBuilder.string(
            enumValues: ['active', 'inactive', 'pending'],
          ),
        },
        required: ['status'],
      );

      // Valid enum value
      const validEnum = '{"status": "active"}';
      expect(
        () => JsonSchemaParser.parseObject(validEnum, schema: schema),
        returnsNormally,
      );

      // Invalid enum value
      const invalidEnum = '{"status": "unknown"}';
      expect(
        () => JsonSchemaParser.parseObject(invalidEnum, schema: schema),
        throwsA(isA<JsonSchemaValidationException>()),
      );
    });

    test('should validate array items', () {
      final schema = SchemaDefinition(
        type: SchemaType.object,
        properties: {
          'tags': PropertyBuilder.array(
            items: PropertyBuilder.string(),
          ),
        },
        required: ['tags'],
      );

      // Valid array
      const validArray = '{"tags": ["tag1", "tag2", "tag3"]}';
      expect(
        () => JsonSchemaParser.parseObject(validArray, schema: schema),
        returnsNormally,
      );

      // Invalid array item type
      const invalidItems = '{"tags": ["tag1", 123, "tag3"]}';
      expect(
        () => JsonSchemaParser.parseObject(invalidItems, schema: schema),
        throwsA(isA<JsonSchemaValidationException>()),
      );
    });
  });
}
