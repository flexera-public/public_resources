name "Basic Linux Server RSB"
rs_ca_ver 20131202
short_description "Standalone Linux server"

#########
# Resources
#########

resource 'base_server', type: 'server' do
  name "base_server"
  server_template find('Base ServerTemplate for Linux (RSB) (v13.3)', revision: 100)
  multi_cloud_image find( "RightImage_CentOS_6.3_x64_v5.8", revision: 35)

  cloud "EC2 us-east-1"
  instance_type "m1.small"
  ssh_key "default"
  security_groups "default"

end
