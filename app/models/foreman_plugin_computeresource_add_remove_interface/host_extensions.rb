# Ensure that module is namespaced with plugin name

module ForemanPluginComputeresourceAddRemoveInterface
	# Example: Create new instance and class methods on Foreman's Host model
	module HostExtensions
	 	extend ActiveSupport::Concern

	  included do
	# 	  execute standard callbacks
	     after_create :add_interface_2remove
	#     after_destroy :do_that

	# 	  execute custom hooks
	     after_build :remove_interface_2remove
       before_provision :add_interface_2remove


       def add_interface_2remove
         if virtual_machine.is_a? Fog::Compute::Libvirt::Server
           logger.debug "ForemanPluginComputeresourceAddRemoveInterface add_interface for #{get_interface_2remove}@libvirt"
         elsif virtual_machine.is_a? Fog::Compute::Vsphere::Server
           logger.debug "ForemanPluginComputeresourceAddRemoveInterface add_interface for #{get_interface_2remove}@vsphere"
           virtual_machine.add_interface getSetting_2remove :vsphere
         else
           raise AttributeError "Cannot add interface for virtual machine #{virtual_machine}. Non supported compute_resource."
         end
       end
  
       def remove_interface_2remove
         if virtual_machine.is_a? Fog::Compute::Libvirt::Server
           logger.debug "ForemanPluginComputeresourceAddRemoveInterface remove_interface for #{get_interface_remove}@libvirt"
         elsif virtual_machine.is_a? Fog::Compute::Vsphere::Server
           logger.debug "ForemanPluginComputeresourceAddRemoveInterface remove_interface for #{get_interface_2remove}@vsphere"
           virtual_machine.destroy_interface get_interface_2remove
         else
           raise AttributeError "Cannot remove interface for virtual machine #{virtual_machine}. Non supported compute_resource."
         end
       end
       
       def get_interface_2remove
         if compute_resource.is_a? Foreman::Model::Libvirt
           virtual_machine.nics.select do | nic | valueInSetting_2remove([:libvirt, :network], nic.bridge) end.last
         else
           virtual_machine.interfaces.select do | nic | valueInSetting_2remove([:vsphere, :network], nic.network) end.last
         end
       end

       def valueInSetting_2remove key, value
         setting=getSetting_2remove key
         if setting.is_a? Array
           setting.each do | setting2 |
             if setting2 == value
               return true
             end
           end
           return false
         else
           return setting == value
         end
       end

       def getSetting_2remove key
         if SETTINGS[:pluginComputeresourceAddRemoveInterface] and SETTINGS[:pluginComputeresourceAddRemoveInterface][:enabled]
           return getSetting_2remove_recursive(key, SETTINGS[:pluginComputeresourceAddRemoveInterface])
         else
           nil
         end
       end
       
       def getSetting_2remove_recursive keys, hash
         if keys.is_a? Array and hash.has_key? keys.first
           key=keys.first
           keys=keys.pop
           return getSetting_2remove_recursive keys, hash[key]
         elsif hash.has_key? keys
           return hash[keys]
         else
           return nil
         end
       end

       def virtual_machine
         @virtual_machine||=compute_resource.find_vm_by_uuid(self.uuid)
       end
       
       def compute_resource
         @compute_resource||=ComputeResource.find_by_id(self.compute_resource_id)
       end
       
       def logger; Rails.logger; end
    end
	# 	  def do_something_special_after_build
	# 	    p "doing customized callback something special AFTER build"
	# 	  end
	# 	  def do_this_before_provision
	# 	  	p "doing this before provision"
	# 	  end
	# 	end

	# 	# create new method
	#   def new_instance_method
	#   end
	#   # or overwrite existing method
	#   def existing_method_name
	#   end

	#   module ClassMethods
	# 		# create new class method
	# 	  # ...
	# 	end

	end
end
