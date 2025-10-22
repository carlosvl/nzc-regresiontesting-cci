*** Settings ***
Documentation    Query existing NZC records to understand relationships
Resource         ../resources/nzc-regresiontesting-cci.robot
Test Setup       Setup Test Case
Test Teardown    Teardown Test Case

*** Test Cases ***
Query Existing Carbon Footprints
    [Documentation]    Query existing StnryAssetCrbnFtprnt records to see relationships
    [Tags]    api    netzero    discovery
    
    @{footprints}=    Soql Query
    ...    SELECT Id, Name, StnryAssetEnvrSrcId, StnryAssetEnrgyUseId, 
    ...           CreatedDate, LastModifiedDate
    ...    FROM StnryAssetCrbnFtprnt 
    ...    ORDER BY CreatedDate DESC
    ...    LIMIT 5
    
    ${count}=    Get Length    ${footprints}
    Log    Found ${count} carbon footprint records
    
    Run Keyword If    ${count} > 0    Log    Sample footprint: ${footprints}[0]

Query Existing Energy Uses
    [Documentation]    Query existing StnryAssetEnrgyUse records to see fields
    [Tags]    api    netzero    discovery
    
    @{energy_uses}=    Soql Query
    ...    SELECT Id, Name, StnryAssetEnvrSrcId, StartDate, EndDate,
    ...           EnergyConsumption, EnergyUseIntvlReadingCode
    ...    FROM StnryAssetEnrgyUse
    ...    ORDER BY CreatedDate DESC
    ...    LIMIT 5
    
    ${count}=    Get Length    ${energy_uses}
    Log    Found ${count} energy use records
    
    Run Keyword If    ${count} > 0    Log    Sample energy use: ${energy_uses}[0]

Query Existing Asset Environmental Sources
    [Documentation]    Query existing StnryAssetEnvrSrc records
    [Tags]    api    netzero    discovery
    
    @{assets}=    Soql Query
    ...    SELECT Id, Name, CreatedDate
    ...    FROM StnryAssetEnvrSrc
    ...    ORDER BY CreatedDate DESC
    ...    LIMIT 5
    
    ${count}=    Get Length    ${assets}
    Log    Found ${count} asset environmental source records
    
    Run Keyword If    ${count} > 0    Log    Sample asset: ${assets}[0]

Query Account Relationships
    [Documentation]    Query Account and related NZC records
    [Tags]    api    netzero    discovery
    
    # Find accounts with related NZC records
    @{accounts}=    Soql Query
    ...    SELECT Id, Name,
    ...           (SELECT Id, Name FROM AnnualEmssnInventories__r LIMIT 1)
    ...    FROM Account
    ...    WHERE Id IN (SELECT AccountId FROM AnnualEmssnInventory)
    ...    LIMIT 3
    
    ${count}=    Get Length    ${accounts}
    Log    Found ${count} accounts with emission inventories
    
    Run Keyword If    ${count} > 0    Log    Sample account with relationships: ${accounts}[0]

