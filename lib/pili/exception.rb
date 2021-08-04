require 'json'

module Pili
  class RPCError < RuntimeError
    attr_reader :resp

    def initialize(message, resp)
      @resp = resp
      super(message)
    end

    def code
      resp.code
    end

    def reqid
      resp['X-Reqid']
    end

    def message
      to_s
    end

    def to_s
      "#{super}: #{@resp.body}"
    end
  end

  # 资源已存在冲突错误
  class ResourceConflict < RPCError
  end

  # 资源不存在错误
  class ResourceNotExist < RPCError
  end
end
