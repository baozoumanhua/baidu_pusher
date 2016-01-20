module BaiduPusher

  class Message
    attr_reader :msg
    def initialize(description, title='', custom_content={})

      @msg = {}
      @msg['description'] = description
      @msg['title'] = title
      @msg['custom_content'] = custom_content unless custom_content.empty?
    end

    def to_json
      msg.to_json
    end
  end

end
