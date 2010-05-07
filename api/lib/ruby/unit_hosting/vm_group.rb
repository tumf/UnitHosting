#!/usr/bin/env ruby
# vim:set fileencoding=utf-8:
require 'unit_hosting'

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
    def vm_api_key instance_id
      server_call("vmGroup.getVms").each do |vm|
        return vm["api_key"] if vm[instance_id] == instance_id
      end
    end
    # instance_idに紐づくvmを返す
    def vm(instance_id)
      Vm.new(instance_id,vm_api_key(instance_id))
    end
    # vmの作成
    def create_vm(recipe)
      r = server_call("vmGroup.createVm",recipe.params)
      return false if r["result"] != "success"
      r
    end
  end
end

if $0 == __FILE__
  pp  UnitHosting::VmGroup.load('tumf-sg-10').vm('tumf-vm-107')
  exit
  recipe = UnitHosting::VmRecipe.new
  # recipe.
end


