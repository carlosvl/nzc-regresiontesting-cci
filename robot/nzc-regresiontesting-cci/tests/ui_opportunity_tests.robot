*** Settings ***
Documentation    UI tests for Opportunity object - browser-based user workflows
Resource         ../resources/nzc-regresiontesting-cci.robot
Suite Setup      Setup Test Suite
Suite Teardown   Teardown Test Suite
Test Setup       Setup Test Case
Test Teardown    Teardown Test Case With Browser

*** Test Cases ***
Create Opportunity Via UI
    [Documentation]    Create an opportunity through the Salesforce UI
    [Tags]    ui    regression    opportunity
    
    # Create an account first
    ${account_name}=    Get Fake Data    company
    ${account_id}=    Salesforce Insert    Account    Name=${account_name}
    
    ${opp_name}=    Get Fake Data    bs
    ${close_date}=    Get Current Date    result_format=%m/%d/%Y    increment=30 days
    
    Go To Page    Listing    Opportunity
    Click Object Button    New
    Wait For Modal    New    Opportunity
    
    Populate Field    Opportunity Name    ${opp_name}
    Populate Field    Amount    50000
    Populate Field    Close Date    ${close_date}
    Populate Lookup Field    Account Name    ${account_name}
    Pick List    Stage    Prospecting
    
    Click Modal Button    Save
    Wait Until Modal Is Closed
    
    # Verify we're on the opportunity detail page
    Current Page Should Be    Detail    Opportunity
    
    # Verify field values via API
    ${opp_id}=    Get Current Record Id
    &{opportunity}=    Salesforce Get    Opportunity    ${opp_id}
    Should Be Equal    ${opportunity}[Name]    ${opp_name}
    Should Be Equal    ${opportunity}[StageName]    Prospecting
    Should Be Equal As Numbers    ${opportunity}[Amount]    50000

Edit Opportunity Stage Via UI
    [Documentation]    Change opportunity stage through the UI
    [Tags]    ui    regression    opportunity
    
    # Create an opportunity via API
    ${opp_id}=    Create Test Opportunity
    
    # Navigate to the opportunity
    Go To Page    Detail    Opportunity    object_id=${opp_id}
    
    # Click Edit button
    Click Object Button    Edit
    Wait For Modal    Edit    Opportunity
    
    # Change the stage
    Pick List    Stage    Qualification
    
    # Update amount
    Populate Field    Amount    75000
    
    Click Modal Button    Save
    Wait Until Modal Is Closed
    
    # Verify changes were saved
    &{opportunity}=    Salesforce Get    Opportunity    ${opp_id}
    Should Be Equal    ${opportunity}[StageName]    Qualification
    Should Be Equal As Numbers    ${opportunity}[Amount]    75000

Close Opportunity As Won Via UI
    [Documentation]    Close an opportunity as won through the UI
    [Tags]    ui    regression    opportunity    critical
    
    # Create an opportunity
    ${opp_id}=    Create Test Opportunity
    
    # Navigate to the opportunity
    Go To Page    Detail    Opportunity    object_id=${opp_id}
    
    # Edit and close as won
    Click Object Button    Edit
    Wait For Modal    Edit    Opportunity
    
    Pick List    Stage    Closed Won
    
    Click Modal Button    Save
    Wait Until Modal Is Closed
    
    # Verify the opportunity is closed won
    &{opportunity}=    Salesforce Get    Opportunity    ${opp_id}
    Should Be Equal    ${opportunity}[StageName]    Closed Won
    Should Be Equal    ${opportunity}[IsWon]    ${True}

Close Opportunity As Lost Via UI
    [Documentation]    Close an opportunity as lost through the UI
    [Tags]    ui    regression    opportunity
    
    # Create an opportunity
    ${opp_id}=    Create Test Opportunity
    
    # Navigate to the opportunity
    Go To Page    Detail    Opportunity    object_id=${opp_id}
    
    # Edit and close as lost
    Click Object Button    Edit
    Wait For Modal    Edit    Opportunity
    
    Pick List    Stage    Closed Lost
    
    Click Modal Button    Save
    Wait Until Modal Is Closed
    
    # Verify the opportunity is closed lost
    &{opportunity}=    Salesforce Get    Opportunity    ${opp_id}
    Should Be Equal    ${opportunity}[StageName]    Closed Lost
    Should Be Equal    ${opportunity}[IsWon]    ${False}

View Opportunity Details Via UI
    [Documentation]    View opportunity details page
    [Tags]    ui    smoke    opportunity
    
    ${opp_name}=    Get Fake Data    bs
    ${account_id}=    Create Test Account
    ${close_date}=    Get Current Date    result_format=%Y-%m-%d    increment=30 days
    
    ${opp_id}=    Salesforce Insert    Opportunity
    ...    Name=${opp_name}
    ...    AccountId=${account_id}
    ...    StageName=Prospecting
    ...    CloseDate=${close_date}
    ...    Amount=100000
    
    Go To Page    Detail    Opportunity    object_id=${opp_id}
    
    # Verify we can see the opportunity name
    Wait Until Page Contains    ${opp_name}
    
    # Verify page title
    Current Page Should Be    Detail    Opportunity

Change Opportunity Amount Via UI
    [Documentation]    Update opportunity amount through the UI
    [Tags]    ui    regression    opportunity
    
    # Create an opportunity
    ${opp_id}=    Create Test Opportunity
    
    # Navigate to the opportunity
    Go To Page    Detail    Opportunity    object_id=${opp_id}
    
    # Edit the opportunity
    Click Object Button    Edit
    Wait For Modal    Edit    Opportunity
    
    # Change the amount
    Populate Field    Amount    125000
    
    Click Modal Button    Save
    Wait Until Modal Is Closed
    
    # Verify the amount was updated
    &{opportunity}=    Salesforce Get    Opportunity    ${opp_id}
    Should Be Equal As Numbers    ${opportunity}[Amount]    125000

Search For Opportunity Via UI
    [Documentation]    Search for an opportunity
    [Tags]    ui    regression    opportunity
    
    ${opp_name}=    Get Fake Data    bs
    ${account_id}=    Create Test Account
    ${close_date}=    Get Current Date    result_format=%Y-%m-%d    increment=30 days
    
    ${opp_id}=    Salesforce Insert    Opportunity
    ...    Name=${opp_name}
    ...    AccountId=${account_id}
    ...    StageName=Prospecting
    ...    CloseDate=${close_date}
    
    Go To Page    Listing    Opportunity
    
    # Search in the list view
    Populate Field    Search this list...    ${opp_name}
    Press Keys    None    RETURN
    
    # Wait for results
    Sleep    2s    Wait for search to complete
    Wait Until Page Contains    ${opp_name}

Delete Opportunity Via UI
    [Documentation]    Delete an opportunity through the UI
    [Tags]    ui    regression    opportunity    destructive
    
    # Create an opportunity
    ${opp_id}=    Create Test Opportunity
    
    # Navigate to the opportunity
    Go To Page    Detail    Opportunity    object_id=${opp_id}
    
    # Click Delete
    Click Object Button    Delete
    
    # Confirm deletion
    Wait For Modal    Delete    Opportunity
    Click Modal Button    Delete
    
    # Wait for deletion
    Sleep    2s
    
    # Verify opportunity is deleted
    ${status}    ${result}=    Run Keyword And Ignore Error
    ...    Salesforce Get    Opportunity    ${opp_id}
    Should Be Equal    ${status}    FAIL

