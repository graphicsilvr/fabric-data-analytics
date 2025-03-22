// main.bicepparam
param sqlserver_name = 'my-sql-server'
param database_name = 'my-database'
param cost_centre_tag = 'IT-001'
param owner_tag = 'maxiem'
param sme_tag = 'john.doe@example.com'
param ad_admin_username = 'sqladmin'
param ad_admin_sid = '00000000-0000-0000-0000-000000000000'
param enable_purview = false
param enable_audit = true

param purview_resource = {
  identity: {
    principalId: 'AZURE_CREDENTIALS'
  }
}

param audit_storage_name = 'auditstorageacct'
param auditrg = 'audit-resource-group'

# Optional parameters to override defaults
param location = 'westeurope'
param database_sku_name = 'GP_S_Gen5_1'
param auto_pause_duration = 60

// ... add all required parameters
