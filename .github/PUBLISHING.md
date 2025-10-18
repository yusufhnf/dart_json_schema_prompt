# Automated Publishing Setup Guide

This document explains how to set up automated publishing for dart_json_schema_prompt following the official Dart guidelines.

## 🎯 Modern Approach: Trusted Publishing (Recommended)

### Step 1: Configure Repository for Trusted Publishing

1. Go to https://pub.dev/publishers
2. Create or select your publisher (if you don't have one)
3. Go to your package page: https://pub.dev/packages/dart_json_schema_prompt
4. Click on "Admin" tab
5. Under "Automated publishing", click "Enable"
6. Add this repository: `yusufhnf/dart_json_schema_prompt`
7. Set the workflow file: `.github/workflows/publish.yml`
8. Set the environment: `pub.dev` (optional)

### Step 2: Repository Configuration

The repository is already configured with:
- ✅ Proper GitHub Actions workflow in `.github/workflows/publish.yml`
- ✅ Correct permissions (`id-token: write`)
- ✅ Trigger on version tags (`v*.*.*`)
- ✅ Comprehensive testing before publishing

## � Publishing Process

### Automated Publishing (Current Setup)

The package uses **trusted publishing** with OIDC authentication. No secrets required!

#### Step-by-Step Release Process:

1. **Update version** in `pubspec.yaml`:
   ```yaml
   version: 1.0.1  # Increment following semantic versioning
   ```

2. **Update CHANGELOG.md** with release notes

3. **Commit and push** changes:
   ```bash
   git add .
   git commit -m "chore: release version 1.0.1"
   git push origin main
   ```

4. **Create and push tag**:
   ```bash
   git tag v1.0.1
   git push origin v1.0.1
   ```

5. **GitHub Actions** automatically handles:
   - ✅ Running comprehensive test suite
   - ✅ Package validation and dry-run
   - ✅ OIDC authentication with pub.dev
   - ✅ Publishing to pub.dev
   - ✅ Creating GitHub release

## 🔐 Legacy Method: Manual Credentials (Backup)

If trusted publishing fails, you can use manual credentials:

1. **Get credentials**: Run `dart pub login` locally
2. **Copy credentials** from `~/.pub-cache/credentials.json`
3. **Add GitHub Secret**: 
   - Go to repository Settings → Secrets and variables → Actions
   - Create new secret named `PUB_CREDENTIALS`
   - Paste credentials.json content
4. **Update workflow** to use credentials instead of OIDC

## 📋 Pre-Release Checklist

Before creating any release:

- [ ] **Version**: Updated in `pubspec.yaml` following [semantic versioning](https://semver.org/)
- [ ] **Changelog**: Updated `CHANGELOG.md` with new features, fixes, and breaking changes
- [ ] **Tests**: All tests passing locally (`dart test`)
- [ ] **Validation**: Package passes dry-run (`dart pub publish --dry-run`)
- [ ] **Trusted Publishing**: Repository configured on pub.dev trusted publishers
- [ ] **Documentation**: API documentation and README updated if needed
- [ ] **Git**: All changes committed to main branch

## 🔍 Monitoring & Verification

After triggering a release:

1. **GitHub Actions**: Monitor workflow progress in repository Actions tab
2. **Pub.dev Package**: Check https://pub.dev/packages/dart_json_schema_prompt
3. **GitHub Releases**: Verify automatic release creation with changelog
4. **API Documentation**: Confirm docs.flutter.dev update (may take time)

## 🛠️ Troubleshooting Guide

### OIDC/Trusted Publishing Issues

```bash
# Common issues and solutions:

# 1. Repository not linked on pub.dev
# → Go to pub.dev package admin, add repository to trusted publishers

# 2. Workflow permissions missing
# → Verify workflow includes: permissions: id-token: write

# 3. Environment mismatch  
# → Check pub.dev environment name matches workflow (default: no environment)
```

### Package Validation Errors

```bash
# Run local validation first:
dart pub publish --dry-run

# Common fixes:
# - Update pubspec.yaml description (min 60 characters)
# - Add proper homepage/repository URLs
# - Fix analysis issues: dart analyze
# - Update version following semver
```

### Authentication Fallback

If OIDC fails, temporarily switch to credentials:

```yaml
# In .github/workflows/publish.yml, replace OIDC section with:
- name: Publish to pub.dev
  run: |
    mkdir -p ~/.pub-cache
    echo '${{ secrets.PUB_CREDENTIALS }}' > ~/.pub-cache/credentials.json
    dart pub publish --force
```

### Manual Trigger Option

You can also trigger publishing manually:

1. Go to **Actions** tab in GitHub repository
2. Select **Publish to pub.dev** workflow
3. Click **Run workflow**
4. Enter tag version (e.g., `v1.0.1`)
5. Click **Run workflow**

## 🎯 Next Steps

The package is now set up with modern automated publishing. To release version 1.0.1:

```bash
# Update version in pubspec.yaml to 1.0.1
# Update CHANGELOG.md
git add .
git commit -m "chore: release version 1.0.1"
git push origin main
git tag v1.0.1
git push origin v1.0.1
```

The workflow will automatically trigger and handle the rest!

---

## 📞 Support & Resources

- **📚 Official Dart Publishing Guide**: https://dart.dev/tools/pub/automated-publishing  
- **🔐 Trusted Publishing Setup**: https://pub.dev/help/publishing#automated-publishing
- **� Report Issues**: [GitHub Issues](https://github.com/yusufhnf/dart_json_schema_prompt/issues)
- **📦 Package Page**: https://pub.dev/packages/dart_json_schema_prompt

**Package Maintainer**: [@yusufhnf](https://github.com/yusufhnf)
