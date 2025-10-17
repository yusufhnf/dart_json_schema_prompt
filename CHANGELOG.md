# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.1] - 2025-10-17

### Added
- Comprehensive GitHub Actions workflows for CI/CD and automated publishing
- Professional project documentation (CONTRIBUTING.md, SECURITY.md)
- GitHub issue templates for bugs, features, and documentation
- Pull request template with detailed review checklist
- Automated release management workflow
- Multi-platform testing (Ubuntu, Windows, macOS)
- Code coverage reporting integration

### Improved
- Enhanced project structure following industry best practices
- Professional Git Flow workflow implementation
- Better developer experience with clear contribution guidelines

## [1.0.0] - 2025-10-15

### Added
- Initial release of dart_json_schema_prompt package
- `JsonSchemaPrompt` class for creating structured prompts with JSON schema specifications
- `JsonSchemaParser` class for parsing and validating JSON responses
- `PropertyBuilder` utility class for creating property definitions
- Support for object, array, and primitive data types
- Schema validation with detailed error reporting
- JSON extraction from mixed text responses (handles AI responses with extra text)
- Comprehensive error handling with custom exception types
- Support for complex nested objects and arrays
- Built-in property constraints (min/max values, enum values, etc.)
- Zero external dependencies - pure Dart implementation

### Features
- Create prompts for single objects, arrays, or arrays of objects
- Automatic JSON schema generation from property definitions
- Validate JSON responses against defined schemas
- Extract clean JSON from AI responses that may contain additional text
- Support for required fields and optional properties
- Rich property types: string, number, integer, boolean, array, object
- Property constraints: minimum/maximum values, enum validation, format specification
- Comprehensive test coverage
- Detailed documentation and examples

### Developer Experience
- Simple, intuitive API design
- Extensive documentation with real-world examples
- Complete test coverage
- Ready for pub.dev publication
- Example integration with AI APIs (Google Gemini, OpenAI, etc.)