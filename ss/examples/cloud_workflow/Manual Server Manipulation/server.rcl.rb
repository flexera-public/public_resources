# Launches a server and waits for it to become "operational" or "stranded"
#
# @param @server [ServerResourceCollection] The server(s) to launch and wait for
# @param $timeout [String] the desired timeout in the form described in RCL
#   documentation.  Also supports "none" for no timeout
#
# @see http://support.rightscale.com/12-Guides/Cloud_Workflow_Developer_Guide/04_Attributes_and_Error_Handling#Timeouts RCL Documentation
define server_launch_and_wait(@server, $timeout) do
  @server.launch()
  if $timeout == "none"
    sleep_until(@server.state =~ "^(operational|stranded.*|terminated|inactive)")
  else
    sub timeout: $timeout do
      sleep_until(@server.state =~ "^(operational|stranded.*|terminated|inactive)")
    end
  end
end

# Updates an input value of a server declaration
#
# @param @server [ServerResourceCollection] The server on which to update the inputs
# @param $input_name [String] the name of the input to update
# @param $input_value [String] the value to set the input to - make sure to follow
#   "Inputs 2.0" syntax (text values should start with "text:" for example)
#
define update_input_value(@server, $input_name, $input_value) return @server do
	$server_hash = to_object(@server)
	$server_hash["fields"]["inputs"][$input_name] = $input_value
	@server = $server_hash
end