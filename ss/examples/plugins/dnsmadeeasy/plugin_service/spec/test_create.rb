require 'uri'
require 'net/http'
require 'json'

  def post(path, body)
    request(path) do |uri|
      req = Net::HTTP::Post.new(uri.path)
      req.body = body.to_json
      req
    end

  end

  def request(path)
    uri = URI("#{path}")

    http = Net::HTTP.new(uri.host, uri.port)

    request = yield(uri)

    request_headers.each do |key, value|
      request[key] = value
    end

    response = http.request(request)
    puts response.body
    unparsed_json = response.body == "" ? "{}" : response.body

    puts response.code
    puts response.message
    puts response.headers

    JSON.parse(unparsed_json)
  end

  def request_headers
    {
      'Content-type' => 'application/json',
      'X-Api-Version' => '1.0',
      "X-Api-Shared-Secret" => "blah"
    }
  end

  post('http://localhost:8081/dme/accounts/60073/records', {"domain"=>"dev.rightscaleit.com","name"=>"ryanolearytest","type"=>"A","value"=>"1.1.1.1"})
