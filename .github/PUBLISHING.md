# GitHub Actions Setup for Automated Publishing

This repository includes GitHub Actions workflows for automated testing and publishing to pub.dev.

## 🔧 Setup Instructions

### 1. Get Your pub.dev Token

1. Go to https://pub.dev/publishers
2. Click on your publisher or create one
3. Go to "Admin" tab
4. Generate an access token
5. Copy the token (it will look like a long string)

### 2. Add Token to GitHub Secrets

1. Go to your GitHub repository: https://github.com/yusufhnf/dart_json_schema_prompt
2. Click on "Settings" tab
3. In the left sidebar, click "Secrets and variables" → "Actions"
4. Click "New repository secret"
5. Name: `PUB_TOKEN`
6. Value: Paste your pub.dev token
7. Click "Add secret"

## 🚀 How to Use

### Automatic Testing (CI)
- **Trigger**: Every push to `main` branch and every pull request
- **What it does**: 
  - Tests on Dart stable and beta versions
  - Runs code formatting checks
  - Runs static analysis
  - Runs all tests
  - Validates package can be published

### Automatic Publishing
- **Trigger**: When you push a version tag (e.g., `v1.0.1`)
- **What it does**:
  - Runs all CI checks
  - Automatically publishes to pub.dev

### Publishing a New Version

1. **Update version in pubspec.yaml**:
   ```yaml
   version: 1.0.1  # Update this
   ```

2. **Update CHANGELOG.md** with new version details

3. **Commit and push changes**:
   ```bash
   git add .
   git commit -m "Release version 1.0.1"
   git push origin main
   ```

4. **Create and push version tag**:
   ```bash
   git tag v1.0.1
   git push origin v1.0.1
   ```

5. **GitHub Action will automatically**:
   - Run all tests
   - Publish to pub.dev
   - Create a GitHub release (optional)

## 🔍 Monitoring

- Check the "Actions" tab in your GitHub repository to monitor workflow runs
- You'll receive notifications if publishing fails
- All logs are available in the GitHub Actions interface

## 🛠️ Troubleshooting

### Common Issues:

1. **Publishing fails with authentication error**:
   - Check that `PUB_TOKEN` secret is correctly set
   - Verify your pub.dev token is still valid

2. **Tests fail**:
   - Fix the failing tests before creating a version tag
   - The CI workflow will show you what's failing

3. **Format check fails**:
   - Run `dart format .` locally and commit the changes

4. **Analysis fails**:
   - Run `dart analyze` locally and fix any issues

## 📋 Workflow Files

- `.github/workflows/ci.yml` - Continuous Integration (testing)
- `.github/workflows/publish.yml` - Automated publishing to pub.dev