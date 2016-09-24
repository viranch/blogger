## Blog

Collection of automation code to start a wordpress blog on AWS

### Dependencies

You only need to have a working docker setup on this machine.

### Requirements

You will need AWS credentials to use this automation. Get the "access key" and "secret key" for your account, and copy the `dev.tfvars.sample` to `$ENV.tfvars` and fill in the 2 values. You also need to paste your SSH public key to the file that will be used to run deployment configuration.

### Run

`Usage: start.sh <app> <environment> <num_servers> <server_size>`

For example:
```
./start.sh hello_world dev 2 t1.micro
```
