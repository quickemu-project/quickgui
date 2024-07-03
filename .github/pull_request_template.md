# Description

Please include a summary of the changes along with any relevant motivation and context.

<!-- Delete if not relevant -->

- Closes #
- Fixes #
- Resolves #

## Type of change

<!-- Delete any that are not relevant -->

- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Packaging (updates the packaging)
- [ ] Documentation (updates the documentation)

# Checklist:

<!-- Delete any that are not relevant -->

- [ ] I have performed a self-review of my code
- [ ] I have tested my code in common scenarios and confirmed there are no regressions
- [ ] I have added comments to my code, particularly in hard-to-understand sections
- [ ] I have made corresponding changes to the documentation
- [ ] I have updated and committed `pubspec.yaml` and `pubspec.lock`
  - `flutter pub get`
- [ ] I have updated and committed `pubspec.lock.json` (*required for Nix*)
  - `yq eval pubspec.lock -o=json -P > pubspec.lock.json`

*`yq` above is [yq-go](https://github.com/mikefarah/yq)*
