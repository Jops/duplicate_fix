require "net/http"
require "uri"

def grab
    # uri = URI('https://api.live.bbc.co.uk/zed/newid')
    uri = URI('https://api.live.bbc.co.uk/knowlearn-asset/learning-clips/z3ph34j')
    pem = File.read("../../certificates/dev.bbc.co.uk.pem")

    proxy_addr = 'www-cache.reith.bbc.co.uk'
    proxy_port = 80

    puts 'host: ' + uri.host.to_s
    puts 'port: ' + uri.port.to_s
    puts 'request_uri: ' + uri.request_uri

    @res

    Net::HTTP::Proxy(proxy_addr, proxy_port).start( uri.host,
                                                    uri.port,
                                                    :use_ssl => uri.scheme == 'https',
                                                    :cert => OpenSSL::X509::Certificate.new(pem),
                                                    :key => OpenSSL::PKey::RSA.new(pem),
                                                    :verify_mode => OpenSSL::SSL::VERIFY_PEER) do |http|
        request = Net::HTTP::Get.new uri.request_uri
        @res = http.request request # Net::HTTPResponse object
    end

    puts @res.code       # => '200'
    puts @res.message    # => 'OK'
    puts @res.class.name # => 'HTTPOK'

    # Body
    puts '************'
    puts @res.body.scan(/<id>(z[a-z0-9]+)/)
    puts '************'
end

grab
