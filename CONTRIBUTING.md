# Contributing to Net Zero Cloud Regression Testing

Thank you for your interest in contributing to this project! 🎉

## How to Contribute

### Reporting Issues

If you find a bug or have a suggestion:
1. Check if the issue already exists
2. Create a new issue with:
   - Clear description of the problem
   - Steps to reproduce (for bugs)
   - Expected vs actual behavior
   - Your environment details (OS, Python version, CumulusCI version)

### Submitting Changes

1. **Fork the repository**
   ```bash
   # Fork on GitHub, then clone your fork
   git clone https://github.com/YOUR-USERNAME/nzc-regresiontesting-cci.git
   cd nzc-regresiontesting-cci
   ```

2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Follow the existing code style
   - Add tests for new features
   - Update documentation as needed

4. **Test your changes**
   ```bash
   # Run all tests
   cci task run robot_api --org your-org-name
   
   # Run smoke tests
   cci task run robot --suites robot/nzc-regresiontesting-cci/tests/smoke_tests.robot --org your-org-name
   ```

5. **Commit your changes**
   ```bash
   git add .
   git commit -m "Add feature: description of your changes"
   ```

6. **Push and create Pull Request**
   ```bash
   git push origin feature/your-feature-name
   # Then create a Pull Request on GitHub
   ```

## Code Style Guidelines

### Robot Framework Tests

- Use clear, descriptive test names
- Add `[Documentation]` to all test cases
- Use appropriate `[Tags]` for filtering
- Keep tests independent and isolated
- Use fake data generation via `Get Fake Data`
- Clean up test data in teardown

Example:
```robot
*** Test Cases ***
Test Net Zero Cloud Feature
    [Documentation]    Clear description of what this test does
    [Tags]    api    netzero    critical
    
    ${account_id}=    Salesforce Insert    Account    Name=Test Account
    # ... test steps ...
```

### Documentation

- Keep README.md up to date
- Use generic org names (`your-org-name`)
- Provide clear examples
- Update FINAL_SUMMARY.md with new features

## Types of Contributions

### Most Wanted

1. **New NZC Test Cases**
   - Additional Net Zero Cloud object coverage
   - Edge cases and validation tests
   - Performance tests for bulk operations

2. **UI Test Improvements**
   - Fix and enhance UI test keywords
   - Add more Lightning Experience tests
   - Mobile responsive tests

3. **Documentation**
   - More examples
   - Video tutorials
   - Troubleshooting guides
   - Translation to other languages

4. **Bug Fixes**
   - Fix failing tests
   - Improve error handling
   - Better error messages

### Test Categories

Add tests in these categories:

- **Net Zero Cloud Objects**
  - StnryAssetEnvrSrc
  - StnryAssetEnrgyUse
  - AnnualEmssnInventory
  - StnryAssetCrbnFtprnt
  - Additional NZC objects

- **Standard Objects**
  - Account
  - Contact
  - Opportunity
  - Any custom objects

- **Workflows**
  - End-to-end business processes
  - Integration scenarios
  - Data validation

## Development Setup

1. **Prerequisites**
   ```bash
   # Install CumulusCI
   pip install cumulusci
   
   # Install Robot Framework (via CumulusCI)
   pipx inject cumulusci robotframework-seleniumlibrary
   ```

2. **Connect an org**
   ```bash
   cci org connect your-org-name
   ```

3. **Run tests**
   ```bash
   # Run a specific test
   cci task run robot --suites robot/nzc-regresiontesting-cci/tests/nzc_simple_workflow.robot --org your-org-name
   ```

## Pull Request Guidelines

### Before Submitting

- ✅ All tests pass
- ✅ Documentation is updated
- ✅ Code follows existing patterns
- ✅ Commit messages are clear
- ✅ No hardcoded org names or credentials

### PR Description Should Include

- What changes were made
- Why the changes were needed
- How to test the changes
- Any breaking changes
- Screenshots (for UI changes)

### Example PR Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Test improvement

## Testing
- Tested on: Salesforce version X.X
- All existing tests pass: Yes/No
- New tests added: Yes/No

## Checklist
- [ ] Code follows style guidelines
- [ ] Documentation updated
- [ ] Tests pass
- [ ] No hardcoded credentials
```

## Community Guidelines

- Be respectful and inclusive
- Provide constructive feedback
- Help others when possible
- Follow the code of conduct

## Questions?

- Open an issue for questions
- Check existing documentation first
- Review CumulusCI docs: https://cumulusci.readthedocs.io/

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to Net Zero Cloud testing! 🌱

