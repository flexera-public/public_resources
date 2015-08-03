name '3 Tier Application with MySQL & PHP'
rs_ca_ver 20131202
short_description 'Provides a 3-tier application consisting of 1 HAProxy load balancer, 1 application server, and a master-slave database pair'
long_description 'This CloudApplication uses the RightScale v14 ServerTemplates to create and configure a 3-tier web application.   

## Supported Application Engines
- PHP

## Environment Configurations
- Staging (full 3-tier as described above)
- Dev (faster booting with no slave database and no regular master backups)'

output do
  label "Application URL"
  category "General"
  value join(["http://",@srv_lb.public_ip_address,"/dbread"])
  description "URL for the DB test for the application"
end

output do
  label "HAProxy Status"
  category "General"
  value join(["http://",@srv_lb.public_ip_address,"/haproxy-status"])
  description "HAProxy Status page showing connected app servers and their status"
end

mapping "app_params" do {
  "PHP" => {
    "st_href" => "/api/server_templates/336992003",
    "mci_href" => "/api/multi_cloud_images/310846003",
    "repo_revision" => "unified_php",
  },  
} end

resource 'srv_db_master', type: 'server' do
  name 'Database Master'
  cloud_href "/api/clouds/2705"
  security_groups '3tier-all-oregon'
  ssh_key_href '/api/clouds/6/ssh_keys/26Q6416KSPUC2'
  server_template find('Database Manager for MySQL (v14) STAGING', revision: 6) 
  multi_cloud_image find("RightImage_CentOS_6.5_x64_v14.0.0_RC4_vSphere_STAGING", revision: 1)
  inputs do {
    'rs-mysql/application_database_name' => 'text:app_test',
    'rs-mysql/application_password' => 'cred:DBAPPLICATION_PASSWORD',
    'rs-mysql/application_username' => 'cred:DBAPPLICATION_USER',
    'rs-mysql/dns/master_fqdn' => 'text:utpal-master.rightscaleblue.com',
    'rs-mysql/dns/secret_key' => 'cred:DME_RIGHTSCALEU_PASS',
    'rs-mysql/dns/user_key' => 'cred:DME_RIGHTSCALEU_USER',
    'rs-mysql/lineage' => 'text:ryan-' + ident,
    'rs-mysql/server_repl_password' => 'cred:DBREPLICATION_PASSWORD',
    'rs-mysql/server_root_password' => 'cred:DBADMIN_PASSWORD',
  } end
end

resource 'srv_lb', type: 'server' do
  name 'Load Balancer with HAProxy - ' + ident
  like @srv_db_master # Inherit the cloud stuff

  server_template find('Load Balancer with HAProxy Alpha (v14.0.0)', revision: 8)
  multi_cloud_image find("RightImage_CentOS_6.5_x64_v14.0.0_RC4_vSphere", revision: 2)
end

resource 'srv_app', type: 'server' do
  name 'PHP App Server - ' + ident
  like @srv_db_master # Inherit the cloud stuff
  server_template find('PHP App Server Alpha (v14.0.0)', revision: 6) 
  multi_cloud_image find("RightImage_CentOS_6.5_x64_v14.0.0_RC4_vSphere", revision: 2)

  inputs do {
    'rs-application_php/application_name' => 'text:default',
    'rs-application_php/database/host' => join(['env:MySQL Database - ' + ident,':,PRIVATE_IP']),
    'rs-application_php/database/password' => 'cred:DBAPPLICATION_PASSWORD',
    'rs-application_php/database/schema' => 'text:app_test',
    'rs-application_php/database/user' => 'cred:DBAPPLICATION_USER',
    'rs-application_php/scm/repository' => 'text:git://github.com/rightscale/examples.git',
    'rs-application_php/scm/revision' => 'text:unified_php',
  } end

end

operation "launch" do
  description "Provisions the 3-tiers of a 3-tier app"
  definition "launch_3_tier_v13_3"
end

operation "Update application code" do
  description "Update the application code with the latest from the source"
  definition "update_app_code"
end

operation "Restart Apache" do
  description "Restart Apache on the app server"
  definition "restart_apache"
end

# Launches a 3-tier application stack based on RightScale's 3-tier architecture.
#
#
define launch_3_tier_v13_3(@srv_lb, @srv_app, @srv_db_master) return @srv_lb, @srv_app, @srv_db_master do
    
    task_label("Launch 3-Tier Application")

    concurrent return @srv_lb, @srv_app, @srv_db_master do
      
      sub task_name:"Launch LB Tier" do
        task_label("Launching LB tier")
        provision(@srv_lb)
        task_label("Initializing LB")
        call run_recipe(@srv_lb, "rs-haproxy::tags")
        call run_recipe(@srv_lb, "rs-haproxy::collectd")
        call run_recipe(@srv_lb, "rs-haproxy::frontend")
      end
      
      sub task_name:"Launch DB Tier" do
        task_label("Launching Master DB")
        provision(@srv_db_master)
        task_label("Initializing Master DB")
        call run_recipe(@srv_db_master, "rs-mysql::collectd")
      end

      sub task_name:"Launch App Tier" do
        task_label("Launching App Tier")
        sleep(60) # Give the DB a chance to at least get created, App server needs its Private PRIVATE_IP
        provision(@srv_app)
        call run_recipe(@srv_app, "rs-haproxy::tags")
        call run_recipe(@srv_app, "rs-haproxy::collectd")
        call run_recipe(@srv_app, "rs-haproxy::application_backend ")        
      end
    
    end
       
end

define update_app_code(@srv_app) do
  task_label("Updating code on application server")
  call run_recipe(@srv_app, "app::do_update_code")
end

define restart_apache(@srv_app) do
  task_label("Restart Apache on App Servers")
  call run_recipe(@srv_app, "web_apache::do_restart")
end

# Helper definition, runs a recipe on given server, waits until recipe completes or fails
# Raises an error in case of failure
define run_recipe(@target, $recipe_name) do
  @task = @target.current_instance().run_executable(recipe_name: $recipe_name, inputs: {})
  sleep_until(@task.summary =~ "^(completed|failed)")
  if @task.summary =~ "failed"
    raise "Failed to run " + $recipe_name
  end
end