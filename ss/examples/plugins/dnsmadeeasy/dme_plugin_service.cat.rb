name "DNS Made Easy Plugin Service"
rs_ca_ver 20131202
short_description "Stands up a server to host a docker container which deploys the DNS Made Easy plugin service for CAT/CWF"

parameter "secret" do
  label "Plugin Shared Secret"
  description "The shared secret that will be used to authenticate the CAT to the plugin service"
  type "string"
end

parameter "dme_key" do
  label "DME API Key"
  description "The DNS Made Easy API Key for the DME account that the plugin service will use"
  type "string"
end

parameter "dme_secret" do
  label "DME API Secret"
  description "The DNS Made Easy API Secret for the DME account that the plugin service will use"
  type "string"
end

resource "server_1", type: "server" do
  name "Docker Technology Demo"
  cloud "EC2 us-west-2"
  instance_type "m1.medium"
  multi_cloud_image find("RightImage_Ubuntu_14.04_x64_v14.2_EBS", revision: 6)
  ssh_key "default"
  security_groups "ROL - docker"
  server_template find("Docker Technology Demo", revision: 2)
  inputs do {
    "DOCKER_ENVIRONMENT" => join(["cred:SS Plugin Docker Yaml for ", @@deployment.href]),
    "DOCKER_PROJECT" => "text:rightscale",
    "DOCKER_SERVICES" => "text:dme:
  image: ryanolearyrs/public_plugins:dme
  ports: 
   - \"8081:8088\"",
  } end
end

resource "docker_yaml", type: "credential" do
  name join(["SS Plugin Docker Yaml for ", @@deployment.href])
  value join(["dme:
  DME_API_KEY: ", $dme_key, "
  DME_API_SECRET: ", $dme_secret, "
  PLUGIN_SHARED_SECRET: ", $secret])
end

operation "launch" do
  definition "import_servertemplate"
end

define import_servertemplate() do
  # Make sure the Docker Tech Demo ST is in the account - import it if not
  @st = find("server_templates", {name: "Docker Technology Demo", revision: 2})
  if( size(@st) == 0 )
    @pub = find("publications", {name: "Docker Technology Demo", revision: 2})
    if( size(@pub) == 0 )
      raise "No ServerTemplate found in the marketplace"
    end
    @pub.import()
  end
end
