# coding: utf-8
require 'json'
require 'httparty'
require "pili/version"

module Pili
  autoload :Auth,          'pili/auth'
  autoload :Config,        'pili/config'
  autoload :API,           'pili/api'
  autoload :Utils,         'pili/utils'
  autoload :ResponseError, 'pili/exceptions'

  autoload :Client,        'pili/client'
  autoload :Stream,        'pili/stream'
end