# Security Policy

## Supported Versions

We actively support the following versions of dart_json_schema_prompt:

| Version | Supported          |
| ------- | ------------------ |
| 1.x.x   | ✅ Yes             |
| < 1.0   | ❌ No              |

## Reporting a Vulnerability

We take security vulnerabilities seriously. If you discover a security vulnerability, please report it responsibly:

### How to Report

1. **Do NOT create a public GitHub issue** for security vulnerabilities
2. Send an email to: **yusufhnf@example.com** (replace with your actual email)
3. Include the following information:
   - Description of the vulnerability
   - Steps to reproduce the issue
   - Possible impact
   - Any suggested fixes (optional)

### What to Expect

- **Response Time**: We aim to acknowledge your report within 48 hours
- **Investigation**: We will investigate and validate the vulnerability
- **Fix Timeline**: Critical vulnerabilities will be fixed within 7 days, others within 30 days
- **Disclosure**: We will coordinate with you on responsible disclosure timing

### Security Best Practices

When using dart_json_schema_prompt:

1. **Input Validation**: Always validate JSON inputs from untrusted sources
2. **Schema Constraints**: Use appropriate constraints (min/max values, string lengths)
3. **Error Handling**: Implement proper error handling for malformed inputs
4. **Updates**: Keep the package updated to the latest version
5. **Testing**: Test your JSON schemas with edge cases and malformed data

### Security Features

This package includes:
- Input sanitization for JSON parsing
- Schema validation to prevent malformed data processing
- Error boundaries to prevent crashes from invalid inputs
- No external dependencies to reduce attack surface

### Scope

This security policy covers:
- The dart_json_schema_prompt package itself
- Security issues in dependencies (we have zero dependencies)
- Documentation that could lead to insecure usage

Out of scope:
- Issues in applications using this package
- General Dart/Flutter security issues
- Social engineering attacks

## Security Contact

- **Primary Contact**: Yusuf Hanafi
- **Email**: yusufhnf@example.com (replace with actual email)
- **Telegram**: [@yusufhnf](https://t.me/yusufhnf)

---

Thank you for helping keep dart_json_schema_prompt and its users safe!