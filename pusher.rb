module BaiduPusher
  class Pusher < BasePusher
    DeviceType = { 'android' => 3, 'ios' => 4 }.freeze
    DeployStatus = { 'develop' => 1, 'production' => 2 }.freeze

    attr_accessor :device_type, :deploy_status

    def initialize(sk, ak, device_type = 'ios', deploy_status = 'develop')
      super(sk, ak)
      @device_type = device_type
      @deploy_status = deploy_status
    end

    def query_bindlist(user_id)
      super({ 'user_id' => user_id })
    end

    def fetch_msg(user_id)
      super({ 'user_id' => user_id })
    end

    def push_single_user(user_id, message)
      msg = format_message(message)
      params = {
        'user_id' => user_id,
        'messages' => msg,
        'message_type' => 1,
        'msg_keys' => "bao.tv#{Digest::MD5.hexdigest(msg)}",
        'push_type' => 1,
        'device_type' => DeviceType[device_type],
        'deploy_status' => DeployStatus[deploy_status]
      }
      push_msg(params)
    end

    def push_tag(tag, message)
      msg = format_message(message)
      params = {
        'tag' => tag,
        'messages' => msg,
        'message_type' => 1,
        'msg_keys' => "bao.tv#{Digest::MD5.hexdigest(msg)}",
        'push_type' => 2,
        'device_type' => DeviceType[device_type],
        'deploy_status' => DeployStatus[deploy_status]
      }
      push_msg(params)
    end

    # use baidu ver 3.0
    def push_all(message, send_time=nil)
      msg = format_message(message)
      params = {
        'msg' => msg,
        'msg_type' => 1,
        'msg_keys' => "bao.tv#{Digest::MD5.hexdigest(msg)}",
        'push_type' => 3,
        'device_type' => DeviceType[device_type],
        'deploy_status' => DeployStatus[deploy_status]
      }
      params["send_time"] = send_time.to_i if send_time
      super(params)
    end

    def set_tag(user_id, tag)
      super({ 'user_id' => user_id, 'tag' => tag })
    end

    def delete_tag(user_id, tag)
      super({ 'user_id' => user_id, 'tag' => tag })
    end

    def query_user_tags(user_id)
      super({ 'user_id' => user_id })
    end

    private

    def format_message(message)
      if message.is_a? Hash
        message.to_json
      else
        ::BaiduPusher::Message.new(message).to_json
      end
    end
  end
end
