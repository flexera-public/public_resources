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
  network find("PS_TEST")
  subnets find("PS_TEST_SN1")
  instance_type "Standard_DS2_v2"
  security_groups "PS_TEST_SG_ACCESS"
  associate_public_ip_address "false"
  cloud_specific_attributes do {
    "root_volume_type_uid" => "Standard_LRS"
  } end
end


###################
# Operations      #
###################
operation "launch" do
  description "Launch the server"
  definition "launch_me"
end


###################
# Definitions     #
###################
define launch_me(@server) return @server do

  provision(@server) 

end