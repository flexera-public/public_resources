name "SAMPLE - try different datacenter launches"
rs_ca_ver 20131202
short_description "This is my first CloudApp.  It will launch a single Linux Server"


resource "my_first_server", type: "server" do
  name "My First Server"
  cloud "EC2 us-west-2"
  security_group_hrefs "/api/clouds/6/security_groups/3BLM6P9N72LQ0"
  server_template find("Puppet Client Beta (v13.5)")
  inputs do {
  	'puppet/client/puppet_master_address' => 'text:value1'
  } end
end

operation "launch" do
	definition "launch"
end

define launch(@my_first_server) do
	call provision_with_datacenter_retry(@my_first_server, 1) 
end


define provision_with_datacenter_retry(@server, $launch_count)  do
  sub on_error: handle_provision_error($launch_count) do
    provision(@server)
  end
end

define handle_provision_error($launch_count) do
  call sys_log("Provision error caught on launch count " + $launch_count, {detail: to_s(to_object(@server))})

  # If we've tried more than 5 times, or if the error message is not indicative of a datacenter issue
  # Note: the error checked for here could happen in more cases than just a datacenter issue. In that 
  #  case, this will likely cause the same error 5 times, but then fail.
  if $launch_count > 5 || $_error["message"] !~ /Expected state 'operational' but got 'inactive'/
    $_error_behavior = "raise"
  else
    $launch_count = $launch_count + 1
    call set_next_datacenter(@server) retrieve @server
    call provision_with_datacenter_retry(@server, $launch_count) 
    $_error_behavior = "skip"
  end
end

define set_next_datacenter(@server_decl) return @server_decl do

  # Get the cloud from the current declaration and all of its datacenters
  $server_obj = to_object(@server_decl)
  @cloud = rs.get(href: $server_obj["fields"]["cloud_href"])
  @dcs = @cloud.datacenters()

  # Get the datacenter_href of the declaration (even if it's null)
  $datacenter_href = $server_obj["fields"]["datacenter_href"]
  call sys_log("Current datacenter = " + to_s($datacenter_href), {})

  # If it is null, it wasn't set, so set it to the first datacenter of the cloud
  if $datacenter_href == null 
    call sys_log("Datacenter null, setting to: " + @dcs.href[][0], {})
    $server_obj["fields"]["datacenter_href"] = @dcs.href
  else
    # Otherwise, loop through all of the DCs in the cloud looking for this href and 
    #  set the declaration to the NEXT href (or the first if we're at the end)
    $index = 0
    while $index < size(@dcs) do
      if @dcs.href[][$index] == $datacenter_href
        if ($index + 1) < size(@dcs) 
          call sys_log("Setting datacenter to: " + @dcs.href[][$index+1] , {})
          $server_obj["fields"]["datacenter_href"] = @dcs.href[][$index+1]
        else
          call sys_log("Setting datacenter to: " + @dcs.href[][0], {})
          $server_obj["fields"]["datacenter_href"] = @dcs.href
        end
      end
      $index = $index + 1
    end
  end

  @server_decl = $server_obj
end    

define sys_log($summary,$options) do
  $log_default_options = {
    detail: "",
    notify: "None",
    auditee_href: @@deployment.href
  }

  $log_merged_options = $options + $log_default_options
  rs.audit_entries.create(
    notify: $log_merged_options["notify"],
    audit_entry: {
      auditee_href: $log_merged_options["auditee_href"],
      summary: $summary,
      detail: $log_merged_options["detail"]
    }
  )
end  