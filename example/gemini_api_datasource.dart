// This file demonstrates how to use dart_json_schema_prompt with Gemini API
import 'package:dart_json_schema_prompt/dart_json_schema_prompt.dart';

/// Example showing how your existing Gemini code can be simplified
/// using the dart_json_schema_prompt package.

class SimplifiedGeminiExample {
  /// Example of using the package for food analysis
  static void demonstrateFoodAnalysis() {
    // Create a prompt configuration for food analysis
    final foodAnalysisPrompt = JsonSchemaPrompt.forObject(
      instruction:
          'Analyze the food in this image and provide a nutritional analysis.',
      properties: {
        'foodName': PropertyBuilder.string(
          description: 'Name of the food item',
        ),
        'description': PropertyBuilder.string(
          description: 'Brief description of the food',
        ),
        'calories': PropertyBuilder.number(
          description: 'Calories per serving',
          minimum: 0,
        ),
        'protein': PropertyBuilder.number(
          description: 'Protein content in grams',
          minimum: 0,
        ),
        'fat': PropertyBuilder.number(
          description: 'Fat content in grams',
          minimum: 0,
        ),
        'carbohydrates': PropertyBuilder.number(
          description: 'Carbohydrates content in grams',
          minimum: 0,
        ),
        'micronutrients': PropertyBuilder.array(
          description: 'List of micronutrients',
          items: PropertyBuilder.string(),
        ),
        'ingredients': PropertyBuilder.array(
          description: 'List of ingredients',
          items: PropertyBuilder.string(),
        ),
      },
      required: ['foodName', 'calories', 'protein', 'fat', 'carbohydrates'],
      additionalInstructions: [
        'Make reasonable estimates for a typical serving size',
        'All numeric values should be numbers, not strings',
      ],
    );

    // Generate the prompt
    final promptString = JsonSchemaPrompt.generate(foodAnalysisPrompt);
    print('Generated Prompt:');
    print(promptString);
    print('\n${'=' * 50}\n');

    // Example response parsing
    const exampleResponse = '''
    {
      "foodName": "Caesar Salad",
      "description": "Fresh romaine lettuce with Caesar dressing, croutons, and parmesan cheese",
      "calories": 350.0,
      "protein": 12.5,
      "fat": 28.0,
      "carbohydrates": 15.2,
      "micronutrients": ["Vitamin K", "Folate", "Vitamin C"],
      "ingredients": ["romaine lettuce", "caesar dressing", "croutons", "parmesan cheese"]
    }
    ''';

    try {
      final parsed = JsonSchemaParser.parseObject(
        exampleResponse,
        schema: foodAnalysisPrompt.schema,
      );
      print('Parsed successfully: $parsed');
    } catch (e) {
      print('Parsing error: $e');
    }
  }

  /// Example of using the package for food recommendations (array)
  static void demonstrateFoodRecommendations() {
    // Create a prompt for array of food recommendations
    final recommendationsPrompt = JsonSchemaPrompt.forObjectArray(
      instruction:
          'Based on the preference "healthy low-carb meals", recommend 3 Indonesian foods.',
      objectProperties: {
        'foodName':
            PropertyBuilder.string(description: 'Name of the Indonesian food'),
        'description': PropertyBuilder.string(description: 'Brief description'),
        'calories': PropertyBuilder.number(minimum: 0),
        'protein': PropertyBuilder.number(minimum: 0),
        'fat': PropertyBuilder.number(minimum: 0),
        'carbohydrates': PropertyBuilder.number(minimum: 0),
        'micronutrients':
            PropertyBuilder.array(items: PropertyBuilder.string()),
        'ingredients': PropertyBuilder.array(items: PropertyBuilder.string()),
        'recommendationReason': PropertyBuilder.array(
          description: 'Reasons why this food fits the preference',
          items: PropertyBuilder.string(),
        ),
      },
      required: ['foodName', 'calories', 'recommendationReason'],
    );

    final promptString = JsonSchemaPrompt.generate(recommendationsPrompt);
    print('Array Prompt:');
    print(promptString);
    print('\n${'=' * 50}\n');

    // Example array response
    const exampleArrayResponse = '''
    [
      {
        "foodName": "Gado-gado",
        "description": "Indonesian mixed vegetable salad with peanut sauce",
        "calories": 250.0,
        "protein": 12.0,
        "fat": 18.0,
        "carbohydrates": 8.0,
        "micronutrients": ["Vitamin A", "Vitamin C", "Iron"],
        "ingredients": ["mixed vegetables", "peanut sauce", "tofu", "tempeh"],
        "recommendationReason": ["High protein from tofu and tempeh", "Low in carbohydrates", "Rich in vegetables"]
      }
    ]
    ''';

    try {
      final parsed = JsonSchemaParser.parseObjectArray(
        exampleArrayResponse,
        itemSchema: SchemaDefinition(
          type: SchemaType.object,
          properties: recommendationsPrompt.schema.properties,
        ),
      );
      print('Array parsed successfully: $parsed');
    } catch (e) {
      print('Array parsing error: $e');
    }
  }
}
