*** Settings ***
Documentation    Custom keywords and resources for NZC regression testing
Library          SeleniumLibrary
Library          DateTime
Library          cumulusci.robotframework.SalesforceAPI
Library          cumulusci.robotframework.CumulusCI
Library          cumulusci.robotframework.Salesforce
Library          cumulusci.robotframework.PageObjects

*** Variables ***
${BROWSER}       chrome

*** Keywords ***
Open Test Browser
    [Documentation]    Open browser and login to Salesforce using CumulusCI frontdoor
    ${org}=    Get Org Info
    ${login_url}=    Login Url
    Open Browser    ${login_url}    Chrome
    Maximize Browser Window
    Wait Until Page Contains Element    //div[contains(@class,'slds')]    timeout=30s

Setup Test Suite
    [Documentation]    Suite setup for browser-based tests
    Open Test Browser

Teardown Test Suite
    [Documentation]    Suite teardown - cleanup and close browser
    Delete Session Records
    Close All Browsers

Setup Test Suite API Only
    [Documentation]    Suite setup for API-only tests (no browser)
    Log    Starting API-only test suite

Teardown Test Suite API Only
    [Documentation]    Suite teardown for API-only tests
    Delete Session Records

Setup Test Case
    [Documentation]    Test case setup
    ${test_name}=    Get Test Name
    Log    Starting test: ${test_name}

Setup Test Case With Browser
    [Documentation]    Test case setup with browser
    ${test_name}=    Get Test Name
    Log    Starting test: ${test_name}
    ${browser_open}=    Run Keyword And Return Status    Get Location
    Run Keyword Unless    ${browser_open}    Open Test Browser

Teardown Test Case
    [Documentation]    Test case teardown (API-only, no screenshot)
    Delete Session Records

Teardown Test Case With Browser
    [Documentation]    Test case teardown with browser screenshot on failure
    Run Keyword If Test Failed    Capture Page Screenshot
    Delete Session Records

Create Test Contact
    [Documentation]    Create a test contact with fake data
    [Arguments]    ${first_name}=${None}    ${last_name}=${None}
    ${first_name}=    Run Keyword If    '${first_name}' == '${None}'
    ...    Get Fake Data    first_name
    ...    ELSE    Set Variable    ${first_name}
    ${last_name}=    Run Keyword If    '${last_name}' == '${None}'
    ...    Get Fake Data    last_name
    ...    ELSE    Set Variable    ${last_name}
    
    ${contact_id}=    Salesforce Insert    Contact
    ...    FirstName=${first_name}
    ...    LastName=${last_name}
    RETURN    ${contact_id}

Create Test Account
    [Documentation]    Create a test account with fake data
    [Arguments]    ${account_name}=${None}
    ${account_name}=    Run Keyword If    '${account_name}' == '${None}'
    ...    Get Fake Data    company
    ...    ELSE    Set Variable    ${account_name}
    
    ${account_id}=    Salesforce Insert    Account
    ...    Name=${account_name}
    RETURN    ${account_id}

Create Test Opportunity
    [Documentation]    Create a test opportunity with fake data
    [Arguments]    ${opportunity_name}=${None}    ${stage}=Prospecting    ${close_date}=${None}
    ${opportunity_name}=    Run Keyword If    '${opportunity_name}' == '${None}'
    ...    Get Fake Data    bs
    ...    ELSE    Set Variable    ${opportunity_name}
    ${close_date}=    Run Keyword If    '${close_date}' == '${None}'
    ...    Get Current Date    result_format=%Y-%m-%d    increment=30 days
    ...    ELSE    Set Variable    ${close_date}
    
    ${account_id}=    Create Test Account
    ${opportunity_id}=    Salesforce Insert    Opportunity
    ...    Name=${opportunity_name}
    ...    AccountId=${account_id}
    ...    StageName=${stage}
    ...    CloseDate=${close_date}
    RETURN    ${opportunity_id}

Navigate To Object Home
    [Documentation]    Navigate to an object's home page
    [Arguments]    ${object_name}
    Go To Page    Listing    ${object_name}
    Wait Until Loading Is Complete

Navigate To Record
    [Documentation]    Navigate to a specific record detail page
    [Arguments]    ${object_name}    ${record_id}
    Go To Page    Detail    ${object_name}    object_id=${record_id}
    Wait Until Loading Is Complete

Click Button With Text
    [Documentation]    Click a button containing specific text
    [Arguments]    ${button_text}
    ${element}=    Get WebElement    //button[contains(., '${button_text}')]
    Click Element    ${element}

Verify Field Value
    [Documentation]    Verify a field has the expected value on a record page
    [Arguments]    ${field_label}    ${expected_value}
    ${actual_value}=    Get Field Value    ${field_label}
    Should Be Equal As Strings    ${actual_value}    ${expected_value}

Fill Lightning Input
    [Documentation]    Fill a Lightning input field by label
    [Arguments]    ${label}    ${value}
    Wait Until Element Is Visible    //label[contains(., '${label}')]
    ${input}=    Get WebElement    //label[contains(., '${label}')]/following::input[1] | //label[contains(., '${label}')]/..//input
    Input Text    ${input}    ${value}

Get Test Name
    [Documentation]    Get the current test name
    ${test_name}=    Set Variable    ${TEST_NAME}
    RETURN    ${test_name}

