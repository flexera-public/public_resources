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
  network find("PS_TEST")
  subnets find("PS_TEST_SN1")
  instance_type "Standard_DS2_v2"
  security_groups "PS_TEST_SG_ACCESS"
  associate_public_ip_address "false"
  cloud_specific_attributes do {
    "root_volume_type_uid" => "Standard_LRS"
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
define launch_me(@server, @volume, @volume_attachment) return @server, @volume, @volume_attachment do

  provision(@server)
  provision(@volume)
  provision(@volume_attachment)

end