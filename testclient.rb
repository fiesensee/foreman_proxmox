require 'httpclient'
class Testclient
    client = HTTPClient.new
    client.ssl_config.verify_mode= OpenSSL::SSL::VERIFY_NONE
    #client.get("https://192.168.37.149:8006/api2/json/access/ticket")
    testres = client.get("http://github.com")
    puts testres.header.reason_phrase
end