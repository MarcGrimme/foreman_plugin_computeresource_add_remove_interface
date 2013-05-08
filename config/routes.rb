Rails.application.routes.draw do

  #Example
  match 'myunattended/(:action/(:id(.format)))', :to => 'foreman_plugin_computeresource_add_remove_interface/myunattended'
end
