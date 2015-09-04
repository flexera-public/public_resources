## DNS Made Easy

This plugin provides support for (DNS Made Easy)[http://www.dnsmadeeasy.com/] A records, allowing you to incorporate these into a CAT and use them in building your application.

The plugin service is implemented using the [Praxis framework](http://praxis-framework.io/) and can easily be deployed as a Docker container. Note that this plugin is **for example purposes only** and should not be used in a production environment.

### Deploying

The easiest way to deploy this app is to use a RightScale ServerTemplate to install docker and deploy the app. The following steps walk you through this process.
1. Log in to [RightScale](https://my.rightscale.com)
2. Import the [Docker Tech Demo ServerTemplate](http://www.rightscale.com/library/server_templates/Docker-Technology-Demo/lineage/53723)
3. Create a 

### Required permissions

Since all actions defined in these helpers only require `actor` privileges, no additional explicit permissions are required.

[[[
[RCL](run_executable.rcl.rb)
]]]
