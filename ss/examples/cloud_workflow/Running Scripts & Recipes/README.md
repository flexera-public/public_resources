## Running Scripts & Recipes

This definition is a robust way to run a script or a recipe on a set of Servers or Instances. It support both types and includes many options that can be set when running the executable. It validates the input (as much as possible), and returns only once all the runs have completed or failed. It will raise an error if any of the scripts fail to run.

### Required permissions

Since all actions defined in these helpers only require `actor` privileges, no additional explicit permissions are required.

[[[
[RCL](run_executable.rcl.rb)
]]]
