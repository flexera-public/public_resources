name "ARM Server with Managed Disk Root Volume and Data Volume"
rs_ca_ver 20161221
short_description "Launch a Server with a Managed Disk Root Volume and Data Volume"

###################
# Resources       #
###################

resource "server", type: "server" do
  name "MDServer2"
  server_template find("RightLink 10.6.0 Linux Base")
  cloud "AzureRM West US"
  network find("Network_1")
  subnets find("Subnet_1")
  instance_type "Standard_DS2_v2"
  security_groups "SecurityGroup_1"
  associate_public_ip_address "false"
  cloud_specific_attributes do {
    "root_volume_type_uid" => "Standard_LRS" #Possible values: Standard_LRS, Premium_LRS
  } end
end

resource "volume", type: "volume" do
  name "MDServer_Data_Volume"
  cloud "AzureRM West US"
  size 10
  volume_type "Standard_LRS"
end

resource "volume_attachment", type: "volume_attachment" do
  server @server
  cloud "AzureRM West US"
  volume @volume
  device "00"
  settings do { 
    "delete_on_termination" => "true"
  } end
end
