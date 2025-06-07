// Scope
targetScope = 'subscription'

// Parameters
@description('Resource group where Microsoft Fabric capacity will be deployed.')
param dprg string = 'rg-fabric'

@description('Microsoft Fabric Resource group location')
param rglocation string = 'westeurope'

@description('Cost Centre tag for all resources')
param cost_centre_tag string = 'MCAPS'

@description('System Owner tag')
param owner_tag string = 'labsvirtual.com'

@description('Subject Matter Expert (SME) tag')
param sme_tag string = 'support@labsvirtual.com'

@description('Deployment suffix')
param deployment_suffix string = 'defaultSuffix'

@description('Create new Purview resource?')
param create_purview bool = true

@description('Enable Purview integration?')
param enable_purview bool = true

@description('Purview resource group')
param purviewrg string = 'rg-datagovernance'

@description('Purview location')
param purview_location string = 'westeurope'

@description('Purview Account Name')
param purview_name string = 'labsvirtual-${deployment_suffix}'

@description('Enable audit?')
param enable_audit bool = true

@description('Audit resource group')
param auditrg string = 'rg-audit'

// Variables
var fabric_deployment_name = 'fabric_dataplatform_deployment_${deployment_suffix}'
var purview_deployment_name = 'purview_deployment_${deployment_suffix}'
var keyvault_deployment_name = 'keyvault_deployment_${deployment_suffix}'
var audit_deployment_name = 'audit_deployment_${deployment_suffix}'
var controldb_deployment_name = 'controldb_deployment_${deployment_suffix}'

// Reference existing resource groups if they already exist
resource fabric_rg 'Microsoft.Resources/resourceGroups@2024-03-01' existing = {
  name: dprg
}

// Reference existing capacity if already created
resource fabric_capacity_res 'Microsoft.Fabric/capacities@2023-11-01-preview' existing = {
  name: 'labsready'
  scope: fabric_rg
}

// Purview resource group (created only if needed)
resource purview_rg 'Microsoft.Resources/resourceGroups@2024-03-01' = if (create_purview) {
  name: purviewrg
  location: purview_location
  tags: {
    CostCentre: cost_centre_tag
    Owner: owner_tag
    SME: sme_tag
  }
}

// Audit resource group (created only if needed)
resource audit_rg 'Microsoft.Resources/resourceGroups@2024-03-01' = if (enable_audit) {
  name: auditrg
  location: rglocation
  tags: {
    CostCentre: cost_centre_tag
    Owner: owner_tag
    SME: sme_tag
  }
}

// Deploy Purview using module (remove deployment_suffix if not needed)
module purview './modules/purview.bicep' = if (create_purview || enable_purview) {
  name: purview_deployment_name
  scope: resourceGroup(purviewrg)
  params: {
    create_purview: create_purview
    enable_purview: enable_purview
    purviewrg: purviewrg
    purview_name: purview_name
    location: purview_location
    cost_centre_tag: cost_centre_tag
    owner_tag: owner_tag
    sme_tag: sme_tag
    // deployment_suffix: deployment_suffix  <-- Only include if defined in purview.bicep
  }
}

// Key Vault deployment
module kv './modules/keyvault.bicep' = {
  name: keyvault_deployment_name
  scope: fabric_rg
  params: {
    location: rglocation
    keyvault_name: 'ba-kv01'
    cost_centre_tag: cost_centre_tag
    owner_tag: owner_tag
    sme_tag: sme_tag
    purview_account_name: contains(purview, 'outputs') ? purview.outputs.purview_account_name : ''
    purviewrg: enable_purview ? purviewrg : ''
    enable_purview: enable_purview
  }
}

// Reference existing Key Vault
resource kv_ref 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: 'ba-kv01'
  scope: fabric_rg
}

// Audit integration module
module audit_integration './modules/audit.bicep' = if (enable_audit) {
  name: audit_deployment_name
  scope: audit_rg
  params: {
    location: rglocation
    cost_centre_tag: cost_centre_tag
    owner_tag: owner_tag
    sme_tag: sme_tag
    audit_storage_name: 'baauditstorage01'
    audit_storage_sku: 'Standard_LRS'
    audit_loganalytics_name: 'ba-loganalytics01'
  }
}

// Deploy Fabric Capacity using existing resource
module fabric_capacity './modules/fabric-capacity.bicep' = {
  name: fabric_deployment_name
  scope: fabric_rg
  params: {
    fabric_name: fabric_capacity_res.name
    location: rglocation
    cost_centre_tag: cost_centre_tag
    owner_tag: owner_tag
    sme_tag: sme_tag
    adminUsers: kv_ref.getSecret('fabric-capacity-admin-username')
    skuName: 'F4'
  }
}

// Deploy SQL control DB
module controldb './modules/sqldb.bicep' = {
  name: controldb_deployment_name
  scope: fabric_rg
  params: {
    sqlserver_name: 'ba-sql01'
    database_name: 'controlDB'
    location: rglocation
    cost_centre_tag: cost_centre_tag
    owner_tag: owner_tag
    sme_tag: sme_tag
    ad_admin_username: kv_ref.getSecret('sqlserver-ad-admin-username')
    ad_admin_sid: kv_ref.getSecret('sqlserver-ad-admin-sid')
    auto_pause_duration: 60
    database_sku_name: 'GP_S_Gen5_1'
    enable_purview: enable_purview
    purview_resource: enable_purview && contains(purview, 'outputs') ? purview.outputs.purview_resource : {}
    enable_audit: enable_audit
    audit_storage_name: enable_audit && contains(audit_integration, 'outputs') ? audit_integration.outputs.audit_storage_uniquename : ''
    auditrg: enable_audit ? audit_rg.name : ''
  }
}
