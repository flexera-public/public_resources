require 'json'
require 'rest-client' # Assumes 1.8.0 or later; otherwise, install http-cookie as well

url = 'https://analytics.rightscale.com/api/scheduled_reports'
jar = HTTP::CookieJar.new
jar.load('rightscalecookies', format: :cookiestxt)

response = RestClient.get(url,
  'X-Api-Version' => '1.0',
  'Cookie' => HTTP::Cookie.cookie_value(jar.cookies(url)))

JSON.parse(response)