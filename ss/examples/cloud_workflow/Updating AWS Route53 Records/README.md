## Updating AWS Route53 Records

This set of RCL code provides helper functions for updating [AWS Route 53](http://aws.amazon.com/route53/) recordsets. It allows you to update a recordset and check on update status. 

### Required permissions

When using this code with the default behavior of getting the AWS creds from RightScale Credentials store, this code requires explicit permissions on the CAT since most users will not have 'admin' role to get those values:

~~~ ruby
permission "credentials" do
  actions "rs.index", "rs.show"
  resources "rs.credential"
end
~~~

[[[
[RCL](route53.rcl.rb)
]]]
