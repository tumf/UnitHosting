#!/usr/bin/env ruby
# vim:set fileencoding=utf-8:
require 'unit_hosting/vm.rb'

module UnitHosting
  class VmGroup < Base
    @instance_id_elm = '/server-group/instance_id'
    @api_key_elm = '/server-group/key'
    # このサーバグループに含まれるVMオブジェクトをすべて返す
    def vms
      objs = Hash.new
      server_call("vmGroup.getVms").each do |vm|
        objs[vm["instance_id"]] = Vm.new(vm["instance_id"],vm["api_key"])
      end
      objs
    end
    def create_vm()

    end
    # サーバグループはVMのAPIキーを有効にできる
    def vm_api_key?(vm_id)

    end
  end
end

if $0 == __FILE__
  g = UnitHosting::VmGroup.new
  g.load_key("/Users/tumf/.UnitHosting/keys/tumf-sg-10.key")
  pp g.vms
  
end
