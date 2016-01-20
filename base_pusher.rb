module BaiduPusher
  class BasePusher
    def initialize(sk, ak)
      @sk = sk
      @ak = ak
    end

    %w(query_bindlist push_msg set_tag delete_tag query_user_tags fetch_msg push_all).each do |method_name|
      define_method(method_name) do |args|
        params = ActiveSupport::HashWithIndifferentAccess.new args
        params['method'] = method_name
        process(params)
      end
    end

    private

    attr_reader :sk, :ak

    API_URL_VER2 = 'http://channel.api.duapp.com/rest/2.0/channel/channel'

    def sign(url, params)
      params.delete(:sign)
      str = "POST#{url}#{params.sort.map { |kv| kv.join('=') }.join}#{sk}"
      # php urlencode: space to plus
      params[:sign] = Digest::MD5.hexdigest(CGI.escape(str))
      params
    end

    def process(params)
      params = params.merge('apikey' => ak, 'timestamp' => Time.now.to_i)
      params = sign(API_URL_VER2, params)
      transmit API_URL_VER2, params
    end

    def transmit(url, params)
      RestClient.post url, params
    rescue => e
      e.response
    end
  end
end
