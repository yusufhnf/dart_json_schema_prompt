# Contributing to dart_json_schema_prompt

Thank you for your interest in contributing to dart_json_schema_prompt! This document provides guidelines and information for contributors.

## 🚀 Getting Started

### Prerequisites
- Dart SDK 3.0.0 or higher
- Git
- GitHub account

### Development Setup
1. Fork the repository on GitHub
2. Clone your fork locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/dart_json_schema_prompt.git
   cd dart_json_schema_prompt
   ```
3. Install dependencies:
   ```bash
   dart pub get
   ```
4. Run tests to ensure everything works:
   ```bash
   dart test
   ```

## 🔄 Development Workflow

We follow the **Git Flow** branching model:

### Branch Structure
- `main`: Production-ready code, published to pub.dev
- `develop`: Integration branch for features
- `feature/*`: New features and enhancements
- `hotfix/*`: Critical fixes for production
- `release/*`: Release preparation

### Making Changes

1. **Create a feature branch from develop:**
   ```bash
   git checkout develop
   git pull origin develop
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes:**
   - Write clear, documented code
   - Add tests for new functionality
   - Update documentation as needed

3. **Test your changes:**
   ```bash
   dart analyze
   dart test
   dart pub publish --dry-run
   ```

4. **Commit with conventional commits:**
   ```bash
   git add .
   git commit -m "feat: add new JSON validation feature"
   ```

5. **Push and create PR:**
   ```bash
   git push origin feature/your-feature-name
   ```
   Then create a Pull Request to `develop` branch.

## 📝 Commit Message Convention

We use [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `style:` Code style changes (formatting, etc.)
- `refactor:` Code refactoring
- `test:` Adding or updating tests
- `chore:` Maintenance tasks

Examples:
```
feat: add support for nested array validation
fix: resolve schema validation edge case
docs: update README with new examples
test: add unit tests for PropertyBuilder
```

## 🧪 Testing Guidelines

### Running Tests
```bash
# Run all tests
dart test

# Run with coverage
dart pub global activate coverage
dart pub global run coverage:test_with_coverage

# Run specific test file
dart test test/json_schema_parser_test.dart
```

### Writing Tests
- All new features must include tests
- Aim for high test coverage (>90%)
- Use descriptive test names
- Follow the existing test structure

## 📚 Documentation

### Code Documentation
- Document all public APIs
- Use clear, concise comments
- Include usage examples

### README Updates
- Update README.md for new features
- Add examples for new functionality
- Keep the API reference current

## 🔍 Code Quality

### Code Style
- Follow Dart style conventions
- Use `dart format` for formatting
- Run `dart analyze` and fix all issues
- Use meaningful variable and function names

### Performance
- Consider performance implications
- Avoid unnecessary object creation
- Use efficient algorithms and data structures

## 📦 Release Process

### Versioning
We follow [Semantic Versioning](https://semver.org/):
- `MAJOR`: Breaking changes
- `MINOR`: New features (backward compatible)
- `PATCH`: Bug fixes (backward compatible)

### Release Steps (Maintainers)
1. Merge features to `develop`
2. Create `release/vX.Y.Z` branch
3. Update version in `pubspec.yaml`
4. Update `CHANGELOG.md`
5. Merge to `main` and tag
6. Automated GitHub Actions will publish to pub.dev

## 🐛 Bug Reports

When reporting bugs, please include:
- Dart/Flutter version
- Package version
- Minimal code example
- Expected vs actual behavior
- Error messages/stack traces

## 💡 Feature Requests

For feature requests:
- Check existing issues first
- Provide clear use cases
- Explain the expected behavior
- Consider backward compatibility

## 📞 Getting Help

- 💬 [GitHub Discussions](https://github.com/yusufhnf/dart_json_schema_prompt/discussions)
- 🐛 [GitHub Issues](https://github.com/yusufhnf/dart_json_schema_prompt/issues)
- 📱 [Telegram](https://t.me/yusufhnf) for quick questions

## 🎉 Recognition

Contributors will be:
- Listed in the repository contributors
- Mentioned in release notes
- Added to the README contributors section

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to dart_json_schema_prompt! 🚀