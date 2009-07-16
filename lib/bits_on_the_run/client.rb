module BitsOnTheRun
  class Client
    def initialize(action, params = {})
      default_params = {
        :api_format => :xml,
        :api_key => Configuration.api_key,
        :api_nonce => nonce,
        :api_timestamp => Time.now.to_i
      }

      @action = action
      @params = default_params.merge(params)
    end

    def response
      @response ||= REXML::Document.new(open(url).read)
    end

    protected
    def url
      [
        Configuration.api_url,
        Configuration.api_version,
        @action,
        "?",
        self.class.parameterize(params_with_signature)
      ].join
    end

    def params_with_signature
      @params.merge(:api_signature => signature)
    end

    def signature
      Digest::SHA1.hexdigest self.class.parameterize(@params) + Configuration.api_secret
    end

    # From the API documentation: API nonce is an 8 digits random number. It
    # is used to make sure that API signature is always unique, even if the
    # same call has been made twice within one second.
    def nonce
      rand 99_999_999
    end

    def self.parameterize(params)
      params.stringify_keys.sort.map do |key, value|
        [URI.escape(key), URI.escape(value.to_s)].join '='
      end.join '&'
    end
  end
end