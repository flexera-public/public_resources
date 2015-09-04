name "Test for DME IP address"
rs_ca_ver 20131202
short_description "Test for a DME A name

![logo](http://www.dnsmadeeasy.com/wp-content/uploads/2013/09/logo1.png)"

# Cloud Selection
parameter "domain_name" do
  type "string"
  label "Name for A record"
  category "DNS"
end

# Cloud Selection
parameter "domain_ip" do
  type "string"
  label "IP address for A record"
  category "DNS"
end

resource 'dns_entry', type: 'dme.record' do
  domain 'dev.rightscaleit.com' # alternatively: domain_id 1234565
  name $domain_name
  type "A"
  value $domain_ip
  ttl 30
end

operation 'Update IP Address' do
  definition 'update_ip'
  description 'Update the IP of the record'
end

define update_ip(@dns_entry, $domain_ip) return @dns_entry do
 @dns_entry.update(name: @dns_entry.name, type: @dns_entry.type, value: $domain_ip)
end

############################
############################
 #  ___  __  __ ___
 # |   \|  \/  | __|
 # | |) | |\/| | _|
 # |___/|_|  |_|___|
 #
############################
############################

namespace "dme" do
  service do
    host "http://ssplugins.ryanoleary.com:8081" # HTTP endpoint presenting an API defined by self-serviceto act on resources
    path "/dme/accounts/:account_id"  # path prefix for all resources, RightScale account_id substituted in for multi-tenancy
    headers do {
      "user-agent" => "self_service" ,     # special headers as needed
      "X-Api-Version" => "1.0",
      "X-Api-Shared-Secret" => "3<54XZjrZ2sL9F7"
    } end
  end
  type "record" do
    provision "provision_record"
    delete "delete_record"
    fields do
      field "domain" do
        type "string"
        required true
      end
      field "name" do
        type "string"
        required true
      end
      field "value" do
        type "string"
        required true
      end
      field "type" do
        type "string"
        required true
      end
      field "dynamicDns" do
        type "boolean"
      end
      field "ttl" do
        type "number"
      end
    end
  end
end

define provision_record(@raw_record) return @resource do
  $obj = to_object(@raw_record)
  $to_create = $obj["fields"]
  @resource = dme.record.create($to_create)
end

define delete_record(@record) do
  @record.destroy()
end
