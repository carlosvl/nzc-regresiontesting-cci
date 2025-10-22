*** Settings ***
Documentation    Smoke tests - quick validation of critical functionality
Resource         ../resources/nzc-regresiontesting-cci.robot
Test Setup       Setup Test Case
Test Teardown    Teardown Test Case

*** Test Cases ***
Org Connection Test
    [Documentation]    Verify we can connect to the org and query basic data
    [Tags]    smoke    critical
    
    # Simple SOQL query to verify org connectivity
    @{results}=    Soql Query    SELECT Id, Name, Email FROM User WHERE IsActive = true LIMIT 1
    
    Should Not Be Empty    ${results}
    Log    Successfully connected to org and queried User object

Create And Retrieve Contact
    [Documentation]    Basic smoke test for Contact creation
    [Tags]    smoke    critical    contact
    
    ${first_name}=    Get Fake Data    first_name
    ${last_name}=    Get Fake Data    last_name
    ${email}=    Get Fake Data    email
    
    ${contact_id}=    Salesforce Insert    Contact
    ...    FirstName=${first_name}
    ...    LastName=${last_name}
    ...    Email=${email}
    
    &{contact}=    Salesforce Get    Contact    ${contact_id}
    Should Be Equal    ${contact}[FirstName]    ${first_name}
    Should Be Equal    ${contact}[LastName]    ${last_name}
    Should Be Equal    ${contact}[Email]    ${email}

Create And Retrieve Account
    [Documentation]    Basic smoke test for Account creation
    [Tags]    smoke    critical    account
    
    ${account_name}=    Get Fake Data    company
    
    ${account_id}=    Salesforce Insert    Account
    ...    Name=${account_name}
    
    &{account}=    Salesforce Get    Account    ${account_id}
    Should Be Equal    ${account}[Name]    ${account_name}

Create And Retrieve Opportunity
    [Documentation]    Basic smoke test for Opportunity creation
    [Tags]    smoke    critical    opportunity
    
    ${account_id}=    Create Test Account
    ${opp_name}=    Get Fake Data    bs
    ${close_date}=    Get Current Date    result_format=%Y-%m-%d    increment=30 days
    
    ${opp_id}=    Salesforce Insert    Opportunity
    ...    Name=${opp_name}
    ...    AccountId=${account_id}
    ...    StageName=Prospecting
    ...    CloseDate=${close_date}
    
    &{opportunity}=    Salesforce Get    Opportunity    ${opp_id}
    Should Be Equal    ${opportunity}[Name]    ${opp_name}
    Should Be Equal    ${opportunity}[StageName]    Prospecting

