// Scope
targetScope = 'subscription'

// Parameters
@description('Resource group where Microsoft Fabric capacity will be deployed. Resource group will be created if it doesnt exist')
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> github/main
param dprg string = 'rg-fabric'

@description('Resource group location')
=======
param dprg string= 'rg-fabric'

@description('Microsoft Fabric Resource group location')
>>>>>>> upstream/main
param rglocation string = 'australiaeast'

@description('Cost Centre tag that will be applied to all resources in this deployment')
param cost_centre_tag string = 'MCAPS'

@description('System Owner tag that will be applied to all resources in this deployment')
param owner_tag string = 'whirlpool@contoso.com'

@description('Subject Matter EXpert (SME) tag that will be applied to all resources in this deployment')
<<<<<<< HEAD
<<<<<<< HEAD
param sme_tag string = 'sombrero@contoso.com'
=======
param sme_tag string ='sombrero@contoso.com'
>>>>>>> upstream/main
=======
param sme_tag string = 'sombrero@contoso.com'
>>>>>>> github/main

@description('Timestamp that will be appendedto the deployment name')
param deployment_suffix string = utcNow()

@description('Flag to indicate whether to create a new Purview resource with this data platform deployment')
<<<<<<< HEAD
<<<<<<< HEAD
param create_purview bool = true
=======
param create_purview bool = false
>>>>>>> upstream/main
=======
param create_purview bool = true
>>>>>>> github/main

@description('Flag to indicate whether to enable integration of data platform resources with either an existing or new Purview resource')
param enable_purview bool = true

@description('Resource group where Purview will be deployed. Resource group will be created if it doesnt exist')
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> github/main
param purviewrg string = 'rg-datagovernance'

@description('Location of Purview')
param purview_location string = 'westus2'

@description('Resource Name of new or existing Purview Account. Specify a resource name if create_purview=true or enable_purview=true')
param purview_name string = 'ContosoDG'
=======
param purviewrg string= 'rg-datagovernance'

@description('Location of Purview resource. This may not be same as the Fabric resource group location')
param purview_location string= 'westus2'

@description('Resource Name of new or existing Purview Account. Must be globally unique. Specify a resource name if either create_purview=true or enable_purview=true')
param purview_name string = 'ContosoDG' // Replace with a Globally unique name
>>>>>>> upstream/main

@description('Flag to indicate whether auditing of data platform resources should be enabled')
param enable_audit bool = true

@description('Resource group where audit resources will be deployed if enabled. Resource group will be created if it doesnt exist')
<<<<<<< HEAD
<<<<<<< HEAD
param auditrg string = 'rg-audit'
=======
param auditrg string= 'rg-audit'

>>>>>>> upstream/main
=======
param auditrg string = 'rg-audit'
>>>>>>> github/main

// Variables
var fabric_deployment_name = 'fabric_dataplatform_deployment_${deployment_suffix}'
var purview_deployment_name = 'purview_deployment_${deployment_suffix}'
var keyvault_deployment_name = 'keyvault_deployment_${deployment_suffix}'
var audit_deployment_name = 'audit_deployment_${deployment_suffix}'
var controldb_deployment_name = 'controldb_deployment_${deployment_suffix}'

// Create data platform resource group
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> github/main
resource fabric_rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: dprg
  location: rglocation
  tags: {
    CostCentre: cost_centre_tag
    Owner: owner_tag
    SME: sme_tag
<<<<<<< HEAD
  }
}

// Create purview resource group
resource purview_rg 'Microsoft.Resources/resourceGroups@2024-03-01' = if (create_purview) {
  name: purviewrg
  location: rglocation
  tags: {
    CostCentre: cost_centre_tag
    Owner: owner_tag
    SME: sme_tag
  }
}

// Create audit resource group
resource audit_rg 'Microsoft.Resources/resourceGroups@2024-03-01' = if (enable_audit) {
  name: auditrg
  location: rglocation
  tags: {
    CostCentre: cost_centre_tag
    Owner: owner_tag
    SME: sme_tag
  }
}
=======
resource fabric_rg  'Microsoft.Resources/resourceGroups@2024-03-01' = {
 name: dprg 
 location: rglocation
 tags: {
        CostCentre: cost_centre_tag
        Owner: owner_tag
        SME: sme_tag
=======
>>>>>>> github/main
  }
}

// Create purview resource group
<<<<<<< HEAD
resource purview_rg  'Microsoft.Resources/resourceGroups@2024-03-01' = if (create_purview) {
  name: purviewrg 
  location: purview_location
=======
resource purview_rg 'Microsoft.Resources/resourceGroups@2024-03-01' = if (create_purview) {
  name: purviewrg
  location: rglocation
>>>>>>> github/main
  tags: {
    CostCentre: cost_centre_tag
    Owner: owner_tag
    SME: sme_tag
  }
}

// Create audit resource group
resource audit_rg 'Microsoft.Resources/resourceGroups@2024-03-01' = if (enable_audit) {
  name: auditrg
  location: rglocation
  tags: {
<<<<<<< HEAD
         CostCentre: cost_centre_tag
         Owner: owner_tag
         SME: sme_tag
   }
 }
>>>>>>> upstream/main
=======
    CostCentre: cost_centre_tag
    Owner: owner_tag
    SME: sme_tag
  }
}
>>>>>>> github/main

// Deploy Purview using module
module purview './modules/purview.bicep' = if (create_purview || enable_purview) {
  name: purview_deployment_name
  scope: purview_rg
<<<<<<< HEAD
<<<<<<< HEAD
  params: {
=======
  params:{
>>>>>>> upstream/main
=======
  params: {
>>>>>>> github/main
    create_purview: create_purview
    enable_purview: enable_purview
    purviewrg: purviewrg
    purview_name: purview_name
    location: purview_location
    cost_centre_tag: cost_centre_tag
    owner_tag: owner_tag
    sme_tag: sme_tag
  }
<<<<<<< HEAD
<<<<<<< HEAD
=======
  
>>>>>>> upstream/main
=======
>>>>>>> github/main
}

// Deploy Key Vault with default access policies using module
module kv './modules/keyvault.bicep' = {
  name: keyvault_deployment_name
  scope: fabric_rg
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> github/main
  params: {
    location: fabric_rg.location
    keyvault_name: 'ba-kv01'
    cost_centre_tag: cost_centre_tag
    owner_tag: owner_tag
    sme_tag: sme_tag
    purview_account_name: enable_purview ? purview.outputs.purview_account_name : ''
    purviewrg: enable_purview ? purviewrg : ''
    enable_purview: enable_purview
<<<<<<< HEAD
=======
  params:{
     location: fabric_rg.location
     keyvault_name: 'ba-kv01'
     cost_centre_tag: cost_centre_tag
     owner_tag: owner_tag
     sme_tag: sme_tag
     purview_account_name: enable_purview ? purview.outputs.purview_account_name : ''
     purviewrg: enable_purview ? purviewrg : ''
     enable_purview: enable_purview
>>>>>>> upstream/main
=======
>>>>>>> github/main
  }
}

resource kv_ref 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: kv.outputs.keyvault_name
  scope: fabric_rg
}

//Enable auditing for data platform resources
<<<<<<< HEAD
<<<<<<< HEAD
module audit_integration './modules/audit.bicep' = if (enable_audit) {
  name: audit_deployment_name
  scope: audit_rg
  params: {
=======
module audit_integration './modules/audit.bicep' = if(enable_audit) {
  name: audit_deployment_name
  scope: audit_rg
  params:{
>>>>>>> upstream/main
=======
module audit_integration './modules/audit.bicep' = if (enable_audit) {
  name: audit_deployment_name
  scope: audit_rg
  params: {
>>>>>>> github/main
    location: audit_rg.location
    cost_centre_tag: cost_centre_tag
    owner_tag: owner_tag
    sme_tag: sme_tag
    audit_storage_name: 'baauditstorage01'
<<<<<<< HEAD
<<<<<<< HEAD
    audit_storage_sku: 'Standard_LRS'
=======
    audit_storage_sku: 'Standard_LRS'    
>>>>>>> upstream/main
=======
    audit_storage_sku: 'Standard_LRS'
>>>>>>> github/main
    audit_loganalytics_name: 'ba-loganalytics01'
  }
}

//Deploy Microsoft Fabric Capacity
module fabric_capacity './modules/fabric-capacity.bicep' = {
  name: fabric_deployment_name
  scope: fabric_rg
<<<<<<< HEAD
<<<<<<< HEAD
  params: {
=======
  params:{
>>>>>>> upstream/main
=======
  params: {
>>>>>>> github/main
    fabric_name: 'bafabric01'
    location: fabric_rg.location
    cost_centre_tag: cost_centre_tag
    owner_tag: owner_tag
    sme_tag: sme_tag
    adminUsers: kv_ref.getSecret('fabric-capacity-admin-username')
<<<<<<< HEAD
=======
    skuName: 'F4' // Default Fabric Capacity SKU F2
>>>>>>> upstream/main
  }
}

//Deploy SQL control DB 
module controldb './modules/sqldb.bicep' = {
  name: controldb_deployment_name
  scope: fabric_rg
<<<<<<< HEAD
<<<<<<< HEAD
=======
>>>>>>> github/main
  params: {
    sqlserver_name: 'ba-sql01'
    database_name: 'controlDB'
    location: fabric_rg.location
    cost_centre_tag: cost_centre_tag
    owner_tag: owner_tag
    sme_tag: sme_tag
    ad_admin_username: kv_ref.getSecret('sqlserver-ad-admin-username')
    ad_admin_sid: kv_ref.getSecret('sqlserver-ad-admin-sid')
    auto_pause_duration: 60
    database_sku_name: 'GP_S_Gen5_1'
    enable_purview: enable_purview
    purview_resource: enable_purview ? purview.outputs.purview_resource : {}
    enable_audit: false
    audit_storage_name: audit_integration.outputs.audit_storage_uniquename
    auditrg: audit_rg.name
<<<<<<< HEAD
=======
  params:{
     sqlserver_name: 'ba-sql01'
     database_name: 'controlDB' 
     location: fabric_rg.location
     cost_centre_tag: cost_centre_tag
     owner_tag: owner_tag
     sme_tag: sme_tag
     ad_admin_username:  kv_ref.getSecret('sqlserver-ad-admin-username')
     ad_admin_sid:  kv_ref.getSecret('sqlserver-ad-admin-sid')  
     auto_pause_duration: 60
     database_sku_name: 'GP_S_Gen5_1' 
     enable_purview: enable_purview
     purview_resource: enable_purview ? purview.outputs.purview_resource : {}
     enable_audit: false
     audit_storage_name: enable_audit?audit_integration.outputs.audit_storage_uniquename:''
     auditrg: enable_audit?audit_rg.name:''
>>>>>>> upstream/main
=======
>>>>>>> github/main
  }
}
