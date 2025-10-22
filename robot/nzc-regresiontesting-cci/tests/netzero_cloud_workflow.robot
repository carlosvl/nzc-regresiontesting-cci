*** Settings ***
Documentation    Net Zero Cloud workflow tests - API-based testing of NZC data model
Resource         ../resources/nzc-regresiontesting-cci.robot
Test Setup       Setup Test Case
Test Teardown    Teardown Test Case

*** Test Cases ***
Create Complete Asset Energy Flow With Auto-Generated Carbon Footprint
    [Documentation]    Test the complete NZC workflow: Account → Asset Env Source → Asset Energy Use → Annual Inventory
    ...                Verify that StnryAssetCrbnFtprnt (Stationary Asset Carbon Footprint) is auto-generated
    [Tags]    api    netzero    workflow    critical
    
    # Step 1: Create Account
    Log    Step 1: Creating Account
    ${account_name}=    Get Fake Data    company
    ${account_id}=    Salesforce Insert    Account
    ...    Name=${account_name}
    Log    Created Account: ${account_id}
    
    # Step 2: Create Stationary Asset Environmental Source (related to Account)
    Log    Step 2: Creating Stationary Asset Environmental Source
    ${asset_env_src_name}=    Set Variable    ${account_name} - Building A
    ${asset_env_src_id}=    Salesforce Insert    StnryAssetEnvrSrc
    ...    Name=${asset_env_src_name}
    ...    AccountId=${account_id}
    Log    Created StnryAssetEnvrSrc: ${asset_env_src_id}
    
    # Verify the relationship
    &{asset_env_src}=    Salesforce Get    StnryAssetEnvrSrc    ${asset_env_src_id}
    Should Be Equal    ${asset_env_src}[AccountId]    ${account_id}
    Log    ✓ StnryAssetEnvrSrc correctly linked to Account
    
    # Step 3: Create Stationary Asset Energy Use (related to Asset Env Source)
    Log    Step 3: Creating Stationary Asset Energy Use
    ${energy_use_name}=    Set Variable    Electricity Usage - Jan 2024
    ${start_date}=    Get Current Date    result_format=%Y-%m-%d
    ${end_date}=    Get Current Date    result_format=%Y-%m-%d    increment=30 days
    
    ${asset_energy_use_id}=    Salesforce Insert    StnryAssetEnrgyUse
    ...    Name=${energy_use_name}
    ...    StnryAssetEnvrSrcId=${asset_env_src_id}
    ...    StartDate=${start_date}
    ...    EndDate=${end_date}
    ...    EnergyConsumption=1000
    ...    EnergyUseIntvlReadingCode=Monthly
    Log    Created StnryAssetEnrgyUse: ${asset_energy_use_id}
    
    # Verify the relationship
    &{asset_energy_use}=    Salesforce Get    StnryAssetEnrgyUse    ${asset_energy_use_id}
    Should Be Equal    ${asset_energy_use}[StnryAssetEnvrSrcId]    ${asset_env_src_id}
    Should Be Equal As Numbers    ${asset_energy_use}[EnergyConsumption]    1000
    Log    ✓ StnryAssetEnrgyUse correctly linked to StnryAssetEnvrSrc
    
    # Step 4: Create Annual Emission Inventory
    Log    Step 4: Creating Annual Emission Inventory
    ${inventory_name}=    Set Variable    ${account_name} - 2024 Emissions
    ${reporting_year}=    Get Current Date    result_format=%Y
    
    ${annual_inventory_id}=    Salesforce Insert    AnnualEmssnInventory
    ...    Name=${inventory_name}
    ...    AccountId=${account_id}
    ...    ReportingYear=${reporting_year}
    Log    Created AnnualEmssnInventory: ${annual_inventory_id}
    
    # Verify the relationship
    &{annual_inventory}=    Salesforce Get    AnnualEmssnInventory    ${annual_inventory_id}
    Should Be Equal    ${annual_inventory}[AccountId]    ${account_id}
    Should Be Equal    ${annual_inventory}[ReportingYear]    ${reporting_year}
    Log    ✓ AnnualEmssnInventory correctly linked to Account
    
    # Step 5: Wait for auto-generation and verify StnryAssetCrbnFtprnt was created
    Log    Step 5: Verifying auto-generated Stationary Asset Carbon Footprint
    Sleep    5s    Wait for automation/trigger to create carbon footprint
    
    # Query for the auto-generated StnryAssetCrbnFtprnt record
    @{carbon_footprints}=    Soql Query    
    ...    SELECT Id, Name, StnryAssetEnvrSrcId, StnryAssetEnrgyUseId 
    ...    FROM StnryAssetCrbnFtprnt 
    ...    WHERE StnryAssetEnrgyUseId = '${asset_energy_use_id}'
    
    # Verify carbon footprint was created
    ${footprint_count}=    Get Length    ${carbon_footprints}
    Should Be True    ${footprint_count} > 0    msg=StnryAssetCrbnFtprnt should be auto-generated
    
    # Get the first carbon footprint record
    ${carbon_footprint}=    Set Variable    ${carbon_footprints}[0]
    Log    ✓ Found auto-generated StnryAssetCrbnFtprnt: ${carbon_footprint}[Id]
    
    # Verify relationships in the carbon footprint
    Should Be Equal    ${carbon_footprint}[StnryAssetEnvrSrcId]    ${asset_env_src_id}
    Should Be Equal    ${carbon_footprint}[StnryAssetEnrgyUseId]    ${asset_energy_use_id}
    Log    ✓ StnryAssetCrbnFtprnt correctly linked to both StnryAssetEnvrSrc and StnryAssetEnrgyUse
    
    # Log success summary
    Log    ========================================
    Log    ✓ Successfully completed NZC workflow:
    Log    ✓ Account: ${account_id}
    Log    ✓ StnryAssetEnvrSrc: ${asset_env_src_id}
    Log    ✓ StnryAssetEnrgyUse: ${asset_energy_use_id}
    Log    ✓ AnnualEmssnInventory: ${annual_inventory_id}
    Log    ✓ StnryAssetCrbnFtprnt (auto-generated): ${carbon_footprint}[Id]
    Log    ========================================

Create Multiple Energy Uses For Same Asset
    [Documentation]    Test creating multiple energy use records for the same environmental source
    [Tags]    api    netzero    regression
    
    # Create base records
    ${account_id}=    Salesforce Insert    Account    Name=Multi-Energy Test Account
    ${asset_env_src_id}=    Salesforce Insert    StnryAssetEnvrSrc
    ...    Name=Main Building
    ...    AccountId=${account_id}
    
    # Create multiple energy use records
    ${start_date}=    Get Current Date    result_format=%Y-%m-%d
    
    ${energy_use_1}=    Salesforce Insert    StnryAssetEnrgyUse
    ...    Name=Electricity - January
    ...    StnryAssetEnvrSrcId=${asset_env_src_id}
    ...    StartDate=${start_date}
    ...    EndDate=${start_date}
    ...    EnergyConsumption=500
    ...    EnergyUseIntvlReadingCode=Monthly
    
    ${energy_use_2}=    Salesforce Insert    StnryAssetEnrgyUse
    ...    Name=Natural Gas - January
    ...    StnryAssetEnvrSrcId=${asset_env_src_id}
    ...    StartDate=${start_date}
    ...    EndDate=${start_date}
    ...    EnergyConsumption=300
    ...    EnergyUseIntvlReadingCode=Monthly
    
    # Wait for carbon footprints to be generated
    Sleep    5s
    
    # Verify both carbon footprints were created
    @{carbon_footprints}=    Soql Query
    ...    SELECT Id, StnryAssetEnrgyUseId 
    ...    FROM StnryAssetCrbnFtprnt 
    ...    WHERE StnryAssetEnvrSrcId = '${asset_env_src_id}'
    
    ${footprint_count}=    Get Length    ${carbon_footprints}
    Should Be Equal As Numbers    ${footprint_count}    2    msg=Should have 2 carbon footprints for 2 energy uses
    
    Log    ✓ Successfully created ${footprint_count} carbon footprints for multiple energy uses

Verify Account Relations
    [Documentation]    Verify that all NZC records are properly related to the Account
    [Tags]    api    netzero    validation
    
    # Create complete hierarchy
    ${account_name}=    Get Fake Data    company
    ${account_id}=    Salesforce Insert    Account    Name=${account_name}
    
    ${asset_env_src_id}=    Salesforce Insert    StnryAssetEnvrSrc
    ...    Name=${account_name} - Asset
    ...    AccountId=${account_id}
    
    ${start_date}=    Get Current Date    result_format=%Y-%m-%d
    ${energy_use_id}=    Salesforce Insert    StnryAssetEnrgyUse
    ...    Name=Energy Use Test
    ...    StnryAssetEnvrSrcId=${asset_env_src_id}
    ...    StartDate=${start_date}
    ...    EndDate=${start_date}
    ...    EnergyConsumption=100
    ...    EnergyUseIntvlReadingCode=Monthly
    
    ${year}=    Get Current Date    result_format=%Y
    ${inventory_id}=    Salesforce Insert    AnnualEmssnInventory
    ...    Name=${account_name} - Inventory
    ...    AccountId=${account_id}
    ...    ReportingYear=${year}
    
    # Query all related records through Account
    @{env_sources}=    Soql Query
    ...    SELECT Id FROM StnryAssetEnvrSrc WHERE AccountId = '${account_id}'
    
    @{inventories}=    Soql Query
    ...    SELECT Id FROM AnnualEmssnInventory WHERE AccountId = '${account_id}'
    
    # Verify correct counts
    Length Should Be    ${env_sources}    1
    Length Should Be    ${inventories}    1
    
    Log    ✓ All NZC records properly related to Account

Test Energy Consumption Validation
    [Documentation]    Test that energy consumption values are properly stored and retrieved
    [Tags]    api    netzero    validation
    
    ${account_id}=    Salesforce Insert    Account    Name=Energy Validation Test
    ${asset_env_src_id}=    Salesforce Insert    StnryAssetEnvrSrc
    ...    Name=Test Building
    ...    AccountId=${account_id}
    
    # Test various energy consumption values
    ${date}=    Get Current Date    result_format=%Y-%m-%d
    
    # High consumption
    ${high_energy_id}=    Salesforce Insert    StnryAssetEnrgyUse
    ...    Name=High Consumption
    ...    StnryAssetEnvrSrcId=${asset_env_src_id}
    ...    StartDate=${date}
    ...    EndDate=${date}
    ...    EnergyConsumption=50000
    ...    EnergyUseIntvlReadingCode=Monthly
    
    # Low consumption
    ${low_energy_id}=    Salesforce Insert    StnryAssetEnrgyUse
    ...    Name=Low Consumption
    ...    StnryAssetEnvrSrcId=${asset_env_src_id}
    ...    StartDate=${date}
    ...    EndDate=${date}
    ...    EnergyConsumption=100
    ...    EnergyUseIntvlReadingCode=Monthly
    
    # Verify values
    &{high_energy}=    Salesforce Get    StnryAssetEnrgyUse    ${high_energy_id}
    &{low_energy}=    Salesforce Get    StnryAssetEnrgyUse    ${low_energy_id}
    
    Should Be Equal As Numbers    ${high_energy}[EnergyConsumption]    50000
    Should Be Equal As Numbers    ${low_energy}[EnergyConsumption]    100
    
    Log    ✓ Energy consumption values correctly stored and retrieved

