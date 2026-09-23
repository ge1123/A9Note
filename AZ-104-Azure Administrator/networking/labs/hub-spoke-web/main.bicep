targetScope = 'subscription'
param rgName string
param location string
param sshPublicKey string
param vmSize string = 'Standard_B2ats_v2'
resource rg 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: rgName
  location: location
  tags: {
    purpose: 'az104-learning'
    lab: 'hub-spoke-web'
    cleanup: 'required'
  }
}
module workload 'resources.bicep' = {
  name: 'hub-spoke-web'
  scope: rg
  params: {
    location: location
    sshPublicKey: sshPublicKey
    vmSize: vmSize
  }
}
