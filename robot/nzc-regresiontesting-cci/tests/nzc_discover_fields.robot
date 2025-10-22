*** Settings ***
Documentation    Discover Net Zero Cloud object fields
Resource         ../resources/nzc-regresiontesting-cci.robot
Test Setup       Setup Test Case
Test Teardown    Teardown Test Case

*** Test Cases ***
Describe StnryAssetEnvrSrc Fields
    [Documentation]    Query to discover actual fields on StnryAssetEnvrSrc
    [Tags]    api    netzero    discovery
    
    # Query an existing record to see available fields
    @{records}=    Soql Query    SELECT FIELDS(ALL) FROM StnryAssetEnvrSrc LIMIT 1
    
    Run Keyword If    ${records}    Log    Found record: ${records}[0]
    ...    ELSE    Log    No records found, trying to describe object differently
    
Describe StnryAssetEnrgyUse Fields
    [Documentation]    Query to discover actual fields on StnryAssetEnrgyUse
    [Tags]    api    netzero    discovery
    
    @{records}=    Soql Query    SELECT FIELDS(ALL) FROM StnryAssetEnrgyUse LIMIT 1
    
    Run Keyword If    ${records}    Log    Found record: ${records}[0]
    ...    ELSE    Log    No records found

Describe AnnualEmssnInventory Fields
    [Documentation]    Query to discover actual fields on AnnualEmssnInventory
    [Tags]    api    netzero    discovery
    
    @{records}=    Soql Query    SELECT FIELDS(ALL) FROM AnnualEmssnInventory LIMIT 1
    
    Run Keyword If    ${records}    Log    Found record: ${records}[0]
    ...    ELSE    Log    No records found

Describe StnryAssetCrbnFtprnt Fields
    [Documentation]    Query to discover actual fields on StnryAssetCrbnFtprnt
    [Tags]    api    netzero    discovery
    
    @{records}=    Soql Query    SELECT FIELDS(ALL) FROM StnryAssetCrbnFtprnt LIMIT 1
    
    Run Keyword If    ${records}    Log    Found record: ${records}[0]
    ...    ELSE    Log    No records found

Try Creating Minimal StnryAssetEnvrSrc
    [Documentation]    Try creating StnryAssetEnvrSrc with just Name field
    [Tags]    api    netzero    discovery
    
    ${name}=    Get Fake Data    company
    ${asset_id}=    Salesforce Insert    StnryAssetEnvrSrc
    ...    Name=${name}
    
    &{asset}=    Salesforce Get    StnryAssetEnvrSrc    ${asset_id}
    Log    Created StnryAssetEnvrSrc with ID: ${asset_id}
    
    # Log all fields to see what's available
    Log    Asset fields: ${asset}

