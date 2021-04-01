## Install (All Cross Platform)
- `docker` - OS-level virtualization to deliver software in packages called containers - (https://docs.docker.com/get-docker/)
- `minikube` - Local Kubernetes cluster - (https://minikube.sigs.k8s.io/docs/start/)
- `skaffold` - Skaffold is a command line tool that facilitates continuous development for Kubernetes-native applications (https://skaffold.dev/docs/install/)
- `kustomize` - simplifies the use of off-the-shelf applications. Now, built into `kubectl as apply -k`.

# Development Environments

## Run
- `./run.sh`

## Debugging
For the purposes of interactive debugging:
- `./debug --pod=<pod_name> --attach`

For the purposes of sending commands to the pod:
- `./debug --pod=<pod_name> --command="my command"`

Examples:
- `./debug.sh --pod=django --attach`
- `./debug.sh --pod=django --command="/bin/sh"`
- `./debug.sh --pod=django --command="ls /app"`
- `./debug.sh --pod=django --command="python manage.py shell"`

## IDE Interpreter Steps


### Pycharm
##### Automated Sync via SSH Interpreter
- `File -> Settings -> Project -> Project Interpreter  -> Cog -> Add -> SSH Interpreter`
    - Host: `localhost`
    - Port: `2222`
    - User: `root`
    - Password: `root`
    - Interpreter: `/app/backend/service/local/remote_interpreter/python_env.sh`
    - Automatically upload project files to server: `Uncheck`

##### Manual Interpreter
**Unfortunately this is a manual process that must be done every time your backend dependencies change.**
  
  The speed of extracting files to/from the `minikube` local volume  is just way too slow to be practical.
  Will look into making it an external process to make this step automated.

- Use 7Zip to unzip `backend/service/local/venv.7z`
- `File -> Settings -> Project -> Project Interpreter -> Cog -> Add` - Add or update to your unziped `env` folder