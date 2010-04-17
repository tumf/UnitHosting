#!/usr/bin/env ruby
# vim:set fileencoding=utf-8:
require 'rubygems'
require 'pp'
require 'logger'
require 'xmlrpc/client'
require 'optparse'
require 'rexml/document'

module UnitHosting
  class Base
    def initialize(instance_id=nil,api_key=nil)
      @instance_id = instance_id
      @api_key = api_key
      @server = XMLRPC::Client.new_from_uri("https://www.unit-hosting.com/xmlrpc")
    end
    def server_call(method,param = {})
      param["instance_id"] = @instance_id
      param["api_key"] = @api_key
      return @server.call(method,param)
    end
  end
end
