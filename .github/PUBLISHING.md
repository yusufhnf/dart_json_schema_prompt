# Publishing Guide for dart_json_schema_prompt

This guide explains how to set up automated publishing to pub.dev using GitHub Actions.

## 🔐 Setting up Pub.dev Credentials

### Step 1: Get Your Pub.dev Credentials

1. **Authenticate locally** (if not done already):
   ```bash
   dart pub login
   ```

2. **Get your credentials** from the local file:
   - **macOS/Linux**: `~/.pub-cache/credentials.json`
   - **Windows**: `%APPDATA%\Pub\Cache\credentials.json`

3. **Copy the entire content** of the credentials.json file

### Step 2: Add GitHub Secret

1. Go to your repository: https://github.com/yusufhnf/dart_json_schema_prompt
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Name: `PUB_CREDENTIALS`
5. Value: Paste the entire content of your credentials.json file
6. Click **Add secret**

## 🚀 Publishing Methods

### Method 1: Automatic (Recommended)
Push a git tag with version format `v*.*.*`:
```bash
git tag v1.0.2
git push origin v1.0.2
```

### Method 2: Manual Trigger
1. Go to **Actions** tab in your GitHub repository
2. Select **Publish to pub.dev** workflow
3. Click **Run workflow**
4. Enter the version number
5. Click **Run workflow**

### Method 3: GitHub Release
1. Create a new release on GitHub
2. Use tag format `v*.*.*` (e.g., `v1.0.2`)
3. The workflow will automatically trigger

## 📋 Pre-Publishing Checklist

Before triggering a publish:

- [ ] Update version in `pubspec.yaml`
- [ ] Update `CHANGELOG.md` with changes
- [ ] All tests pass (`dart test`)
- [ ] Code analysis passes (`dart analyze`)
- [ ] Dry run succeeds (`dart pub publish --dry-run`)
- [ ] Commit and push changes
- [ ] Create and push git tag

## 🔄 Release Process

### For Patch Releases (1.0.0 → 1.0.1)
```bash
# Update version and changelog
git checkout -b release/v1.0.1
# Edit pubspec.yaml and CHANGELOG.md
git add . && git commit -m "chore: bump version to 1.0.1"
git push -u origin release/v1.0.1
git tag v1.0.1 && git push origin v1.0.1
```

### For Minor Releases (1.0.0 → 1.1.0)
```bash
# Same process but with minor version bump
git checkout -b release/v1.1.0
# Edit pubspec.yaml and CHANGELOG.md  
git add . && git commit -m "chore: bump version to 1.1.0"
git push -u origin release/v1.1.0
git tag v1.1.0 && git push origin v1.1.0
```

### For Major Releases (1.0.0 → 2.0.0)
```bash
# Same process but with major version bump
# Include breaking change documentation
git checkout -b release/v2.0.0
# Edit pubspec.yaml and CHANGELOG.md
git add . && git commit -m "chore: bump version to 2.0.0 - BREAKING CHANGES"
git push -u origin release/v2.0.0
git tag v2.0.0 && git push origin v2.0.0
```

## 🛡️ Security Notes

- **Never commit** pub.dev credentials to your repository
- **Use GitHub Secrets** to store sensitive information
- **Rotate credentials** periodically for security
- **Monitor published packages** for unauthorized changes

## 📊 Monitoring

After publishing:
- Check https://pub.dev/packages/dart_json_schema_prompt
- Verify the new version appears
- Test installation in a fresh project
- Monitor for any issues or user feedback

## 🐛 Troubleshooting

### Authentication Issues
- Regenerate credentials: `dart pub logout && dart pub login`
- Update the GitHub secret with new credentials

### Version Conflicts
- Ensure version in pubspec.yaml matches git tag
- Check for existing versions on pub.dev

### Workflow Failures
- Check GitHub Actions logs
- Verify all secrets are properly set
- Ensure all tests pass locally

---

**Need Help?**
- 📧 Contact: yusufhnf@example.com
- 💬 Telegram: [@yusufhnf](https://t.me/yusufhnf)
- 🐛 Issues: [GitHub Issues](https://github.com/yusufhnf/dart_json_schema_prompt/issues)
