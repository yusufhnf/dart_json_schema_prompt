import 'package:dart_json_schema_prompt/dart_json_schema_prompt.dart';

void main() {
  print('=== Dart JSON Schema Prompt Examples ===\n');

  // Example 1: Simple object parsing
  objectExample();

  print('\n${'=' * 60}\n');

  // Example 2: Array parsing
  arrayExample();

  print('\n${'=' * 60}\n');

  // Example 3: Complex nested object
  complexExample();
}

void objectExample() {
  print('📋 Example 1: Simple Object Prompt\n');

  // Create a prompt for user profile
  final userPrompt = JsonSchemaPrompt.forObject(
    instruction: 'Create a user profile based on the given information.',
    properties: {
      'name': PropertyBuilder.string(description: 'Full name of the user'),
      'age': PropertyBuilder.integer(
          description: 'Age in years', minimum: 0, maximum: 150),
      'email':
          PropertyBuilder.string(description: 'Email address', format: 'email'),
      'isActive':
          PropertyBuilder.boolean(description: 'Whether the user is active'),
      'skills': PropertyBuilder.array(
        description: 'List of skills',
        items: PropertyBuilder.string(),
      ),
    },
    required: ['name', 'age', 'email'],
    examples: [
      {
        'name': 'John Doe',
        'age': 30,
        'email': 'john@example.com',
        'isActive': true,
        'skills': ['JavaScript', 'Dart', 'Python']
      }
    ],
  );

  print('Generated Prompt:');
  print(JsonSchemaPrompt.generate(userPrompt));

  // Example response
  const response = '''
  {
    "name": "Alice Smith",
    "age": 28,
    "email": "alice@example.com",
    "isActive": true,
    "skills": ["Flutter", "Dart", "Firebase"]
  }
  ''';

  try {
    final parsed =
        JsonSchemaParser.parseObject(response, schema: userPrompt.schema);
    print('\n✅ Parsed Result:');
    print('Name: ${parsed['name']}');
    print('Age: ${parsed['age']}');
    print('Skills: ${parsed['skills']}');
  } catch (e) {
    print('❌ Error: $e');
  }
}

void arrayExample() {
  print('📋 Example 2: Array of Objects\n');

  // Create a prompt for product list
  final productsPrompt = JsonSchemaPrompt.forObjectArray(
    instruction: 'Generate a list of 3 tech products with their details.',
    objectProperties: {
      'name': PropertyBuilder.string(description: 'Product name'),
      'price': PropertyBuilder.number(description: 'Price in USD', minimum: 0),
      'category': PropertyBuilder.string(
        description: 'Product category',
        enumValues: ['smartphone', 'laptop', 'tablet', 'accessory'],
      ),
      'inStock': PropertyBuilder.boolean(description: 'Availability status'),
      'features': PropertyBuilder.array(
        description: 'Key features',
        items: PropertyBuilder.string(),
      ),
    },
    required: ['name', 'price', 'category'],
  );

  print('Generated Array Prompt:');
  print(JsonSchemaPrompt.generate(productsPrompt));

  // Example array response
  const arrayResponse = '''
  [
    {
      "name": "iPhone 15 Pro",
      "price": 999.99,
      "category": "smartphone",
      "inStock": true,
      "features": ["A17 Pro chip", "Titanium design", "Action Button"]
    },
    {
      "name": "MacBook Air M3",
      "price": 1299.99,
      "category": "laptop",
      "inStock": false,
      "features": ["M3 chip", "13.6-inch display", "18-hour battery"]
    }
  ]
  ''';

  try {
    final parsed = JsonSchemaParser.parseObjectArray(arrayResponse);
    print('\n✅ Parsed Array Results:');
    for (int i = 0; i < parsed.length; i++) {
      final product = parsed[i];
      print(
          '${i + 1}. ${product['name']} - \$${product['price']} (${product['category']})');
    }
  } catch (e) {
    print('❌ Error: $e');
  }
}

void complexExample() {
  print('📋 Example 3: Complex Nested Object\n');

  // Create a complex prompt with nested objects
  final orderPrompt = JsonSchemaPrompt.forObject(
    instruction:
        'Create a detailed order object with customer and items information.',
    properties: {
      'orderId': PropertyBuilder.string(description: 'Unique order identifier'),
      'orderDate':
          PropertyBuilder.string(description: 'Order date', format: 'date'),
      'customer': PropertyBuilder.object(description: 'Customer information'),
      'items': PropertyBuilder.array(
        description: 'Order items',
        items: PropertyBuilder.object(description: 'Order item'),
      ),
      'total': PropertyBuilder.number(description: 'Total amount', minimum: 0),
      'status': PropertyBuilder.string(
        description: 'Order status',
        enumValues: ['pending', 'processing', 'shipped', 'delivered'],
      ),
    },
    required: ['orderId', 'customer', 'items', 'total'],
    additionalInstructions: [
      'Customer object should include: name, email, address',
      'Each item should include: productId, name, quantity, price',
      'Calculate total as sum of all item prices multiplied by quantities',
    ],
  );

  print('Generated Complex Prompt:');
  print(JsonSchemaPrompt.generate(orderPrompt));

  // Test with malformed JSON to show error handling
  const malformedJson = '''
  {
    "orderId": "ORD-12345",
    "customer": {
      "name": "Bob Johnson"
      // Missing comma and other fields
    }
    // Missing required fields
  }
  ''';

  try {
    JsonSchemaParser.parseObject(malformedJson, schema: orderPrompt.schema);
  } catch (e) {
    print('\n⚠️  Expected Error for Malformed JSON:');
    print('Error: $e');
  }

  // Test with valid JSON
  const validJson = '''
  {
    "orderId": "ORD-12345",
    "orderDate": "2024-01-15",
    "customer": {
      "name": "Bob Johnson",
      "email": "bob@example.com",
      "address": "123 Main St, City"
    },
    "items": [
      {
        "productId": "P001",
        "name": "Wireless Headphones",
        "quantity": 1,
        "price": 89.99
      }
    ],
    "total": 89.99,
    "status": "pending"
  }
  ''';

  try {
    final parsed =
        JsonSchemaParser.parseObject(validJson, schema: orderPrompt.schema);
    print('\n✅ Valid JSON Parsed Successfully:');
    print('Order ID: ${parsed['orderId']}');
    print('Customer: ${parsed['customer']['name']}');
    print('Items count: ${parsed['items'].length}');
    print('Total: \$${parsed['total']}');
  } catch (e) {
    print('❌ Unexpected error: $e');
  }
}
