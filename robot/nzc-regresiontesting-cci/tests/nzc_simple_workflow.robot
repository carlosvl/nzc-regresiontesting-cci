*** Settings ***
Documentation    Simplified Net Zero Cloud workflow - discovering actual field names
Resource         ../resources/nzc-regresiontesting-cci.robot
Test Setup       Setup Test Case
Test Teardown    Teardown Test Case

*** Test Cases ***
Create Simple NZC Workflow
    [Documentation]    Create NZC records with minimal fields to test workflow
    [Tags]    api    netzero    poc
    
    # Step 1: Create Account
    Log    === Step 1: Creating Account ===
    ${account_name}=    Get Fake Data    company
    ${account_id}=    Salesforce Insert    Account
    ...    Name=${account_name}
    Log    ✓ Created Account: ${account_id}
    
    # Step 2: Create Stationary Asset Environmental Source
    Log    === Step 2: Creating StnryAssetEnvrSrc ===
    ${asset_name}=    Set Variable    ${account_name} - Main Building
    ${asset_id}=    Salesforce Insert    StnryAssetEnvrSrc
    ...    Name=${asset_name}
    Log    ✓ Created StnryAssetEnvrSrc: ${asset_id}
    
    # Query it back to see available fields
    &{asset}=    Salesforce Get    StnryAssetEnvrSrc    ${asset_id}
    Log    Asset record fields: ${asset}
    
    # Step 3: Create Stationary Asset Energy Use
    Log    === Step 3: Creating StnryAssetEnrgyUse ===
    ${energy_name}=    Set Variable    Electricity - Jan 2024
    ${start_date}=    Get Current Date    result_format=%Y-%m-%d
    
    # FuelType is required - common values: Electricity, Natural Gas, etc.
    ${energy_id}=    Salesforce Insert    StnryAssetEnrgyUse
    ...    Name=${energy_name}
    ...    StnryAssetEnvrSrcId=${asset_id}
    ...    StartDate=${start_date}
    ...    FuelType=Electricity
    Log    ✓ Created StnryAssetEnrgyUse: ${energy_id}
    
    # Query it back
    &{energy}=    Salesforce Get    StnryAssetEnrgyUse    ${energy_id}
    Log    Energy Use record fields: ${energy}
    
    # Step 4: Create Annual Emission Inventory
    Log    === Step 4: Creating AnnualEmssnInventory ===
    ${inventory_name}=    Set Variable    ${account_name} - 2024
    ${year}=    Get Current Date    result_format=%Y
    
    # Field is called "Year" not "ReportingYear"
    ${inventory_id}=    Salesforce Insert    AnnualEmssnInventory
    ...    Name=${inventory_name}
    ...    Year=${year}
    Log    ✓ Created AnnualEmssnInventory: ${inventory_id}
    
    # Query it back to see available fields
    &{inventory}=    Salesforce Get    AnnualEmssnInventory    ${inventory_id}
    Log    Inventory record fields: ${inventory}
    
    # Step 5: Wait and check for auto-generated Carbon Footprint
    Log    === Step 5: Checking for auto-generated StnryAssetCrbnFtprnt ===
    Sleep    5s    Wait for automation
    
    # Query for carbon footprints related to our asset
    @{footprints}=    Soql Query
    ...    SELECT Id, Name FROM StnryAssetCrbnFtprnt 
    ...    WHERE StnryAssetEnvrSrcId = '${asset_id}'
    ...    LIMIT 10
    
    ${count}=    Get Length    ${footprints}
    Log    Found ${count} carbon footprint records
    
    Run Keyword If    ${count} > 0    Log    ✓ Carbon Footprint auto-generated: ${footprints}[0]
    ...    ELSE    Log    Note: No carbon footprint auto-generated yet (may require additional setup)
    
    # Log success
    Log    ========================================
    Log    ✓ NZC Workflow Test Complete
    Log    ✓ Account: ${account_id}
    Log    ✓ StnryAssetEnvrSrc: ${asset_id}
    Log    ✓ StnryAssetEnrgyUse: ${energy_id}
    Log    ✓ AnnualEmssnInventory: ${inventory_id}
    Log    ✓ Carbon Footprints Found: ${count}
    Log    ========================================

Query All NZC Records
    [Documentation]    Query counts of all NZC object types
    [Tags]    api    netzero    discovery
    
    @{assets}=    Soql Query    SELECT COUNT() FROM StnryAssetEnvrSrc
    @{energy}=    Soql Query    SELECT COUNT() FROM StnryAssetEnrgyUse
    @{inventory}=    Soql Query    SELECT COUNT() FROM AnnualEmssnInventory
    @{footprints}=    Soql Query    SELECT COUNT() FROM StnryAssetCrbnFtprnt
    
    Log    StnryAssetEnvrSrc records: ${assets}[0][expr0]
    Log    StnryAssetEnrgyUse records: ${energy}[0][expr0]
    Log    AnnualEmssnInventory records: ${inventory}[0][expr0]
    Log    StnryAssetCrbnFtprnt records: ${footprints}[0][expr0]

