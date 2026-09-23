param location string
param sshPublicKey string
param adminUsername string = 'azureuser'
param vmSize string
var tags = { purpose: 'az104-learning', lab: 'hub-spoke-web' }
resource asg 'Microsoft.Network/applicationSecurityGroups@2024-05-01' = {
  name: 'asg-web'
  location: location
  tags: tags
}
resource nsg 'Microsoft.Network/networkSecurityGroups@2024-05-01' = {
  name: 'nsg-web'
  location: location
  tags: tags
  properties: {
    securityRules: [{
      name: 'Allow-HTTP-To-ASG'
      properties: {
        priority: 100
        direction: 'Inbound'
        access: 'Allow'
        protocol: 'Tcp'
        sourceAddressPrefix: 'Internet'
        sourcePortRange: '*'
        destinationApplicationSecurityGroups: [{ id: asg.id }]
        destinationPortRange: '80'
      }
    }]
  }
}
resource rt 'Microsoft.Network/routeTables@2024-05-01' = {
  name: 'rt-app'
  location: location
  tags: tags
  properties: {
    disableBgpRoutePropagation: false
    routes: [{
      name: 'Block-Test-Network'
      properties: { addressPrefix: '10.99.0.0/16', nextHopType: 'None' }
    }]
  }
}
resource hub 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: 'vnet-issue16-hub'
  location: location
  tags: tags
  properties: {
    addressSpace: { addressPrefixes: ['10.16.0.0/16'] }
    subnets: [
      {
        name: 'snet-web'
        properties: {
          addressPrefix: '10.16.1.0/24'
          defaultOutboundAccess: false
          networkSecurityGroup: { id: nsg.id }
        }
      }
      {
        name: 'snet-app'
        properties: {
          addressPrefix: '10.16.2.0/24'
          defaultOutboundAccess: false
          routeTable: { id: rt.id }
          serviceEndpoints: [{ service: 'Microsoft.Storage', locations: [location] }]
        }
      }
    ]
  }
}
resource spoke 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: 'vnet-issue16-spoke'
  location: location
  tags: tags
  properties: {
    addressSpace: { addressPrefixes: ['10.17.0.0/16'] }
    subnets: [{
      name: 'snet-workload'
      properties: { addressPrefix: '10.17.1.0/24', defaultOutboundAccess: false }
    }]
  }
}
resource hubPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-05-01' = {
  parent: hub
  name: 'peer-hub-to-spoke'
  properties: {
    remoteVirtualNetwork: { id: spoke.id }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}
resource spokePeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-05-01' = {
  parent: spoke
  name: 'peer-spoke-to-hub'
  properties: {
    remoteVirtualNetwork: { id: hub.id }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}
resource pip 'Microsoft.Network/publicIPAddresses@2024-05-01' = {
  name: 'pip-issue16-lb'
  location: location
  tags: tags
  sku: { name: 'Standard' }
  properties: { publicIPAllocationMethod: 'Static', publicIPAddressVersion: 'IPv4' }
}
var lbName = 'lb-issue16-web'
var frontendId = resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', lbName, 'fe-public')
var backendId = resourceId('Microsoft.Network/loadBalancers/backendAddressPools', lbName, 'be-web')
var probeId = resourceId('Microsoft.Network/loadBalancers/probes', lbName, 'hp-http')
resource lb 'Microsoft.Network/loadBalancers@2024-05-01' = {
  name: lbName
  location: location
  tags: tags
  sku: { name: 'Standard' }
  properties: {
    frontendIPConfigurations: [{ name: 'fe-public', properties: { publicIPAddress: { id: pip.id } } }]
    backendAddressPools: [{ name: 'be-web' }]
    probes: [{
      name: 'hp-http'
      properties: { protocol: 'Http', port: 80, requestPath: '/', intervalInSeconds: 5, numberOfProbes: 2 }
    }]
    loadBalancingRules: [{
      name: 'rule-http'
      properties: {
        protocol: 'Tcp'
        frontendPort: 80
        backendPort: 80
        frontendIPConfiguration: { id: frontendId }
        backendAddressPool: { id: backendId }
        probe: { id: probeId }
        idleTimeoutInMinutes: 4
        enableTcpReset: true
        disableOutboundSnat: true
      }
    }]
    outboundRules: [{
      name: 'outbound-web'
      properties: {
        protocol: 'All'
        allocatedOutboundPorts: 1024
        idleTimeoutInMinutes: 4
        frontendIPConfigurations: [{ id: frontendId }]
        backendAddressPool: { id: backendId }
      }
    }]
  }
}
resource nic 'Microsoft.Network/networkInterfaces@2024-05-01' = {
  name: 'nic-web01'
  location: location
  tags: tags
  properties: {
    ipConfigurations: [{
      name: 'ipconfig1'
      properties: {
        privateIPAllocationMethod: 'Static'
        privateIPAddress: '10.16.1.4'
        subnet: { id: '${hub.id}/subnets/snet-web' }
        applicationSecurityGroups: [{ id: asg.id }]
        loadBalancerBackendAddressPools: [{ id: '${lb.id}/backendAddressPools/be-web' }]
      }
    }]
  }
}
resource vm 'Microsoft.Compute/virtualMachines@2024-07-01' = {
  name: 'vm-web01'
  location: location
  tags: tags
  properties: {
    hardwareProfile: { vmSize: vmSize }
    osProfile: {
      computerName: 'vm-web01'
      adminUsername: adminUsername
      customData: base64(loadTextContent('cloud-init.yaml'))
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: { publicKeys: [{ path: '/home/${adminUsername}/.ssh/authorized_keys', keyData: sshPublicKey }] }
      }
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts-gen2'
        version: 'latest'
      }
      osDisk: { createOption: 'FromImage', deleteOption: 'Delete', managedDisk: { storageAccountType: 'Standard_LRS' } }
    }
    networkProfile: { networkInterfaces: [{ id: nic.id }] }
  }
}
