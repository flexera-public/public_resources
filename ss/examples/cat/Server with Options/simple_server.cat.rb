name "Basic Linux Server RSB - test inputs"
rs_ca_ver 20131202
short_description "![logo](http://assets.rightscale.com/69d7cf43d5f89965c1676fe604af36987aada5da/web/images/icons/home7.png) SStandalone Linux server with basic options."
long_description "This basic server will stand up a vanilla server with only the required security 
updates and auditing software installed.

### Available OSs ###
* Ubuntu 12.04
* CentOS 6.5


### Instance Sizes ###
* 1x 2.6Ghz, 3.75GB RAM m3.medium
* 2x 2.6Ghz, 7.5 GB RAM m3.large
* 2x 2.8Ghz, 3.75GB RAM c3.large
* 8x 2.8Ghz, 15GB RAM c3.2xlarge
* 4x 2.6Ghz, 34.2GB RAM m2.2xlarge
* 8x 2.5Ghz, 61GB RAM i2.2xlarge

"

#########
# Parameters
#########

# Cloud
parameter "cloud" do
  type "string"
  label "Cloud"
  category "Resource pool"
  allowed_values "AWS", "Azure"
  default "AWS"
  description "The cloud that the server will launch in"
end

# Operating System

parameter "operating_system" do
  type "string"
  label "Operating System Distro"
  category "Operating System"
  allowed_values "Ubuntu 12.04", "CentOS 6.5"
  default "Ubuntu 12.04"
end

# Instance Size

parameter "instance_size" do
  type "string"
  label "Instance Size"
  category "Performance"
  allowed_values "c1.medium", "m1.small", "m1.xlarge"
  default "c1.medium"
end

#########
# Mappings
#########

mapping "os_mapping" do {
  "Ubuntu 12.04" => {
  	"mci_name" => "RightImage_Ubuntu_12.04_x64_v5.8",
  	"mci_rev"  => "26"}, 
  "CentOS 6.5" => {
  	"mci_name" => "RightImage_CentOS_6.3_x64_v5.8",
  	"mci_rev"  => "35"},  
}
end

mapping "cloud_mapping" do {
  "AWS" => {
    "cloud_href" => "/api/clouds/6", # AWS ap-southeast-2
    "ssh_key_href" => "/api/clouds/6/ssh_keys/CBNF5UA7SLHQ4", # RightScale-POC
    "security_group_hrefs" => "/api/clouds/6/security_groups/5MI3HSV142JOC", # RightScale-POC
    "subnet_hrefs" => null, # subnet-f5323b97
  },
  "Azure" => {
    "cloud_href" => "/api/clouds/2178", # Azure Southeast Asia
    "ssh_key_href" => null, # RightScale-POC
    "security_group_hrefs" => null, # RightScale-POC
    "subnet_hrefs" => null, # subnet-f5323b97
  }, 
} end

mapping "instance_mapping" do {
  "c1.medium" => {
    "AWS" => "/api/clouds/6/instance_types/1GFPQQ2KVKM",
    "Azure" => "/api/clouds/2178/instance_types/7IHJSK47M2K6K",
  },
  "m1.small" => {
    "AWS" => "/api/clouds/6/instance_types/1BH7SA9LMLFSV", 
    "Azure" => "/api/clouds/2178/instance_types/F894PR79927HV", 
  },
  "m1.xlarge" => {
    "AWS" => "/api/clouds/6/instance_types/1J7T23NPF0ULO", 
    "Azure" => "/api/clouds/2178/instance_types/1SQ12LL45K2Q0", 
  },
} end

#########
# Resources
#########

resource 'base_server', type: 'server' do
  name "base_server"
  server_template find('Base ServerTemplate for Linux (RSB) (v13.3)', revision: 100)
  multi_cloud_image find( map( $os_mapping, $operating_system, "mci_name"), revision: map( $os_mapping, $operating_system, "mci_rev"))

  cloud_href map( $cloud_mapping, $cloud, "cloud_href")
  instance_type_href map( $instance_mapping, $instance_size, $cloud)
  ssh_key_href map( $cloud_mapping, $cloud, "ssh_key_href")
  security_group_hrefs map( $cloud_mapping, $cloud, "security_group_hrefs")

end
