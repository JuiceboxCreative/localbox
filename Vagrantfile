# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'json'
require 'yaml'

VAGRANTFILE_API_VERSION ||= "2"
confDir = $confDir ||= File.expand_path(File.dirname(__FILE__))

homesteadYamlPath = confDir + "/Homestead.yaml"
homesteadJsonPath = confDir + "/Homestead.json"
afterScriptPath = confDir + "/after.sh"
aliasesPath = confDir + "/aliases"

require File.expand_path(File.dirname(__FILE__) + '/scripts/homestead.rb')

Vagrant.require_version '>= 2.1.0'

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    if File.exist? aliasesPath then
        config.vm.provision "file", source: aliasesPath, destination: "/tmp/bash_aliases"
        config.vm.provision "shell" do |s|
            s.inline = "awk '{ sub(\"\r$\", \"\"); print }' /tmp/bash_aliases > /home/vagrant/.bash_aliases"
        end
    end

    if File.exist? homesteadYamlPath then
        settings = YAML::load(File.read(homesteadYamlPath))
    elsif File.exist? homesteadJsonPath then
        settings = JSON::parse(File.read(homesteadJsonPath))
    else
        abort "Homestead settings file not found in #{confDir}"
    end

    Homestead.configure(config, settings)

    if File.exist? afterScriptPath then
        config.vm.provision "shell", path: afterScriptPath, privileged: false, keep_color: true
    end

    if Vagrant.has_plugin?('vagrant-hostsupdater')
        config.hostsupdater.aliases = settings['sites'].map { |site| site['map'] }
    elsif Vagrant.has_plugin?('vagrant-hostmanager')
        config.hostmanager.enabled = true
        config.hostmanager.manage_host = true
        config.hostmanager.aliases = settings['sites'].map { |site| site['map'] }
    end

    if defined? VagrantPlugins::Triggers
        if OS.mac?
          # port forwarding setup and removal for running on your host primary IP address
          config.trigger.after [:up, :reload, :provision], :stdout => true do
            system('echo "
        rdr pass inet proto tcp from any to any port 80 -> 127.0.0.1 port 8000
        rdr pass inet proto tcp from any to any port 443 -> 127.0.0.1 port 44300
        " | sudo pfctl -ef - >/dev/null 2>&1; echo "Add Port Forwarding (80 => 8000)\nAdd Port Forwarding (443 => 44300)"')
          end
          config.trigger.after [:halt, :suspend, :destroy], :stdout => true do
            system('sudo pfctl -F all -f /etc/pf.conf >/dev/null 2>&1; echo "Removing Port Forwarding (80 => 8000)\nRemove Port Forwarding (443 => 44300)"')
          end
       end

       if OS.windows?
            config.trigger.after [:up, :reload, :provision], :stdout => true do
                system('netsh interface portproxy add v4tov4 listenport=80 listenaddress=192.168.0.212 connectport=80 connectaddress=192.168.10.10')
                system('netsh interface portproxy add v4tov4 listenport=80 listenaddress=0.0.0.0 connectport=80 connectaddress=192.168.10.10')
                system('netsh interface portproxy add v4tov4 listenport=443 listenaddress=192.168.0.212 connectport=443 connectaddress=192.168.10.10')
                system('netsh interface portproxy add v4tov4 listenport=443 listenaddress=0.0.0.0 connectport=443 connectaddress=192.168.10.10')
            end
            config.trigger.after [:halt, :suspend, :destroy], :stdout => true do
                system('netsh interface portproxy delete v4tov4 listenport=80 listenaddress=192.168.0.212')
                system('netsh interface portproxy delete v4tov4 listenport=80 listenaddress=0.0.0.0')
                system('netsh interface portproxy delete v4tov4 listenport=443 listenaddress=192.168.0.212')
                system('netsh interface portproxy delete v4tov4 listenport=443 listenaddress=0.0.0.0')
            end
       end
    end
end

module OS
    def OS.windows?
        (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
    end

    def OS.mac?
        (/darwin/ =~ RUBY_PLATFORM) != nil
    end

    def OS.unix?
        !OS.windows?
    end

    def OS.linux?
        OS.unix? and not OS.mac?
    end
end
