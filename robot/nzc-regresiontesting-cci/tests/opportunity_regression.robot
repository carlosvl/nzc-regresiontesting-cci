*** Settings ***
Documentation    Regression tests for Opportunity object functionality
Resource         ../resources/nzc-regresiontesting-cci.robot

*** Test Cases ***
Create Opportunity Via API
    [Documentation]    Verify opportunity can be created via API
    [Tags]    api    regression    opportunity
    [Setup]    Setup Test Case
    [Teardown]    Teardown Test Case
    
    ${account_id}=    Create Test Account
    ${opp_name}=    Get Fake Data    bs
    ${close_date}=    Get Current Date    result_format=%Y-%m-%d    increment=30 days
    
    ${opp_id}=    Salesforce Insert    Opportunity
    ...    Name=${opp_name}
    ...    AccountId=${account_id}
    ...    StageName=Prospecting
    ...    CloseDate=${close_date}
    ...    Amount=50000
    
    &{opportunity}=    Salesforce Get    Opportunity    ${opp_id}
    Should Be Equal    ${opportunity}[Name]    ${opp_name}
    Should Be Equal    ${opportunity}[StageName]    Prospecting
    Should Be Equal As Numbers    ${opportunity}[Amount]    50000

Create Opportunity Via UI
    [Documentation]    Verify opportunity can be created via UI
    [Tags]    ui    regression    opportunity
    [Setup]    Setup Test Case With Browser
    [Teardown]    Teardown Test Case With Browser
    
    ${account_name}=    Get Fake Data    company
    ${account_id}=    Salesforce Insert    Account    Name=${account_name}
    
    ${opp_name}=    Get Fake Data    bs
    ${close_date}=    Get Current Date    result_format=%m/%d/%Y    increment=30 days
    
    Navigate To Object Home    Opportunity
    Click Object Button    New
    Wait For Modal    New    Opportunity
    
    Fill Lightning Input    Opportunity Name    ${opp_name}
    Fill Lightning Input    Close Date    ${close_date}
    Populate Lookup Field    Account Name    ${account_name}
    Pick List    Stage    Prospecting
    Fill Lightning Input    Amount    50000
    
    Click Modal Button    Save
    Wait Until Modal Is Closed
    
    # Verify the opportunity was created
    ${opp_id}=    Get Current Record Id
    &{opportunity}=    Salesforce Get    Opportunity    ${opp_id}
    Should Be Equal    ${opportunity}[Name]    ${opp_name}
    Should Be Equal    ${opportunity}[StageName]    Prospecting

Update Opportunity Stage Via API
    [Documentation]    Verify opportunity stage can be updated via API
    [Tags]    api    regression    opportunity
    [Setup]    Setup Test Case
    [Teardown]    Teardown Test Case
    
    ${opp_id}=    Create Test Opportunity
    
    Salesforce Update    Opportunity    ${opp_id}
    ...    StageName=Qualification
    
    &{opportunity}=    Salesforce Get    Opportunity    ${opp_id}
    Should Be Equal    ${opportunity}[StageName]    Qualification

Close Opportunity As Won
    [Documentation]    Verify opportunity can be closed as won
    [Tags]    api    regression    opportunity    critical
    [Setup]    Setup Test Case
    [Teardown]    Teardown Test Case
    
    ${opp_id}=    Create Test Opportunity
    
    Salesforce Update    Opportunity    ${opp_id}
    ...    StageName=Closed Won
    
    &{opportunity}=    Salesforce Get    Opportunity    ${opp_id}
    Should Be Equal    ${opportunity}[StageName]    Closed Won
    Should Be Equal    ${opportunity}[IsWon]    ${True}

Close Opportunity As Lost
    [Documentation]    Verify opportunity can be closed as lost
    [Tags]    api    regression    opportunity
    [Setup]    Setup Test Case
    [Teardown]    Teardown Test Case
    
    ${opp_id}=    Create Test Opportunity
    
    Salesforce Update    Opportunity    ${opp_id}
    ...    StageName=Closed Lost
    
    &{opportunity}=    Salesforce Get    Opportunity    ${opp_id}
    Should Be Equal    ${opportunity}[StageName]    Closed Lost
    Should Be Equal    ${opportunity}[IsWon]    ${False}

