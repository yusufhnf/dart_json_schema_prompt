# Dart JSON Schema Prompt

[![pub package](https://img.shields.io/pub/v/dart_json_schema_prompt.svg)](https://pub.dev/packages/dart_json_schema_prompt)
[![Dart](https://github.com/yusufhnf/dart_json_schema_prompt/workflows/Dart/badge.svg)](https://github.com/yusufhnf/dart_json_schema_prompt/actions)

A powerful Dart package for creating structured prompts with JSON schema specifications and parsing AI responses into strongly-typed objects. Perfect for working with AI APIs like OpenAI GPT, Google Gemini, Anthropic Claude, and others that support structured JSON outputs.

## 🚀 Features

- **Easy Prompt Creation**: Generate structured prompts with JSON schema specifications
- **Type-Safe Parsing**: Parse AI responses into strongly-typed Dart objects
- **Schema Validation**: Automatic validation against defined schemas
- **Support for Complex Types**: Handle objects, arrays, nested structures, and primitives
- **Error Handling**: Comprehensive error handling with detailed messages
- **Clean API Responses**: Extract JSON from responses that may contain additional text
- **Zero Dependencies**: Pure Dart implementation with no external dependencies

## 📦 Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  dart_json_schema_prompt: ^1.0.0
```

Then run:
```bash
dart pub get
```

## 🔥 Quick Start

### 1. Create a Simple Object Prompt

```dart
import 'package:dart_json_schema_prompt/dart_json_schema_prompt.dart';

// Create a prompt for user profile data
final userPrompt = JsonSchemaPrompt.forObject(
  instruction: 'Create a user profile based on the given information.',
  properties: {
    'name': PropertyBuilder.string(description: 'Full name'),
    'age': PropertyBuilder.integer(minimum: 0, maximum: 150),
    'email': PropertyBuilder.string(format: 'email'),
    'skills': PropertyBuilder.array(
      items: PropertyBuilder.string(),
      description: 'List of skills',
    ),
  },
  required: ['name', 'email'],
);

// Generate the prompt string to send to AI
String promptString = JsonSchemaPrompt.generate(userPrompt);
print(promptString);
```

### 2. Parse AI Response

```dart
// AI response (can contain extra text)
const aiResponse = '''
Here's the user profile:
{
  "name": "Alice Smith",
  "age": 28,
  "email": "alice@example.com",
  "skills": ["Flutter", "Dart", "Firebase"]
}
''';

// Parse and validate the response
try {
  final parsed = JsonSchemaParser.parseObject(
    aiResponse,
    schema: userPrompt.schema,
  );
  
  print('Name: ${parsed['name']}');
  print('Age: ${parsed['age']}');
  print('Skills: ${parsed['skills']}');
} catch (e) {
  print('Error: $e');
}
```

### 3. Handle Arrays of Objects

```dart
// Create a prompt for array of products
final productsPrompt = JsonSchemaPrompt.forObjectArray(
  instruction: 'Generate a list of 3 tech products.',
  objectProperties: {
    'name': PropertyBuilder.string(),
    'price': PropertyBuilder.number(minimum: 0),
    'category': PropertyBuilder.string(
      enumValues: ['smartphone', 'laptop', 'tablet'],
    ),
    'inStock': PropertyBuilder.boolean(),
  },
  required: ['name', 'price'],
);

const arrayResponse = '''
[
  {
    "name": "iPhone 15 Pro",
    "price": 999.99,
    "category": "smartphone",
    "inStock": true
  },
  {
    "name": "MacBook Air M3",
    "price": 1299.99,
    "category": "laptop", 
    "inStock": false
  }
]
''';

final products = JsonSchemaParser.parseObjectArray(arrayResponse);
for (final product in products) {
  print('${product['name']}: \$${product['price']}');
}
```

## 🛠️ Advanced Usage

### Custom Property Types

```dart
// String with enum values
final statusProperty = PropertyBuilder.string(
  description: 'Order status',
  enumValues: ['pending', 'processing', 'shipped', 'delivered'],
);

// Number with constraints
final priceProperty = PropertyBuilder.number(
  description: 'Price in USD',
  minimum: 0.01,
  maximum: 9999.99,
);

// Nested array of objects
final itemsProperty = PropertyBuilder.array(
  description: 'Order items',
  items: PropertyBuilder.object(description: 'Order item'),
);
```

### Complex Nested Objects

```dart
final orderPrompt = JsonSchemaPrompt.forObject(
  instruction: 'Create a detailed order with customer and items.',
  properties: {
    'orderId': PropertyBuilder.string(),
    'customer': PropertyBuilder.object(description: 'Customer info'),
    'items': PropertyBuilder.array(
      items: PropertyBuilder.object(description: 'Order item'),
    ),
    'total': PropertyBuilder.number(minimum: 0),
    'metadata': PropertyBuilder.object(description: 'Additional data'),
  },
  required: ['orderId', 'customer', 'items', 'total'],
  additionalInstructions: [
    'Customer should include: name, email, address',
    'Each item should include: productId, name, quantity, price',
    'Calculate total as sum of all item prices × quantities',
  ],
);
```

### Error Handling

```dart
try {
  final result = JsonSchemaParser.parseObject(response, schema: schema);
  // Handle successful parsing
} on JsonParsingException catch (e) {
  // Handle JSON parsing errors
  print('Failed to parse JSON: ${e.message}');
} on JsonSchemaValidationException catch (e) {
  // Handle schema validation errors
  print('Schema validation failed: ${e.message}');
} catch (e) {
  // Handle other errors
  print('Unexpected error: $e');
}
```

## 🎯 Real-World Examples

### Working with AI APIs

```dart
// Example with Google Gemini API
class AIService {
  Future<Map<String, dynamic>> analyzeFood(String imageDescription) async {
    final prompt = JsonSchemaPrompt.forObject(
      instruction: 'Analyze the nutritional content of the described food.',
      properties: {
        'foodName': PropertyBuilder.string(),
        'calories': PropertyBuilder.number(minimum: 0),
        'protein': PropertyBuilder.number(minimum: 0),
        'carbs': PropertyBuilder.number(minimum: 0),
        'fat': PropertyBuilder.number(minimum: 0),
        'nutrients': PropertyBuilder.array(items: PropertyBuilder.string()),
      },
      required: ['foodName', 'calories'],
    );
    
    final promptString = JsonSchemaPrompt.generate(prompt);
    
    // Send to AI API...
    final aiResponse = await callAI(promptString);
    
    // Parse response
    return JsonSchemaParser.parseObject(
      aiResponse,
      schema: prompt.schema,
    );
  }
}
```

### Data Validation

```dart
// Validate API responses
void validateApiResponse(String jsonResponse) {
  final schema = SchemaDefinition(
    type: SchemaType.object,
    properties: {
      'success': PropertyBuilder.boolean(),
      'data': PropertyBuilder.object(),
      'error': PropertyBuilder.string(),
    },
    required: ['success'],
  );
  
  JsonSchemaParser.validateObject(
    JsonSchemaParser.parseObject(jsonResponse),
    schema,
  );
}
```

## 📚 API Reference

### JsonSchemaPrompt

- `forObject()` - Create prompt for single object
- `forArray()` - Create prompt for array  
- `forObjectArray()` - Create prompt for array of objects
- `generate()` - Generate prompt string
- `validateConfig()` - Validate prompt configuration

### JsonSchemaParser

- `parseObject()` - Parse JSON object with validation
- `parseArray()` - Parse JSON array with validation
- `parseObjectArray()` - Parse array of objects
- `extractJson()` - Extract JSON from mixed text
- `validateObject()` - Validate object against schema
- `validateArray()` - Validate array against schema

### PropertyBuilder

- `string()` - Create string property
- `number()` - Create number property  
- `integer()` - Create integer property
- `boolean()` - Create boolean property
- `array()` - Create array property
- `object()` - Create object property

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## �‍💻 Developer Contact

Connect with the developer behind this package:

- [LinkedIn](https://linkedin.com/in/yusufhnf) - Connect with me professionally
- [GitHub](https://github.com/yusufhnf) - Check out my other open source projects
- [Instagram](https://instagram.com/yusufhnf) - Follow me for behind-the-scenes and daily updates
- [Telegram](https://t.me/yusufhnf) - Join my channel for Flutter tips and tricks
- [Website](https://yusufhnf.github.io) - Visit my portfolio and blog for more tutorials

## �📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🌟 Support

If you find this package helpful, please consider giving it a ⭐ on [GitHub](https://github.com/yusufhnf/dart_json_schema_prompt) and a 👍 on [pub.dev](https://pub.dev/packages/dart_json_schema_prompt)!