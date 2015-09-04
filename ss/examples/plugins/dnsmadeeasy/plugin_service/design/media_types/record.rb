module V1
  module MediaTypes
    class Record < Praxis::MediaType

      identifier 'application/json'

      attributes do
        attribute :id, Attributor::Integer, description: "The ID of this record"
        attribute :href, Attributor::String
        attribute :domain, Attributor::String, description: "Name of the record to create"
        attribute :name, Attributor::String, description: "Domain to create the record in"
        attribute :value, Attributor::String, description: "Value of the record (i.e. the IP address)"
        attribute :type, Attributor::String, description: "Type of record (i.e. 'A')"
        attribute :dynamicDns, Attributor::Boolean, description: "Allow dynamic DNS updates"
        attribute :ttl, Attributor::Integer, description: "Record TTL"
        attribute :password, Attributor::String, description: "Password used to update the record"

      end

      view :default do
        attribute :id
        attribute :href
        attribute :domain
        attribute :name
        attribute :value
        attribute :type
        attribute :dynamicDns
        attribute :ttl
        attribute :password
      end

      view :link do
        attribute :href
      end
    end
  end
end
