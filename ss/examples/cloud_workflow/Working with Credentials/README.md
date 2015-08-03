## Working with RightScale Credentials

This set of RCL code provides helper functions for working with RightScale [Credential resources](http://reference.rightscale.com/api1.5/resources/ResourceCredentials.html). Of particular interest is the `credential_get_value` function which returns the value of a credential.

### Required permissions

This code requires explicit permissions on the CAT since most users will not have 'admin' role:

~~~ ruby
permission "credentials" do
  actions "rs.*"
  resources "rs.credential"
end
~~~

[[[
[RCL](credentials.rcl.rb)
]]]
