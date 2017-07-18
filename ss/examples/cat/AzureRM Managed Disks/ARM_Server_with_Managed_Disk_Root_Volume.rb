name "ARM Server with Managed Disk Root Volume"
rs_ca_ver 20161221
short_description "Launch a Server with a Managed Disk Root Volume"

###################
# Resources       #
###################

resource "server", type: "server" do
  name "MDServer1"
  server_template find("RightLink 10.6.0 Linux Base")
  cloud "AzureRM West US"
  network "Network_1"
  subnets "Subnet_1"
  instance_type "Standard_DS2_v2"
  security_groups "SecurityGroup_1"
  associate_public_ip_address "false"
  cloud_specific_attributes do {
    "root_volume_type_uid" => "Standard_LRS" #Possible values: Standard_LRS, Premium_LRS
  } end
end
