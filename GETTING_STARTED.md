# Getting Started with Net Zero Cloud (NZC) Regression Testing

## ✅ Setup Complete!

Your CumulusCI Robot Framework regression testing suite for **Salesforce Net Zero Cloud** is now fully configured and working!

## 🚀 Quick Start

### Run Tests Right Now

```bash
# Run Net Zero Cloud workflow test (RECOMMENDED - tests NZC-specific objects)
cci task run robot --suites robot/nzc-regresiontesting-cci/tests/nzc_simple_workflow.robot --org your-org-name

# Run smoke tests (fastest - 4 tests, API only)
cci task run robot --suites robot/nzc-regresiontesting-cci/tests/smoke_tests.robot --org your-org-name

# Run all API tests (8 tests, no browser required)
cci task run robot_api --org your-org-name

# Run all regression tests
cci task run robot --org your-org-name
```

## ✅ Test Results

All tests are currently passing:
- ✅ 4/4 Smoke tests passing
- ✅ 8/8 API tests passing
- ✅ Account CRUD operations
- ✅ Opportunity lifecycle
- ✅ Contact creation
- ✅ Org connectivity

## 📊 View Test Results

After running tests, open the HTML reports:

```bash
# Open test report
open robot/nzc-regresiontesting-cci/results/report.html

# Open detailed log
open robot/nzc-regresiontesting-cci/results/log.html
```

## 📁 Project Structure

```
robot/
├── QUICK_REFERENCE.md                           # Command reference
└── nzc-regresiontesting-cci/
    ├── resources/
    │   └── nzc-regresiontesting-cci.robot      # Custom keywords
    ├── tests/
    │   ├── smoke_tests.robot                    # 4 smoke tests ✅
    │   ├── create_contact.robot                 # Contact examples
    │   ├── account_regression.robot             # Account tests
    │   └── opportunity_regression.robot         # Opportunity tests
    └── results/                                 # Auto-generated reports
```

## 📚 Available Test Commands

### By Test Type
```bash
# Smoke tests only (quick validation)
cci task run robot --suites robot/nzc-regresiontesting-cci/tests/smoke_tests.robot --org your-org-name

# API tests only (no browser)
cci task run robot_api --org your-org-name

# UI tests only (requires Chrome & ChromeDriver)
cci task run robot_ui --org your-org-name
```

### By Tag
```bash
# Critical tests only
cci task run robot --include critical --org your-org-name

# Smoke tests
cci task run robot --include smoke --org your-org-name

# Account tests
cci task run robot --include account --org your-org-name

# Opportunity tests
cci task run robot --include opportunity --org your-org-name
```

### Specific Test Suite
```bash
# Run specific file
cci task run robot --suites robot/nzc-regresiontesting-cci/tests/account_regression.robot --org your-org-name
```

## 🏷️ Test Tags

Use tags to filter tests:
- `smoke` - Quick validation (4 tests)
- `api` - API-based tests (8 tests)
- `ui` - Browser tests (requires ChromeDriver)
- `critical` - Business-critical functionality
- `regression` - Full regression tests
- `contact`, `account`, `opportunity` - Object-specific

## 📝 Current Test Coverage

### Smoke Tests (smoke_tests.robot) - ✅ All Passing
1. ✅ Org Connection Test - Verify SOQL queries work
2. ✅ Create And Retrieve Contact
3. ✅ Create And Retrieve Account
4. ✅ Create And Retrieve Opportunity

### Account Regression (account_regression.robot)
1. ✅ Create Account Via API
2. ⚠️ Create Account Via UI (requires ChromeDriver)
3. ✅ Update Account Via API
4. ✅ Delete Account Via API
5. ⚠️ Search For Account (requires ChromeDriver)

### Opportunity Regression (opportunity_regression.robot)
1. ✅ Create Opportunity Via API
2. ⚠️ Create Opportunity Via UI (requires ChromeDriver)
3. ✅ Update Opportunity Stage Via API
4. ✅ Close Opportunity As Won
5. ✅ Close Opportunity As Lost

### Contact Examples (create_contact.robot)
1. ✅ Via API
2. ⚠️ Via UI (requires ChromeDriver)

## ⚙️ For UI Tests (Optional)

UI tests require Chrome and ChromeDriver. To run them:

1. **Install Chrome** (if not already installed)
2. **Install ChromeDriver**:
   ```bash
   # macOS with Homebrew
   brew install chromedriver
   
   # Or download from:
   # https://chromedriver.chromium.org/
   ```

3. **Run UI tests**:
   ```bash
   cci task run robot_ui --org your-org-name
   ```

## 🎯 Next Steps

1. **Review passing tests** - Look at the test files to understand the patterns
2. **Add your own tests** - Copy and modify existing tests for your needs
3. **Run regularly** - Integrate into your CI/CD pipeline
4. **Customize keywords** - Add your own keywords to `resources/nzc-regresiontesting-cci.robot`

## 📖 Documentation

- **README.md** - Complete project documentation
- **robot/QUICK_REFERENCE.md** - Quick command reference
- **This file (GETTING_STARTED.md)** - Quick start guide

## 💡 Tips

1. **Start with API tests** - They're faster and don't require browser setup
2. **Use tags** - Filter tests with `--include` and `--exclude`
3. **View results** - Always check the HTML reports for details
4. **Fake data** - All tests use `Get Fake Data` for realistic test data
5. **Auto cleanup** - Test data is automatically deleted after tests

## 🔍 Troubleshooting

### Check Org Connection
```bash
cci org info your-org-name
```

### Run Single Test for Debugging
```bash
cci task run robot --suites robot/nzc-regresiontesting-cci/tests/smoke_tests.robot --test "Org Connection Test" --org your-org-name
```

### View Detailed Logs
```bash
open robot/nzc-regresiontesting-cci/results/log.html
```

## 🎉 Success!

You're all set! Start by running the smoke tests:

```bash
cci task run robot --suites robot/nzc-regresiontesting-cci/tests/smoke_tests.robot --org your-org-name
```

Happy testing! 🚀

