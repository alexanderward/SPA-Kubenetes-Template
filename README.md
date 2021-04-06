# Install (All Cross Platform)
- `minikube` - Local Kubernetes cluster - (https://minikube.sigs.k8s.io/docs/start/)
- `skaffold` - Skaffold is a command line tool that facilitates continuous development for Kubernetes-native applications (https://skaffold.dev/docs/install/)

# Developer Environment

## Setup
In order to deploy your stack, it must have it's secrets configured.
- `cd deployments/kubernetes`
- `python generate_secrets.py`
- Follow the prompts and supply required information about your stack.

## Run
 Available stacks are `local, dev, staging, prod` 
- `./run.sh <stack>`
    - `local` will run minikube for a local cluster (development mode)
    - `dev, staging, prod` will create the stack normally

## Debugging
#### Pod debugging
| Commands                                         | Description                                                            |
|--------------------------------------------------|------------------------------------------------------------------------|
| `./debug --pod=<pod_name> --attach`              | Attach to TTY - interactive debugging (ipdb)                           |
| `./debug --pod=<pod_name> --command="<comamnd>"` | Sending commands to the pod                                            |
| `./debug --pod=<pod_name> --restart`             | Restarts Pod                                                           |
| `./debug --pod=<pod_name> --logs`                | Tails the logs of the pods                                             |
| `./debug --wipedb`                               | Wipe the Database for a fresh state; *Good to do after a pull or merge |


Examples:
- `./debug.sh --pod=django --attach`
- `./debug.sh --pod=django --restart`
- `./debug.sh --pod=django --logs`
- `./debug.sh --pod=django --command="/bin/sh"`
- `./debug.sh --pod=django --command="python manage.py shell"`
- `./debug.sh --pod=redis --command="/bin/bash"`
- `./debug.sh --pod=postgres --command="/bin/bash"`

## IDE Interpreter Steps

### Pycharm
#### Automated Sync via SSH Interpreter
- `File -> Settings -> Project -> Project Interpreter  -> Cog -> Add -> SSH Interpreter`
    - Host: `localhost`
    - Port: `2222`
    - User: `root`
    - Password: `root`
    - Interpreter: `/app/backend/service/local/remote_interpreter/python_env.sh`

### VIM
- `./debug.sh --pod=django --command="/bin/sh"` - Connect to the Django container directly to code.
- Code is synced via the `minikube` volume in realtime.  Your code changes will be reflected on the host and will not be lost.

