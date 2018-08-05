windows_security_policy 'Local Policy' do
    secedit_template 'C:\Windows\security\templates\chefNewPolicy.inf'
    database 'C:\Windows\security\database\chef.sdb'
    action :configure
end
