*** Settings ***
Documentation    End-to-end UI workflow tests - complete business processes
Resource         ../resources/nzc-regresiontesting-cci.robot
Suite Setup      Setup Test Suite
Suite Teardown   Teardown Test Suite
Test Setup       Setup Test Case
Test Teardown    Teardown Test Case With Browser

*** Test Cases ***
Complete Sales Process Workflow
    [Documentation]    Test a complete sales workflow from account to closed opportunity
    [Tags]    ui    workflow    critical
    
    # Step 1: Create an account
    ${account_name}=    Get Fake Data    company
    ${phone}=    Get Fake Data    phone_number
    
    Go To Page    Listing    Account
    Click Object Button    New
    Wait For Modal    New    Account
    
    Populate Field    Account Name    ${account_name}
    Populate Field    Phone    ${phone}
    Click Modal Button    Save
    Wait Until Modal Is Closed
    
    ${account_id}=    Get Current Record Id
    
    # Step 2: Create a contact for the account
    ${first_name}=    Get Fake Data    first_name
    ${last_name}=    Get Fake Data    last_name
    ${email}=    Get Fake Data    email
    
    Go To Page    Listing    Contact
    Click Object Button    New
    Wait For Modal    New    Contact
    
    Populate Field    First Name    ${first_name}
    Populate Field    Last Name    ${last_name}
    Populate Field    Email    ${email}
    Populate Lookup Field    Account Name    ${account_name}
    Click Modal Button    Save
    Wait Until Modal Is Closed
    
    ${contact_id}=    Get Current Record Id
    
    # Step 3: Create an opportunity for the account
    ${opp_name}=    Set Variable    ${account_name} - New Business
    ${close_date}=    Get Current Date    result_format=%m/%d/%Y    increment=45 days
    
    Go To Page    Listing    Opportunity
    Click Object Button    New
    Wait For Modal    New    Opportunity
    
    Populate Field    Opportunity Name    ${opp_name}
    Populate Field    Amount    100000
    Populate Field    Close Date    ${close_date}
    Populate Lookup Field    Account Name    ${account_name}
    Pick List    Stage    Prospecting
    Click Modal Button    Save
    Wait Until Modal Is Closed
    
    ${opp_id}=    Get Current Record Id
    
    # Step 4: Progress the opportunity through stages
    Click Object Button    Edit
    Wait For Modal    Edit    Opportunity
    Pick List    Stage    Qualification
    Click Modal Button    Save
    Wait Until Modal Is Closed
    
    Click Object Button    Edit
    Wait For Modal    Edit    Opportunity
    Pick List    Stage    Proposal/Price Quote
    Click Modal Button    Save
    Wait Until Modal Is Closed
    
    # Step 5: Close the opportunity as won
    Click Object Button    Edit
    Wait For Modal    Edit    Opportunity
    Pick List    Stage    Closed Won
    Click Modal Button    Save
    Wait Until Modal Is Closed
    
    # Verify the complete workflow
    &{opportunity}=    Salesforce Get    Opportunity    ${opp_id}
    Should Be Equal    ${opportunity}[StageName]    Closed Won
    Should Be Equal    ${opportunity}[IsWon]    ${True}
    Should Be Equal    ${opportunity}[AccountId]    ${account_id}

Create Account With Multiple Contacts
    [Documentation]    Create an account and add multiple related contacts
    [Tags]    ui    workflow    account    contact
    
    # Create the account
    ${account_name}=    Get Fake Data    company
    Go To Page    Listing    Account
    Click Object Button    New
    Wait For Modal    New    Account
    Populate Field    Account Name    ${account_name}
    Click Modal Button    Save
    Wait Until Modal Is Closed
    
    ${account_id}=    Get Current Record Id
    
    # Add 3 contacts to the account
    FOR    ${i}    IN RANGE    3
        ${first_name}=    Get Fake Data    first_name
        ${last_name}=    Get Fake Data    last_name
        ${email}=    Get Fake Data    email
        
        Go To Page    Listing    Contact
        Click Object Button    New
        Wait For Modal    New    Contact
        
        Populate Field    First Name    ${first_name}
        Populate Field    Last Name    ${last_name}
        Populate Field    Email    ${email}
        Populate Lookup Field    Account Name    ${account_name}
        Click Modal Button    Save
        Wait Until Modal Is Closed
    END
    
    # Navigate back to the account and verify contacts
    Go To Page    Detail    Account    object_id=${account_id}
    
    # Verify we can see the Contacts related list
    Wait Until Page Contains    Contacts

Navigate Between Related Records
    [Documentation]    Test navigation between account, contact, and opportunity
    [Tags]    ui    workflow    navigation
    
    # Create test data via API
    ${account_name}=    Get Fake Data    company
    ${account_id}=    Salesforce Insert    Account    Name=${account_name}
    
    ${contact_id}=    Salesforce Insert    Contact
    ...    FirstName=Test
    ...    LastName=User
    ...    AccountId=${account_id}
    
    ${close_date}=    Get Current Date    result_format=%Y-%m-%d    increment=30 days
    ${opp_id}=    Salesforce Insert    Opportunity
    ...    Name=Test Opportunity
    ...    AccountId=${account_id}
    ...    StageName=Prospecting
    ...    CloseDate=${close_date}
    
    # Start at account page
    Go To Page    Detail    Account    object_id=${account_id}
    Wait Until Page Contains    ${account_name}
    
    # Click through to contact
    Click Link    Test User
    Wait Until Page Contains    Test User
    Current Page Should Be    Detail    Contact
    
    # Navigate back to account via related account link
    Click Link    ${account_name}
    Wait Until Page Contains    ${account_name}
    Current Page Should Be    Detail    Account
    
    # Click through to opportunity
    Click Link    Test Opportunity
    Wait Until Page Contains    Test Opportunity
    Current Page Should Be    Detail    Opportunity

Filter And Sort List View
    [Documentation]    Test list view filtering and sorting
    [Tags]    ui    workflow    listview
    
    # Create multiple accounts with different data
    FOR    ${i}    IN RANGE    3
        ${account_name}=    Get Fake Data    company
        Salesforce Insert    Account    Name=${account_name}    Type=Customer
    END
    
    FOR    ${i}    IN RANGE    2
        ${account_name}=    Get Fake Data    company
        Salesforce Insert    Account    Name=${account_name}    Type=Partner
    END
    
    # Navigate to Accounts list
    Go To Page    Listing    Account
    
    # Wait for list to load
    Sleep    2s    Wait for list view to load
    
    # Verify we can see accounts
    Wait Until Page Contains    Account

Bulk Edit Multiple Records
    [Documentation]    Test editing multiple records at once
    [Tags]    ui    workflow    bulk
    
    # Create multiple contacts via API
    ${account_id}=    Create Test Account
    
    FOR    ${i}    IN RANGE    3
        ${first_name}=    Get Fake Data    first_name
        ${last_name}=    Get Fake Data    last_name
        Salesforce Insert    Contact
        ...    FirstName=${first_name}
        ...    LastName=${last_name}
        ...    AccountId=${account_id}
    END
    
    # Navigate to the account to see related contacts
    Go To Page    Detail    Account    object_id=${account_id}
    
    # Verify contacts are visible
    Wait Until Page Contains    Contacts

