module V1
  module ApiResources
    class Record
      include Praxis::ResourceDefinition

      media_type V1::MediaTypes::Record
      version '1.0'
      prefix '/dme/accounts/:account_id/records'
      trait :authenticated

      action :index do
        use :versionable

        routing do
          get ''
        end
        params do
          attribute :account_id, Attributor::Integer, required: true
        end
        response :ok
        response :forbidden
      end

      action :show do
        use :versionable

        routing do
          get '/:domain-:id'
        end
        params do
          attribute :account_id, Attributor::Integer, required: true
          attribute :id, required: true
          attribute :domain, required: true
        end
        response :ok
        response :not_found
        response :forbidden
      end

      action :create do
        routing do
          post ''
        end
        params do
          attribute :account_id, Attributor::Integer, required: true
        end
        payload do
          attribute :name, required: true
          attribute :domain, required: true
          attribute :value, required: true
          attribute :type, required: true
          attribute :dynamicDns
          attribute :ttl
          attribute :password
        end

        response :created
        response :unprocessable_entity
        response :forbidden
      end

      action :update do
        routing do
          put '/:domain-:id'
        end

        params do
          attribute :account_id, Attributor::Integer, required: true
          attribute :id, required: true
          attribute :domain, required: true
        end

        payload do
          attribute :name, required: true
          attribute :type, required: true
          attribute :value, required: true
        end

        response :no_content
        response :unprocessable_entity
        response :forbidden
      end

      action :delete do
        routing do
          delete '/:domain-:id'
        end

        params do
          attribute :domain, required: true
          attribute :id, required: true
          attribute :account_id, Attributor::Integer, required: true
        end

        response :no_content
        response :forbidden
      end


    end


  end
end


