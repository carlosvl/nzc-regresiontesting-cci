*** Settings ***
Documentation    UI tests for Contact object - browser-based user workflows
Resource         ../resources/nzc-regresiontesting-cci.robot
Suite Setup      Setup Test Suite
Suite Teardown   Teardown Test Suite
Test Setup       Setup Test Case
Test Teardown    Teardown Test Case With Browser

*** Test Cases ***
Create Contact Via UI
    [Documentation]    Create a contact through the Salesforce UI
    [Tags]    ui    regression    contact
    
    ${first_name}=    Get Fake Data    first_name
    ${last_name}=    Get Fake Data    last_name
    ${email}=    Get Fake Data    email
    ${phone}=    Get Fake Data    phone_number
    
    Go To Page    Listing    Contact
    Click Object Button    New
    Wait For Modal    New    Contact
    
    Populate Field    First Name    ${first_name}
    Populate Field    Last Name    ${last_name}
    Populate Field    Email    ${email}
    Populate Field    Phone    ${phone}
    
    Click Modal Button    Save
    Wait Until Modal Is Closed
    
    # Verify we're on the contact detail page
    Current Page Should Be    Detail    Contact
    
    # Verify field values
    ${record_id}=    Get Current Record Id
    &{contact}=    Salesforce Get    Contact    ${record_id}
    Should Be Equal    ${contact}[FirstName]    ${first_name}
    Should Be Equal    ${contact}[LastName]    ${last_name}
    Should Be Equal    ${contact}[Email]    ${email}
    Should Be Equal    ${contact}[Phone]    ${phone}

Edit Contact Via UI
    [Documentation]    Edit an existing contact through the UI
    [Tags]    ui    regression    contact
    
    # Create a contact via API first
    ${contact_id}=    Create Test Contact
    
    # Navigate to the contact
    Go To Page    Detail    Contact    object_id=${contact_id}
    
    # Click Edit button
    Click Object Button    Edit
    Wait For Modal    Edit    Contact
    
    # Update fields
    ${new_email}=    Get Fake Data    email
    ${new_phone}=    Get Fake Data    phone_number
    
    Populate Field    Email    ${new_email}
    Populate Field    Phone    ${new_phone}
    
    Click Modal Button    Save
    Wait Until Modal Is Closed
    
    # Verify changes were saved
    &{contact}=    Salesforce Get    Contact    ${contact_id}
    Should Be Equal    ${contact}[Email]    ${new_email}
    Should Be Equal    ${contact}[Phone]    ${new_phone}

View Contact Details Via UI
    [Documentation]    View contact details page
    [Tags]    ui    smoke    contact
    
    ${first_name}=    Get Fake Data    first_name
    ${last_name}=    Get Fake Data    last_name
    ${contact_id}=    Salesforce Insert    Contact
    ...    FirstName=${first_name}
    ...    LastName=${last_name}
    
    Go To Page    Detail    Contact    object_id=${contact_id}
    
    # Verify we can see the contact name on the page
    Wait Until Page Contains    ${first_name} ${last_name}
    
    # Verify page title
    Current Page Should Be    Detail    Contact

Search For Contact Via UI
    [Documentation]    Search for a contact using the global search
    [Tags]    ui    regression    contact
    
    ${first_name}=    Get Fake Data    first_name
    ${last_name}=    Get Fake Data    last_name
    ${contact_id}=    Salesforce Insert    Contact
    ...    FirstName=${first_name}
    ...    LastName=${last_name}
    
    Go To Page    Home
    
    # Search for the contact
    ${search_term}=    Set Variable    ${first_name} ${last_name}
    Populate Field    Search    ${search_term}
    Press Keys    None    RETURN
    
    # Wait for search results
    Sleep    2s    Wait for search results to load
    Wait Until Page Contains    ${last_name}

Delete Contact Via UI
    [Documentation]    Delete a contact through the UI
    [Tags]    ui    regression    contact    destructive
    
    # Create a contact via API
    ${contact_id}=    Create Test Contact
    
    # Navigate to the contact
    Go To Page    Detail    Contact    object_id=${contact_id}
    
    # Click Delete from the menu
    Click Object Button    Delete
    
    # Confirm deletion in modal
    Wait For Modal    Delete    Contact
    Click Modal Button    Delete
    
    # Verify we're redirected away from the contact page
    Sleep    2s    Wait for deletion to complete
    
    # Verify contact is deleted via API
    ${status}    ${result}=    Run Keyword And Ignore Error
    ...    Salesforce Get    Contact    ${contact_id}
    Should Be Equal    ${status}    FAIL

Create Contact With Account Via UI
    [Documentation]    Create a contact and associate with an account
    [Tags]    ui    regression    contact    account
    
    # Create an account first
    ${account_name}=    Get Fake Data    company
    ${account_id}=    Salesforce Insert    Account    Name=${account_name}
    
    ${first_name}=    Get Fake Data    first_name
    ${last_name}=    Get Fake Data    last_name
    
    Go To Page    Listing    Contact
    Click Object Button    New
    Wait For Modal    New    Contact
    
    Populate Field    First Name    ${first_name}
    Populate Field    Last Name    ${last_name}
    Populate Lookup Field    Account Name    ${account_name}
    
    Click Modal Button    Save
    Wait Until Modal Is Closed
    
    # Verify the contact was created with the account
    ${contact_id}=    Get Current Record Id
    &{contact}=    Salesforce Get    Contact    ${contact_id}
    Should Be Equal    ${contact}[FirstName]    ${first_name}
    Should Be Equal    ${contact}[LastName]    ${last_name}
    Should Be Equal    ${contact}[AccountId]    ${account_id}

