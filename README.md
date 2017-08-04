# tf-nomad

## Description
This repo contain terrraform code to build a nomad stack  :
- nomad controller
- nomad slave


You will need to create a file named : terraform.tfvars to store sensitives variables.
Please see terraform.tfvars.example.

## Limitation

- Currently one stack so any change can bring down the infrastructure.

## TODO

- Create separate stacks for instances to avoid down time during change.
