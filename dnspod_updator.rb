require 'net/http'
require 'uri'
require 'socket'
require 'json'

$params = {
    # you can get login_token from here: https://www.dnspod.cn/console/user/security
    # note that login_token format is 'ID,Token'
    # more information about login_token: https://support.dnspod.cn/Kb/showarticle/tsid/227/
    'login_token' => '#{REPLACE_ME}',

    'format' => 'json',

    # you can get domain_id by API Domain.List
    'domain' => '#{REPLACE_ME}',

    # you can get record_id by API Record.List
    'record_id' => '#{REPLACE_ME}',
}

# change it if you need modify other sub_domain
$sub_domain = 'www'


def get_current_ip
    url = 'ns1.dnspod.net'
    port = 6666

    begin
        socket = Socket.tcp(url, port, connect_timeout: 10)
        data = socket.recvfrom(16)
        ip = data[0]

        return ip
    ensure
        socket.close if socket != nil
    end
end

def get_recorded_ip
    uri = URI('https://dnsapi.cn/Record.Info')
    res = Net::HTTP.post_form(uri, $params)

    raise 'failed to get recorded_ip.' if res.code != '200'

    json = JSON.parse(res.body)
    ip = json['record']['value']
    return ip
end

def update_ip ip
    body = $params.clone
    body['value'] = ip
    body['record_line'] = '默认'
    body['sub_domain'] = $sub_domain

    uri = URI('https://dnsapi.cn/Record.Ddns')
    res = Net::HTTP.post_form(uri, body)

    raise 'failed to update ip.' if res.code != '200'
end

begin
    current_ip = get_current_ip()
    p "current_ip = #{current_ip}"

    recorded_ip = get_recorded_ip()
    p "recorded_ip = #{recorded_ip}"

    if recorded_ip == current_ip
        p 'recorded_ip is valid, no need update.'
        return
    end

    update_ip(current_ip)
    p 'update ip finished.'

rescue => exception
    p exception
end
