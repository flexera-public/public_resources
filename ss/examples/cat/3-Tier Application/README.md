## 3-Tier Application

This example shows a complex CAT file that is used to launch a 3-tier application stack consisting of a load balancer, application server, and database server. It launches the infrastructure in parallel and then coordinates the execution of configuration management scripts to enable the application. It presents the user with information about the application so they can access the application and the load balancer.

#### Capabilities demonstrated
* Outputs
* Mappings
* Operations
* Definitions

#### Functions used
* join
* find

#### Cloud Workflow concepts
* Concurrency
* Task labels

[[[
[CAT](v14_3tier.cat.rb)
]]]
