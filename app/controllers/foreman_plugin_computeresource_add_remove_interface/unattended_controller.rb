module ForemanPluginComputeresourceAddRemoveInterface
  # Example: Create new instance and class methods on Foreman's Host model
    # Example: Plugin's HostsController inherits from Foreman's HostsController
  class UnattendedController < ::UnattendedController

    # change layout if
    # layout 'foreman_plugin_template/layouts/new_layout'

  #  def new_action
      # automatically renders view/foreman_plugin_template/hosts/new_action
        #  end

     def find_host_by_ip_or_mac
       log.debug("ForemanPluginComputeresourceAddRemoveInterface::UnattendedController find_host_by_ip_or_mac")
       host = super
       if not host
         ip = request.env['HTTP_REMOTE_ADDR']

         # check if someone is asking on behave of another system (load balance etc)
         if request.env['HTTP_X_FORWARDED_FOR'].present? and (ip =~ Regexp.new(Setting[:remote_addr]))
           ip = request.env['HTTP_X_FORWARDED_FOR']
         end

         # in case we got back multiple ips (see #1619)
         ip = ip.split(',').first

         # search for a mac address in any of the RHN provisioning headers
         # this section is kickstart only relevant
         mac_list = []
         if request.env['HTTP_X_RHN_PROVISIONING_MAC_0'].present?
           begin
             request.env.keys.each do |header|
               mac_list << request.env[header].split[1].strip.downcase if header =~ /^HTTP_X_RHN_PROVISIONING_MAC_/
             end
           rescue => e
             logger.info "unknown RHN_PROVISIONING header #{e}"
             mac_list = []
           end
         end
         # we try to match first based on the MAC, falling back to the IP
         Host.where(mac_list.empty? ? { :ip => ip } : ["lower(mac) IN (?)", mac_list]).first
       end
     end
  end
end
