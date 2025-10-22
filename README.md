# Net Zero Cloud (NZC) Regression Testing with CumulusCI

This project contains comprehensive regression testing scripts for **Salesforce Net Zero Cloud** using CumulusCI's Robot Framework integration. Test both standard Salesforce objects and NZC-specific data models including carbon footprint calculations and energy tracking.

## Prerequisites

1. **CumulusCI** - Install via pip: `pip install cumulusci`
2. **Chrome Browser** - Download from [Google Chrome](https://www.google.com/chrome/)
3. **ChromeDriver** - Download from [ChromeDriver](https://chromedriver.chromium.org/) and place in `/usr/local/bin` or on your PATH
4. **Connected Org** - Ensure you have connected your org using `cci org connect`

## Project Structure

```
robot/
└── nzc-regresiontesting-cci/
    ├── resources/
    │   └── nzc-regresiontesting-cci.robot    # Custom keywords and resources
    ├── tests/
    │   ├── smoke_tests.robot                 # Quick validation tests
    │   ├── nzc_simple_workflow.robot         # ✨ Net Zero Cloud workflow tests
    │   ├── create_contact.robot              # Contact creation examples
    │   ├── account_regression.robot          # Account regression tests
    │   ├── opportunity_regression.robot      # Opportunity regression tests
    │   ├── ui_contact_tests.robot            # UI Contact tests
    │   ├── ui_account_tests.robot            # UI Account tests
    │   ├── ui_opportunity_tests.robot        # UI Opportunity tests
    │   └── ui_workflow_tests.robot           # UI Workflow tests
    ├── results/                              # Test execution results
    └── doc/                                  # Test documentation
```

## Net Zero Cloud Testing

This framework includes specialized tests for **Net Zero Cloud objects**:
- **StnryAssetEnvrSrc** (Stationary Asset Environmental Source)
- **StnryAssetEnrgyUse** (Stationary Asset Energy Use)
- **AnnualEmssnInventory** (Annual Emission Inventory)
- **StnryAssetCrbnFtprnt** (Stationary Asset Carbon Footprint - auto-generated)

## Running Tests

### Net Zero Cloud Workflow Tests (Recommended Starting Point)
```bash
# Run the complete NZC workflow test
cci task run robot --suites robot/nzc-regresiontesting-cci/tests/nzc_simple_workflow.robot --org NZCGus

# This test creates:
# 1. Account
# 2. StnryAssetEnvrSrc (Environmental Source)
# 3. StnryAssetEnrgyUse (Energy Use with FuelType)
# 4. AnnualEmssnInventory (Annual Inventory)
# 5. Verifies auto-generated StnryAssetCrbnFtprnt (Carbon Footprint)
```

### Run All Tests
```bash
cci task run robot --org NZCGus
```

### Run Smoke Tests Only
```bash
cci task run robot_smoke --org NZCGus
```

### Run API Tests Only
```bash
cci task run robot_api --org NZCGus
```

### Run UI Tests Only
```bash
cci task run robot_ui --org NZCGus
```

### Run Specific Test Suite
```bash
cci task run robot --suites robot/nzc-regresiontesting-cci/tests/smoke_tests.robot --org NZCGus
```

### Run Tests with Specific Tags
```bash
cci task run robot --include critical --org NZCGus
```

## Test Organization

Tests are organized by:

1. **Smoke Tests** (`smoke_tests.robot`) - Quick validation of critical functionality
2. **Object-Specific Tests** - Comprehensive regression tests for each object:
   - `account_regression.robot` - Account CRUD and search
   - `opportunity_regression.robot` - Opportunity lifecycle and stage management
   - `create_contact.robot` - Contact creation via API and UI

## Test Tags

Tests are tagged for easy filtering:
- `smoke` - Critical smoke tests
- `regression` - Full regression tests
- `api` - API-based tests
- `ui` - UI-based browser tests
- `critical` - Business-critical functionality
- `destructive` - Tests that delete data

## Custom Keywords

The `resources/nzc-regresiontesting-cci.robot` file contains reusable keywords:

- `Setup Test Suite` / `Teardown Test Suite` - Suite-level setup/cleanup
- `Setup Test Case` / `Teardown Test Case` - Test-level setup/cleanup
- `Create Test Contact` - Create test contact with fake data
- `Create Test Account` - Create test account with fake data
- `Create Test Opportunity` - Create test opportunity with fake data
- `Navigate To Object Home` - Navigate to object home page
- `Navigate To Record` - Navigate to record detail page
- `Verify Field Value` - Verify field values on records
- `Fill Lightning Input` - Fill Lightning input fields

## Viewing Test Results

After running tests, view detailed reports:

```bash
open robot/nzc-regresiontesting-cci/results/report.html
open robot/nzc-regresiontesting-cci/results/log.html
```

The results directory contains:
- `report.html` - High-level test report
- `log.html` - Detailed execution log
- `output.xml` - Machine-readable results
- Screenshots (on test failures)

## Adding New Tests

1. Create a new `.robot` file in `robot/nzc-regresiontesting-cci/tests/`
2. Import the resources file: `Resource    ../resources/nzc-regresiontesting-cci.robot`
3. Add suite setup/teardown for browser tests
4. Write test cases with appropriate tags
5. Run tests: `cci task run robot --org NZCGus`

### Example Test Template

```robot
*** Settings ***
Documentation    Description of your test suite
Resource         ../resources/nzc-regresiontesting-cci.robot
Suite Setup      Setup Test Suite
Suite Teardown   Teardown Test Suite
Test Setup       Setup Test Case
Test Teardown    Teardown Test Case

*** Test Cases ***
Your Test Name
    [Documentation]    What this test does
    [Tags]    regression    api
    
    # Your test steps here
    ${contact_id}=    Create Test Contact
    &{contact}=    Salesforce Get    Contact    ${contact_id}
    Should Not Be Empty    ${contact}[Id]
```

## Best Practices

1. **Tag all tests** - Use tags for easy filtering (`smoke`, `regression`, `api`, `ui`, `critical`)
2. **Use fake data** - Always use `Get Fake Data` for test data generation
3. **Clean up** - The framework automatically cleans up test data via `Delete Session Records`
4. **Page objects** - Use custom keywords for common operations
5. **Screenshots** - Automatic screenshots on test failures
6. **Independent tests** - Each test should be able to run independently

## Troubleshooting

### ChromeDriver Issues
- Ensure ChromeDriver version matches your Chrome browser version
- Verify ChromeDriver is on your PATH: `which chromedriver`
- Update ChromeDriver: Download latest from [ChromeDriver Downloads](https://chromedriver.chromium.org/)

### Org Connection Issues
- Verify org connection: `cci org list`
- Reconnect if needed: `cci org connect NZCGus`
- Check org info: `cci org info NZCGus`

### Test Failures
- Check `robot/nzc-regresiontesting-cci/results/log.html` for detailed error logs
- Review screenshots in the results directory
- Run individual failing tests for easier debugging

## Learn More

- [CumulusCI Documentation](https://cumulusci.readthedocs.io/)
- [Robot Framework Documentation](https://cumulusci.readthedocs.io/en/latest/robot.html)
- [Robot Framework User Guide](https://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html)
