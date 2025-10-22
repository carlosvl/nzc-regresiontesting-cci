# Robot Framework Quick Reference

## Running Tests

### Basic Commands
```bash
# Run all tests
cci task run robot --org NZCGus

# Run smoke tests only
cci task run robot_smoke --org NZCGus

# Run API tests only
cci task run robot_api --org NZCGus

# Run UI tests only
cci task run robot_ui --org NZCGus

# Run specific test file
cci task run robot --suites robot/nzc-regresiontesting-cci/tests/smoke_tests.robot --org NZCGus

# Run tests with specific tag
cci task run robot --include smoke --org NZCGus
cci task run robot --include critical --org NZCGus
cci task run robot --include api,smoke --org NZCGus

# Exclude certain tests
cci task run robot --exclude destructive --org NZCGus

# Run with debug output
cci task run robot --org NZCGus --debug
```

## Common Robot Framework Keywords

### Salesforce API Keywords
```robot
# Insert a record
${contact_id}=    Salesforce Insert    Contact
...    FirstName=John
...    LastName=Doe
...    Email=john.doe@example.com

# Get a record
&{contact}=    Salesforce Get    Contact    ${contact_id}

# Update a record
Salesforce Update    Contact    ${contact_id}
...    Phone=(555) 123-4567

# Delete a record
Salesforce Delete    Contact    ${contact_id}

# Query records
@{results}=    Salesforce Query    Contact
...    SELECT Id, Name FROM Contact WHERE LastName = 'Doe'

# SOSL search
@{results}=    Salesforce Search    FIND {test@example.com}
```

### Browser Keywords
```robot
# Navigate to pages
Go To Page    Home
Go To Page    Listing    Contact
Go To Page    Detail    Contact    object_id=${contact_id}

# Click buttons
Click Object Button    New
Click Modal Button    Save
Click Button With Text    Save & New

# Fill forms
Fill Lightning Input    First Name    John
Populate Lookup Field    Account Name    Acme Corp
Pick List    Stage    Prospecting

# Wait for elements
Wait Until Loading Is Complete
Wait For Modal    New    Contact
Wait Until Modal Is Closed
Wait Until Element Is Visible    //button[@title='Save']

# Verify values
${value}=    Get Field Value    First Name
Should Be Equal    ${value}    John

# Screenshots
Capture Page Screenshot
```

### Data Generation
```robot
# Generate fake data
${first_name}=    Get Fake Data    first_name
${last_name}=     Get Fake Data    last_name
${email}=         Get Fake Data    email
${phone}=         Get Fake Data    phone_number
${company}=       Get Fake Data    company
${address}=       Get Fake Data    address
${city}=          Get Fake Data    city
${state}=         Get Fake Data    state
${zip}=           Get Fake Data    zipcode
${url}=           Get Fake Data    url
${sentence}=      Get Fake Data    sentence
${paragraph}=     Get Fake Data    paragraph
```

### Date/Time Keywords
```robot
# Get current date
${today}=    Get Current Date    result_format=%Y-%m-%d
${tomorrow}=    Get Current Date    result_format=%Y-%m-%d    increment=1 day
${next_month}=    Get Current Date    result_format=%Y-%m-%d    increment=30 days

# Format: %Y-%m-%d = 2024-10-20
# Format: %m/%d/%Y = 10/20/2024
```

### Assertions
```robot
# Equality checks
Should Be Equal    ${actual}    ${expected}
Should Be Equal As Strings    ${actual}    ${expected}
Should Be Equal As Numbers    ${actual}    ${expected}

# Boolean checks
Should Be True    ${condition}
Should Be False    ${condition}

# Collection checks
Should Not Be Empty    ${list}
Should Contain    ${list}    ${item}
Length Should Be    ${list}    5

# Status checks
Should Be Equal    ${status}    PASS
Should Be Equal    ${status}    FAIL
```

### Session Management
```robot
# Clean up all records created in this session
Delete Session Records

# Get current record ID from URL
${record_id}=    Get Current Record Id
```

## Test Structure

### Basic Test Template
```robot
*** Settings ***
Documentation    Test suite description
Resource         ../resources/nzc-regresiontesting-cci.robot
Suite Setup      Setup Test Suite
Suite Teardown   Teardown Test Suite
Test Setup       Setup Test Case
Test Teardown    Teardown Test Case

*** Test Cases ***
Test Name
    [Documentation]    What this test does
    [Tags]    smoke    api
    
    # Test steps
    ${contact_id}=    Create Test Contact
    &{contact}=    Salesforce Get    Contact    ${contact_id}
    Should Not Be Empty    ${contact}[Id]
```

### API-Only Test (No Browser)
```robot
*** Settings ***
Documentation    API test suite
Resource         ../resources/nzc-regresiontesting-cci.robot
# No Suite Setup/Teardown for API-only tests
Test Setup       Setup Test Case
Test Teardown    Teardown Test Case

*** Test Cases ***
API Test
    [Documentation]    API test
    [Tags]    api
    
    ${contact_id}=    Salesforce Insert    Contact
    ...    FirstName=Test
    ...    LastName=User
```

### UI Test (With Browser)
```robot
*** Settings ***
Documentation    UI test suite
Resource         ../resources/nzc-regresiontesting-cci.robot
Suite Setup      Setup Test Suite
Suite Teardown   Teardown Test Suite
Test Setup       Setup Test Case
Test Teardown    Teardown Test Case

*** Test Cases ***
UI Test
    [Documentation]    UI test
    [Tags]    ui
    
    Navigate To Object Home    Contact
    Click Object Button    New
    Fill Lightning Input    First Name    Test
    Click Modal Button    Save
```

## Test Tags Reference

| Tag | Purpose |
|-----|---------|
| `smoke` | Quick validation tests |
| `regression` | Full regression tests |
| `api` | API-based tests (no browser) |
| `ui` | UI-based browser tests |
| `critical` | Business-critical functionality |
| `destructive` | Tests that delete data |
| `contact` | Contact-related tests |
| `account` | Account-related tests |
| `opportunity` | Opportunity-related tests |

## Viewing Results

```bash
# Open HTML report
open robot/nzc-regresiontesting-cci/results/report.html

# Open detailed log
open robot/nzc-regresiontesting-cci/results/log.html

# View output XML (for CI/CD)
cat robot/nzc-regresiontesting-cci/results/output.xml
```

## Debugging Tests

### Run with Debug
```bash
cci task run robot --org NZCGus --debug
```

### Add Debug Output in Tests
```robot
# Log messages
Log    This is a debug message
Log To Console    This appears in console

# Log variables
Log    Contact ID: ${contact_id}
Log Many    ${first_name}    ${last_name}    ${email}

# Take screenshots
Capture Page Screenshot    debug_screenshot.png
```

### Robot Debugger
```bash
# Install debugger
pip install robotframework-debuglibrary

# Add to test
Library    DebugLibrary

# Use in test
Debug    # This will pause execution
```

## Common Locators

### Lightning Experience Locators
```robot
# Buttons
//button[@title='New']
//button[contains(., 'Save')]
//button[@name='SaveEdit']

# Inputs
//label[text()='First Name']/following::input[1]
//input[@name='FirstName']

# Lookups
//input[@placeholder='Search Accounts...']

# Picklists
//button[@aria-label='Stage']

# Links
//a[@title='Contact Name']

# Modal dialogs
//div[contains(@class, 'modal-container')]
```

## Tips & Best Practices

1. **Always use tags** - Makes filtering tests easy
2. **Use fake data** - Never hardcode test data
3. **Keep tests independent** - Each test should work standalone
4. **Clean up data** - Use `Delete Session Records` in teardown
5. **Use custom keywords** - Reuse common operations
6. **Add documentation** - Document what each test does
7. **Screenshot on failure** - Automatic via test teardown
8. **Meaningful test names** - Use descriptive names
9. **One assertion per test** - Or related assertions
10. **Wait for elements** - Always wait before interacting

## Troubleshooting

### ChromeDriver Issues
```bash
# Check Chrome version
google-chrome --version

# Check ChromeDriver version
chromedriver --version

# Update ChromeDriver
# Download from: https://chromedriver.chromium.org/
```

### Org Issues
```bash
# List orgs
cci org list

# Check org info
cci org info NZCGus

# Reconnect org
cci org connect NZCGus
```

### Test Failures
- Check `results/log.html` for detailed logs
- Look for screenshots in `results/` directory
- Run individual test for easier debugging
- Add `Log` statements for debugging
- Use `--debug` flag for more output

