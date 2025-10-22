*** Settings ***
Documentation    UI tests for Account object - browser-based user workflows
Resource         ../resources/nzc-regresiontesting-cci.robot
Suite Setup      Setup Test Suite
Suite Teardown   Teardown Test Suite
Test Setup       Setup Test Case
Test Teardown    Teardown Test Case With Browser

*** Test Cases ***
Create Account Via UI
    [Documentation]    Create an account through the Salesforce UI
    [Tags]    ui    regression    account
    
    ${account_name}=    Get Fake Data    company
    ${phone}=    Get Fake Data    phone_number
    ${website}=    Get Fake Data    url
    ${street}=    Get Fake Data    street_address
    ${city}=    Get Fake Data    city
    ${state}=    Get Fake Data    state_abbr
    ${zipcode}=    Get Fake Data    zipcode
    
    Go To Page    Listing    Account
    Click Object Button    New
    Wait For Modal    New    Account
    
    Populate Field    Account Name    ${account_name}
    Populate Field    Phone    ${phone}
    Populate Field    Website    ${website}
    Populate Field    Billing Street    ${street}
    Populate Field    Billing City    ${city}
    Populate Field    Billing State/Province    ${state}
    Populate Field    Billing Zip/Postal Code    ${zipcode}
    
    Click Modal Button    Save
    Wait Until Modal Is Closed
    
    # Verify we're on the account detail page
    Current Page Should Be    Detail    Account
    
    # Verify field values via API
    ${account_id}=    Get Current Record Id
    &{account}=    Salesforce Get    Account    ${account_id}
    Should Be Equal    ${account}[Name]    ${account_name}
    Should Be Equal    ${account}[Phone]    ${phone}
    Should Be Equal    ${account}[Website]    ${website}

Edit Account Via UI
    [Documentation]    Edit an existing account through the UI
    [Tags]    ui    regression    account
    
    # Create an account via API first
    ${account_id}=    Create Test Account
    
    # Navigate to the account
    Go To Page    Detail    Account    object_id=${account_id}
    
    # Click Edit button
    Click Object Button    Edit
    Wait For Modal    Edit    Account
    
    # Update fields
    ${new_phone}=    Get Fake Data    phone_number
    ${new_website}=    Get Fake Data    url
    
    Populate Field    Phone    ${new_phone}
    Populate Field    Website    ${new_website}
    
    Click Modal Button    Save
    Wait Until Modal Is Closed
    
    # Verify changes were saved
    &{account}=    Salesforce Get    Account    ${account_id}
    Should Be Equal    ${account}[Phone]    ${new_phone}
    Should Be Equal    ${account}[Website]    ${new_website}

View Account Details Via UI
    [Documentation]    View account details page
    [Tags]    ui    smoke    account
    
    ${account_name}=    Get Fake Data    company
    ${account_id}=    Salesforce Insert    Account    Name=${account_name}
    
    Go To Page    Detail    Account    object_id=${account_id}
    
    # Verify we can see the account name on the page
    Wait Until Page Contains    ${account_name}
    
    # Verify page title
    Current Page Should Be    Detail    Account

Search For Account Via UI
    [Documentation]    Search for an account using the global search
    [Tags]    ui    regression    account
    
    ${account_name}=    Get Fake Data    company
    ${account_id}=    Salesforce Insert    Account    Name=${account_name}
    
    Go To Page    Listing    Account
    
    # Use the list view search
    Populate Field    Search this list...    ${account_name}
    Press Keys    None    RETURN
    
    # Wait for results
    Sleep    2s    Wait for search to complete
    Wait Until Page Contains    ${account_name}

Change Account Type Via UI
    [Documentation]    Change the account type through the UI
    [Tags]    ui    regression    account
    
    # Create an account
    ${account_id}=    Create Test Account
    
    # Navigate to the account
    Go To Page    Detail    Account    object_id=${account_id}
    
    # Edit the account
    Click Object Button    Edit
    Wait For Modal    Edit    Account
    
    # Change the type
    Pick List    Type    Customer
    
    Click Modal Button    Save
    Wait Until Modal Is Closed
    
    # Verify the type was changed
    &{account}=    Salesforce Get    Account    ${account_id}
    Should Be Equal    ${account}[Type]    Customer

View Account Related Lists Via UI
    [Documentation]    View and interact with related lists on account page
    [Tags]    ui    regression    account
    
    # Create an account with contacts
    ${account_id}=    Create Test Account
    ${contact_id}=    Salesforce Insert    Contact
    ...    FirstName=Test
    ...    LastName=Contact
    ...    AccountId=${account_id}
    
    # Navigate to the account
    Go To Page    Detail    Account    object_id=${account_id}
    
    # Verify the Contacts related list shows the contact
    Wait Until Page Contains    Contacts
    Wait Until Page Contains    Test Contact

Delete Account Via UI
    [Documentation]    Delete an account through the UI
    [Tags]    ui    regression    account    destructive
    
    # Create an account via API
    ${account_id}=    Create Test Account
    
    # Navigate to the account
    Go To Page    Detail    Account    object_id=${account_id}
    
    # Click Delete from the menu
    Click Object Button    Delete
    
    # Confirm deletion in modal
    Wait For Modal    Delete    Account
    Click Modal Button    Delete
    
    # Wait for deletion to complete
    Sleep    2s
    
    # Verify account is deleted via API
    ${status}    ${result}=    Run Keyword And Ignore Error
    ...    Salesforce Get    Account    ${account_id}
    Should Be Equal    ${status}    FAIL

