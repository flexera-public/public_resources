name "ARM Server with Managed Disk Root Volume and Data Volume, and Parameters"
rs_ca_ver 20161221
short_description "Launch a Server with a Managed Disk Root Volume and Data Volume using Paramters"

###################
# Mappings        #
###################

mapping "map_server_settings" do {
    "server_templates" => {
      "Windows" => "Rightlink 10.6.0 Windows Base",
      "Linux" => "RightLink 10.6.0 Linux Base"
    },
    "instance_sizes" => {
      "small" => "Standard_D1_v2",
      "medium" => "Standard_D2_v2",
      "large" => "Standard_D3_v2"
    }
}
end

mapping "map_region_settings" do {
  "AzureRM East US" => {
    "network" => "ARM_East_Network",
    "subnet" => "ARM_East_Subnet",
    "security_group" => "ARM_East_SecurityGroup"
  },
  "AzureRM West US" => {
    "network" => "ARM_West_Network",
    "subnet" => "ARM_West_Subnet",
    "security_group" => "ARM_West_SecurityGroup"
  }
}
end

###################
# Parameters      #
###################

parameter "param_cloud" do
    type "string"
    label "Cloud Region"
    category "Cloud"
    description "What cloud/region to use"
    allowed_values "AzureRM East US","AzureRM West US"
    default "AzureRM West US"
end

parameter "param_operating_system" do
    type "string"
    label "Base Operating System"
    category "Server"
    description "What operating system type to use"
    allowed_values "Windows", "Linux"
    default "Linux"
end

parameter "param_server_name" do
  type "string"
  label "Server Name"
  category "Server"
  description "The server name"
end

parameter "param_instance_type" do
  type "string"
  label "Instance Size"
  category "Server"
  description "The instance size to use for the server"
  default "small"
  allowed_values "small", "medium", "large"
end

parameter "param_volume_type" do
    type "string"
    label "Type of Root and Data Volume"
    category "Volumes"
    description "The type of volume to use for the Root and Data volumes"
    allowed_values "Standard_LRS", "Premium_LRS"
    default "Standard_LRS"
end

parameter "param_volume_size" do
    type "number"
    label "Size of Data Volume(GB)"
    category "Volumes"
    description "The size of the Data volume in GB"
    default "10"
end

###################
# Resources       #
###################

resource "server", type: "server" do
  name $param_server_name
  server_template find(map($map_server_settings, "server_templates", $param_operating_system))
  cloud $param_cloud
  network map($map_cloud_settings, $param_cloud, "network")
  subnets map($map_cloud_settings, $param_cloud, "subnet")
  instance_type map($map_server_settings, "instance_sizes", $param_instance_type)
  security_groups map($map_cloud_settings, $param_cloud, "security_group")
  associate_public_ip_address "false"
  cloud_specific_attributes do {
    "root_volume_type_uid" => $param_volume_type #Possible values: Standard_LRS, Premium_LRS
  } end
end

resource "volume", type: "volume" do
  name join([$param_server_name, "_Data_Volume"])
  cloud $param_cloud
  size $param_volume_size
  volume_type $param_volume_type
end

resource "volume_attachment", type: "volume_attachment" do
  server @server
  cloud $param_cloud
  volume @volume
  device "00"
  settings do { 
    "delete_on_termination" => "true"
  } end
end
