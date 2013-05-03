require 'foreman_plugin_vsphere_add_remove_interface'

module ForemanComputeresourceAddRemoveInterface
  class Engine < ::Rails::Engine
    # Include extensions to models in this config.to_prepare block
    config.to_prepare do
        # Example: Include host extensions
        if SETTINGS[:version] > "1.1"
           ::Host::Managed.send :include, ForemanPluginComputeresourceAddRemoveInterface::HostExtensions
        else
           ::Host.send :include, ForemanPluginComputeresourceAddRemoveInterface::HostExtensions
        end
    end
  end
end
