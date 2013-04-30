require 'foreman_plugin_vsphere_add_remove_interface'

module ForemanVsphereAddRemoveInterface
  class Engine < ::Rails::Engine
    # Include extensions to models in this config.to_prepare block
    config.to_prepare do
        # Example: Include host extensions
        if SETTINGS[:version] > "1.1"
           ::Host::Managed.send :include, ForemanPluginVsphereAddRemoveInterface::HostExtensions
        else
           ::Host.send :include, ForemanPluginVsphereAddRemoveInterface::HostExtensions
        end
    end
  end
end
