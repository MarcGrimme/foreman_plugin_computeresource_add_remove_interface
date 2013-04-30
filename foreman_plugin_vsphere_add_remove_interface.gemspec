$:.push File.expand_path("../lib", __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "foreman_plugin_vsphere_add_remove_interface"
  s.version     = "0.1"
  s.date        = "2013-04-19"
  s.authors     = ["Marc Grimme"]
  s.email       = ["grimme( at )atix.de"]
  s.homepage    = "http://atix.de/"
  s.summary     = "Adds or removes a given interface to a VMware guest when build and removes it afterwards."
  s.description = "Adds or removes a given interface to a VMware guest when build and removes it afterwards."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
    else
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
    end
  else
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
  end
end
