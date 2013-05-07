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
	     after_build :add_interface_2remove
       before_provision :remove_interface_2remove


       def add_interface_2remove
         if virtual_machine.is_a? Fog::Compute::Libvirt::Server
           logger.debug "ForemanPluginComputeresourceAddRemoveInterface add_interface for #{get_interface_2remove}@libvirt"
         elsif virtual_machine.is_a? Fog::Compute::Vsphere::Server
           logger.debug "ForemanPluginComputeresourceAddRemoveInterface add_interface for #{get_interface_2remove}@vsphere"
           interface=getSetting_2remove :vsphere
           if not interface
             logger.warn "ForemanPluginComputeresourceAddRemoveInterface: Cannot setup now interface. Skipping."
           elsif get_interface_2remove
             logger.warn "ForemanPluginComputeresourceAddRemoveInterface: Interface already existant won't add. Skipping."
           else
             if getSetting(:restorePowerState)
               powerstate=virtual_machine.ready?
             end
             if getSetting(:forcePowerOff) and virtual_machine.ready?
               virtual_machine.stop :force=>true
             end
             virtual_machine.add_interface interface
             @virtual_machine=nil
             if powerstate
               virtual_machine.start
             end
           end
         else
           raise AttributeError "Cannot add interface for virtual machine #{virtual_machine}. Non supported compute_resource."
         end
       end
  
       def remove_interface_2remove
         if virtual_machine.is_a? Fog::Compute::Libvirt::Server
           logger.debug "ForemanPluginComputeresourceAddRemoveInterface remove_interface for #{get_interface_remove}@libvirt"
         elsif virtual_machine.is_a? Fog::Compute::Vsphere::Server
           logger.debug "ForemanPluginComputeresourceAddRemoveInterface remove_interface for #{get_interface_2remove}@vsphere"
           interface=get_interface_2remove
           if not interface
             logger.warn "ForemanPluginComputeresourceAddRemoveInterface: Could not find interface to remove. Skipping."
           else
             if getSetting(:restorePowerState)
               powerstate=virtual_machine.ready?
             end
             if getSetting(:forcePowerOff) and virtual_machine.ready?
               virtual_machine.stop :force=>true
             end
             virtual_machine.destroy_interface interface
             @virtual_machine=nil
             if powerstate
               virtual_machine.start
             end
           end
         else
           raise AttributeError "Cannot remove interface for virtual machine #{virtual_machine}. Non supported compute_resource."
         end
       end
       
       def get_interface_2remove
         if compute_resource.is_a? Foreman::Model::Libvirt
           virtual_machine.nics.select do | nic | valueInSetting_2remove(:libvirt, nic) end.last
         else
           virtual_machine.interfaces.select do | nic | valueInSetting_2remove(:vsphere, nic) end.last
         end
       end

       def valueInSetting_2remove key, obj
         setting=getSetting_2remove key
         if setting.is_a? Hash
           setting.each do | name, value |
             value2=obj.attributes[name]
             if value2.is_a? Class
               value2=value2.name.split("::")[-1]
             end
             if value.is_a? Class
               value=value.name.split("::")[-1]
             end
             if not value.to_sym == value2.to_sym
               return false
             end
           end
           return true
         else
           return setting == obj
         end
       end

       def getSetting_2remove key
         if getSetting and getSetting :enabled
           return getSetting_2remove_recursive(key, getSetting)
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

       def getSetting param=nil
         if not param
           SETTINGS[:pluginComputeresourceAddRemoveInterface]
         else
           SETTINGS[:pluginComputeresourceAddRemoveInterface][param]
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
