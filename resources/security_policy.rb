resource_name :windows_security_policy

default_action :configure

# property :secedit_template, String, required: false, default: 'C:\Windows\security\templates\chefNewPolicy.inf'
property :secedit_template, String, required: false
property :database, String, required: false, default: 'C:\Windows\security\database\chef.sdb'
property :log_location, String, default: 'C:\Windows\security\logs\chef-secedit.log'

action :configure do
  if node['platform'] == 'windows'
    #template "#{secedit_template}" do
    #  source 'policy.inf.erb'
    #  cookbook 'windows-security-policy'
    #  action :create
    #end

    execute 'Configure security database' do
      command "Secedit /configure /db #{database} /cfg #{secedit_template} /log #{log_location}"
      live_stream true
      action :run
    end
  else
    Chef::Log.info "#{@current_resource} is only for a Windows platform"
  end
end

action :export do
  if node['platform'] == 'windows'
    execute 'Export security database to inf file' do
      command "Secedit /export /db #{database} /cfg #{secedit_template} /log #{log_location}"
      live_stream true
      action :run
    end
  else
    Chef::Log.info "#{@current_resource} is only for a Windows platform"
  end
end

action :import do
  if node['platform'] == 'windows'
    template "#{template}" do
      source 'policy.inf.erb'
      action :create
    end

    execute 'Import and create security database' do
      command "Secedit /import /db #{database} /cfg #{secedit_template} /log #{log_location} /overwrite"
      live_stream true
      action :run
    end
  else
    Chef::Log.info "#{@current_resource} is only for a Windows platform"
  end
end
