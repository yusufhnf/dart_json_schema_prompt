import 'package:dart_json_schema_prompt/dart_json_schema_prompt.dart';
import 'package:test/test.dart';

void main() {
  group('SchemaDefinition Tests', () {
    test('should create object schema', () {
      final schema = SchemaDefinition(
        type: SchemaType.object,
        properties: {
          'name': PropertyBuilder.string(),
          'age': PropertyBuilder.integer(),
        },
        required: ['name'],
        description: 'User schema',
      );

      expect(schema.type, equals(SchemaType.object));
      expect(schema.properties.length, equals(2));
      expect(schema.required, equals(['name']));
      expect(schema.description, equals('User schema'));
    });

    test('should generate JSON schema', () {
      final schema = SchemaDefinition(
        type: SchemaType.object,
        properties: {
          'name': PropertyBuilder.string(description: 'User name'),
          'age': PropertyBuilder.integer(minimum: 0),
        },
        required: ['name'],
      );

      final jsonSchema = schema.toJsonSchema();

      expect(jsonSchema['type'], equals('object'));
      expect(jsonSchema['properties'], isA<Map<String, dynamic>>());
      expect(jsonSchema['required'], equals(['name']));
      expect(jsonSchema['additionalProperties'], equals(false));
    });

    test('should generate prompt instruction', () {
      final schema = SchemaDefinition(
        type: SchemaType.object,
        properties: {
          'title': PropertyBuilder.string(description: 'Document title'),
          'count': PropertyBuilder.integer(description: 'Item count'),
        },
        required: ['title'],
      );

      final instruction = schema.toPromptInstruction();

      expect(instruction, contains('Return ONLY a valid JSON object'));
      expect(instruction, contains('"title"'));
      expect(instruction, contains('"count"'));
      expect(instruction, contains('(optional)'));
    });

    test('should handle array schema', () {
      final schema = SchemaDefinition(
        type: SchemaType.array,
        properties: {
          'items': PropertyBuilder.string(),
        },
      );

      final jsonSchema = schema.toJsonSchema();
      expect(jsonSchema['type'], equals('array'));
      expect(jsonSchema.containsKey('items'), isTrue);
    });
  });

  group('PropertyDefinition Tests', () {
    test('should create string property', () {
      final property = PropertyBuilder.string(
        description: 'A text field',
        enumValues: ['option1', 'option2'],
        defaultValue: 'option1',
      );

      expect(property.type, equals(SchemaType.string));
      expect(property.description, equals('A text field'));
      expect(property.enumValues, equals(['option1', 'option2']));
      expect(property.defaultValue, equals('option1'));
    });

    test('should create number property with constraints', () {
      final property = PropertyBuilder.number(
        description: 'A numeric value',
        minimum: 0,
        maximum: 100,
        defaultValue: 50,
      );

      expect(property.type, equals(SchemaType.number));
      expect(property.minimum, equals(0));
      expect(property.maximum, equals(100));
      expect(property.defaultValue, equals(50));
    });

    test('should create array property', () {
      final property = PropertyBuilder.array(
        description: 'List of strings',
        items: PropertyBuilder.string(),
      );

      expect(property.type, equals(SchemaType.array));
      expect(property.items, isNotNull);
      expect(property.items!.type, equals(SchemaType.string));
    });

    test('should generate property JSON schema', () {
      final property = PropertyBuilder.integer(
        description: 'Age field',
        minimum: 0,
        maximum: 150,
      );

      final jsonSchema = property.toJsonSchema();

      expect(jsonSchema['type'], equals('integer'));
      expect(jsonSchema['description'], equals('Age field'));
      expect(jsonSchema['minimum'], equals(0));
      expect(jsonSchema['maximum'], equals(150));
    });

    test('should get example values', () {
      expect(
          PropertyBuilder.string().getExampleValue(), equals('"string value"'));
      expect(PropertyBuilder.number().getExampleValue(), equals('0.0'));
      expect(PropertyBuilder.integer().getExampleValue(), equals('0'));
      expect(PropertyBuilder.boolean().getExampleValue(), equals('true'));
      expect(
          PropertyBuilder.array(items: PropertyBuilder.string())
              .getExampleValue(),
          equals('[]'));
      expect(PropertyBuilder.object().getExampleValue(), equals('{}'));
    });
  });

  group('SchemaType Tests', () {
    test('should have correct string names', () {
      expect(SchemaType.string.name, equals('string'));
      expect(SchemaType.number.name, equals('number'));
      expect(SchemaType.integer.name, equals('integer'));
      expect(SchemaType.boolean.name, equals('boolean'));
      expect(SchemaType.array.name, equals('array'));
      expect(SchemaType.object.name, equals('object'));
      expect(SchemaType.null_.name, equals('null'));
    });
  });
}
