## Various Utilities

This set of RCL code provides helper functions for working with RightScale resources. It includes a `sys_log` function that sends message to AuditEntries, a function to retrieve the ID of this CloudApp, a simple function that concurrently terminates all resources in the CloudApp's deployment, and more. Of particular interest is the `credential_get_value` function which returns the value of a credential.

### Required permissions

Since all actions defined in these helpers only require `actor` privileges, no additional explicit permissions are required.

[[[
[RCL](sys.rcl.rb)
]]]
