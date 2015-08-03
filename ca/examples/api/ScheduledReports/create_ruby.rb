require 'json'
require 'rest-client' # Assumes 1.8.0 or later; otherwise, install http-cookie as well

url = 'https://analytics.rightscale.com/api/scheduled_reports'

report = {
  name: "Report Title",
  frequency: "monthly",
  additional_emails: ["additional@example.com"],
  filters: [{
    type: "instance:instance_type_key",
    value: "5::m1.large",
    label: "m1.large"
  }],
  attach_csv: true
}

jar = HTTP::CookieJar.new
jar.load('rightscalecookies', format: :cookiestxt)

response = RestClient.post(url,
  report.to_json,
  'X-Api-Version' => '1.0',
  'Content-Type' => 'application/json',
  'Cookie' => HTTP::Cookie.cookie_value(jar.cookies(url)))

JSON.parse(response)require 'json'
require 'rest-client' # Assumes 1.8.0 or later; otherwise, install http-cookie as well

url = 'https://analytics.rightscale.com/api/scheduled_reports'

report = {
  name: "Report Title",
  frequency: "monthly",
  additional_emails: ["additional@example.com"],
  filters: [{
    type: "instance:instance_type_key",
    value: "5::m1.large",
    label: "m1.large"
  }],
  attach_csv: true
}

jar = HTTP::CookieJar.new
jar.load('rightscalecookies', format: :cookiestxt)

response = RestClient.post(url,
  report.to_json,
  'X-Api-Version' => '1.0',
  'Content-Type' => 'application/json',
  'Cookie' => HTTP::Cookie.cookie_value(jar.cookies(url)))

JSON.parse(response)