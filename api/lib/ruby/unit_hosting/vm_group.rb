#!/usr/bin/env ruby
# vim:set fileencoding=utf-8:
require 'unit_hosting/vm.rb'
require 'unit_hosting/vm_recipe.rb'

module UnitHosting
  class VmGroup < Base
    def initialize(instance_id=nil,api_key=nil)
      @instance_id_elm = '/server-group/instance_id'
      @api_key_elm = '/server-group/key'
      super
    end
    # このサーバグループに含まれるVMオブジェクトをすべて返す
    def vms
      objs = Hash.new
      server_call("vmGroup.getVms").each do |vm|
        objs[vm["instance_id"]] = Vm.new(vm["instance_id"],vm["api_key"])
      end
      objs
    end
    # instance_idに紐づくvmを返す
    def vm(instance_id)
      Vm.new(instance_id,vm_api_key?(instance_id))
    end
    # vmの作成
    def create_vm(recipe)
      r = server_call("vmGroup.createVm",recipe.params)
      return false if r["result"] != "success"
      r
    end
    # サーバグループはVMのAPIキーを有効にできる
    def vm_api_key?(vm_id)
      server_call("vmGroup.getVms").each do |vm|
        return vm["api_key"] if vm["instance_id"] == vm_id
      end
      nil
    end
  end
end

if $0 == __FILE__
  g = UnitHosting::VmGroup.new
  g.load_key("/Users/tumf/.UnitHosting/keys/tumf-sg-10.key")
  pp g.vm('tumf-vm-107')
  # pp g.vms
  
end
