# coding: utf-8
require 'json'
require 'httparty'
require "pili/version"

module Pili
  autoload :Credentials,   'pili/credentials'
  autoload :Config,        'pili/config'
  autoload :RPC,           'pili/rpc'
  autoload :API,           'pili/api'
  autoload :Utils,         'pili/utils'
  autoload :ResponseError, 'pili/exceptions'

  autoload :Hub,           'pili/hub'
  autoload :Stream,        'pili/stream'
end