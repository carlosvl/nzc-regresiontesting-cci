*** Settings ***
Documentation    Example test for creating a Contact via API and UI
Resource         ../resources/nzc-regresiontesting-cci.robot

*** Test Cases ***
Via API
    [Documentation]    Create a contact via the Salesforce API
    [Tags]    api    smoke    contact
    [Setup]    Setup Test Case
    [Teardown]    Teardown Test Case
    
    ${first_name}=    Get Fake Data    first_name
    ${last_name}=    Get Fake Data    last_name
    
    ${contact_id}=    Salesforce Insert    Contact
    ...    FirstName=${first_name}
    ...    LastName=${last_name}
    
    &{contact}=    Salesforce Get    Contact    ${contact_id}
    Should Be Equal    ${contact}[FirstName]    ${first_name}
    Should Be Equal    ${contact}[LastName]    ${last_name}

Via UI
    [Documentation]    Create a contact via the Salesforce UI
    [Tags]    ui    smoke    contact
    [Setup]    Setup Test Case With Browser
    [Teardown]    Teardown Test Case With Browser
    
    ${first_name}=    Get Fake Data    first_name
    ${last_name}=    Get Fake Data    last_name
    
    Navigate To Object Home    Contact
    Click Object Button    New
    Wait For Modal    New    Contact
    
    Fill Lightning Input    First Name    ${first_name}
    Fill Lightning Input    Last Name    ${last_name}
    
    Click Modal Button    Save
    Wait Until Modal Is Closed
    
    # Verify the contact was created
    ${contact_id}=    Get Current Record Id
    &{contact}=    Salesforce Get    Contact    ${contact_id}
    Should Be Equal    ${contact}[FirstName]    ${first_name}
    Should Be Equal    ${contact}[LastName]    ${last_name}

