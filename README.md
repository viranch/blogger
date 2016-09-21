## Blog

Collection of automation code to start a wordpress blog on AWS

### Requirements

You will need AWS credentials to use this automation. Get the "access key" and "secret key" for your account, and copy the `dev.tfvars.sample` to `$ENV.tfvars` and fill in the 2 values.

### Run

`Usage: start.sh <app> <environment> <num_servers> <server_size>`

For example:
```
./start.sh hello_world dev 2 t1.micro
```
