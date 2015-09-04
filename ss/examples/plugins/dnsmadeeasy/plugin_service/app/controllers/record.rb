module V1
  class Record
    include Praxis::Controller

    implements V1::ApiResources::Record

    def index(account_id:, **params)
      resp = authenticate!(request.headers["X_Api_Shared_Secret"])
      return resp if resp

      api = get_api
      response.headers['Content-Type'] = 'application/json'

      records = api.records_for('dev.rightscaleit.com')["data"]
      records.each do |r|
        r["href"] = "/dme/accounts/" + account_id.to_s + "/records/dev.rightscaleit.com-" + r["id"].to_s
      end

      response.body = records.to_json
      response
    end

    def show(account_id:, domain:, id:, **other_params)
      resp = authenticate!(request.headers["X_Api_Shared_Secret"])
      return resp if resp

      api = get_api
      records = api.records_for(domain)
      rec = records['data'].select { |r| r['id'] == id }

      if rec.size > 0
        rec[0]["href"] = "/dme/accounts/" + account_id.to_s + "/records/dev.rightscaleit.com-" + rec[0]["id"].to_s
        response.body = rec[0]
      else
        self.response = Praxis::Responses::NotFound.new()
        response.body = { error: '404: Not found' }
      end
      response.headers['Content-Type'] = 'application/json'
      response
    end

    def create(account_id:, **other_params)
      resp = authenticate!(request.headers["X_Api_Shared_Secret"])
      return resp if resp

      api = get_api
      res = api.create_record(request.payload.domain, request.payload.name, request.payload.type, request.payload.value)


      if res["error"].nil?
        self.response = Praxis::Responses::Created.new()
        res["href"] = "/dme/accounts/" + account_id.to_s + "/records/dev.rightscaleit.com-" + res["id"].to_s
        response.headers['Location'] = res["href"]
        response.body = res
      else
        self.response = Praxis::Responses::UnprocessableEntity.new()
        response.body = { error: '422: Not able to create record' }
      end
      response.headers['Content-Type'] = 'application/json'
      response

    end

    def delete(domain:, id:, **other_params)
      resp = authenticate!(request.headers["X_Api_Shared_Secret"])
      return resp if resp

      api = get_api

      res = api.delete_record(domain, id)

      self.response = Praxis::Responses::NoContent.new()
      response

    end

    def update(domain:, id:, **other_params)
      resp = authenticate!(request.headers["X_Api_Shared_Secret"])
      return resp if resp

      api = get_api
      res = api.update_record(domain, id, request.payload.name, request.payload.type, request.payload.value)

      if res["error"].nil?
        self.response = Praxis::Responses::NoContent.new()
        response.body = res
      else
        self.response = Praxis::Responses::UnprocessableEntity.new()
        response.headers['Content-Type'] = 'application/json'
        response.body = { error: '422: Not able to update record' }
      end
      response

    end

    private

    def authenticate!(secret)
      if secret != ENV["PLUGIN_SHARED_SECRET"]
        self.response = Praxis::Responses::Forbidden.new()
        response.body = { error: '403: Invalid shared secret'}
        return response
      else
        return nil
      end
    end

    def get_api()
      api_key = ENV["DME_API_KEY"]
      api_secret = ENV["DME_API_SECRET"]
      api = DnsMadeEasy.new(api_key, api_secret)
    end
  end
end
