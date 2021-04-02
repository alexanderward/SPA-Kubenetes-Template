## Install (All Cross Platform)
- `docker` - OS-level virtualization to deliver software in packages called containers - (https://docs.docker.com/get-docker/)
- `minikube` - Local Kubernetes cluster - (https://minikube.sigs.k8s.io/docs/start/)
- `skaffold` - Skaffold is a command line tool that facilitates continuous development for Kubernetes-native applications (https://skaffold.dev/docs/install/)
- `kustomize` - simplifies the use of off-the-shelf applications. Now, built into `kubectl as apply -k`.

# Development Environment

## Setup
In order to deploy your stack, it must have it's secrets configured.
- `cd deployments/kubernetes`
- `python generate_secrets.py`
- Follow the prompts and supply required information about your stack.

## Run
 Available stacks are `local, dev, staging, prod` 
- `./run.sh <stack>`
    - `local` will run skaffold in development mode allowing port-forwarding and filesync
    - `dev, staging, prod` will create the stack normally

## Debugging
#### Pod debugging
For the purposes of interactive debugging:
- `./debug --pod=<pod_name> --attach`

For the purposes of sending commands to the pod:
- `./debug --pod=<pod_name> --command="my command"`

Examples:
- `./debug.sh --pod=django --attach`
- `./debug.sh --pod=django --command="/bin/sh"`
- `./debug.sh --pod=django --command="python manage.py shell"`
- `./debug.sh --pod=redis --command="/bin/bash"`
- `./debug.sh --pod=postgres --command="/bin/bash"`

#### Wiping Database Data
The postgres database data is persisted in our `minikube` cluster.
- `ssh minikube -- sudo rm -rf /data/pgdata`
- Then restart the `./run.sh` to build the new database.

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
#### Option 1
- `./debug.sh --pod=django --command="/bin/sh"` - Connect to the Django container directly to code.
- Code is synced via the `minikube` volume in realtime.  Your code changes will be reflected on the host and will not be lost.

#### Option 2
- Install `sshpass` or configure a way to pass your password to `ssh`
- Create an alias:
    * `alias pythonremote='sshpass -p "root" ssh root@127.0.0.1 -p2222 "/app/backend/service/local/remote_interpreter/python_env.sh -u"'`
- Issue a command:
    * `pythonremote /app/deployments/kubernetes/generate_secrets.py`
    * `pythonremote /app/backend/service/manage.py shell`


