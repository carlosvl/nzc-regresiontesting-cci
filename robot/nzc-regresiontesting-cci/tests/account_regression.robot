*** Settings ***
Documentation    Regression tests for Account object functionality
Resource         ../resources/nzc-regresiontesting-cci.robot

*** Test Cases ***
Create Account Via API
    [Documentation]    Verify account can be created via API
    [Tags]    api    regression    account
    [Setup]    Setup Test Case
    [Teardown]    Teardown Test Case
    
    ${account_name}=    Get Fake Data    company
    ${phone}=    Get Fake Data    phone_number
    
    ${account_id}=    Salesforce Insert    Account
    ...    Name=${account_name}
    ...    Phone=${phone}
    
    &{account}=    Salesforce Get    Account    ${account_id}
    Should Be Equal    ${account}[Name]    ${account_name}
    Should Be Equal    ${account}[Phone]    ${phone}

Create Account Via UI
    [Documentation]    Verify account can be created via UI
    [Tags]    ui    regression    account
    [Setup]    Setup Test Case With Browser
    [Teardown]    Teardown Test Case With Browser
    
    ${account_name}=    Get Fake Data    company
    ${phone}=    Get Fake Data    phone_number
    ${website}=    Get Fake Data    url
    
    Navigate To Object Home    Account
    Click Object Button    New
    Wait For Modal    New    Account
    
    Fill Lightning Input    Account Name    ${account_name}
    Fill Lightning Input    Phone    ${phone}
    Fill Lightning Input    Website    ${website}
    
    Click Modal Button    Save
    Wait Until Modal Is Closed
    
    # Verify the account was created
    ${account_id}=    Get Current Record Id
    &{account}=    Salesforce Get    Account    ${account_id}
    Should Be Equal    ${account}[Name]    ${account_name}
    Should Be Equal    ${account}[Phone]    ${phone}

Update Account Via API
    [Documentation]    Verify account can be updated via API
    [Tags]    api    regression    account
    [Setup]    Setup Test Case
    [Teardown]    Teardown Test Case
    
    ${account_id}=    Create Test Account
    ${new_phone}=    Get Fake Data    phone_number
    
    Salesforce Update    Account    ${account_id}
    ...    Phone=${new_phone}
    
    &{account}=    Salesforce Get    Account    ${account_id}
    Should Be Equal    ${account}[Phone]    ${new_phone}

Delete Account Via API
    [Documentation]    Verify account can be deleted via API
    [Tags]    api    regression    account    destructive
    [Setup]    Setup Test Case
    [Teardown]    Teardown Test Case
    
    ${account_id}=    Create Test Account
    
    Salesforce Delete    Account    ${account_id}
    
    # Verify account no longer exists
    ${status}    ${result}=    Run Keyword And Ignore Error
    ...    Salesforce Get    Account    ${account_id}
    Should Be Equal    ${status}    FAIL

Search For Account
    [Documentation]    Verify account search functionality
    [Tags]    ui    regression    account    search
    [Setup]    Setup Test Case With Browser
    [Teardown]    Teardown Test Case With Browser
    
    ${account_name}=    Get Fake Data    company
    ${account_id}=    Salesforce Insert    Account
    ...    Name=${account_name}
    
    Navigate To Object Home    Account
    Search For    ${account_name}
    
    # Verify account appears in search results
    Wait Until Element Is Visible    //a[@title='${account_name}']

