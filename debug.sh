red=$'\e[1;31m'
grn=$'\e[1;32m'
yel=$'\e[1;33m'
blu=$'\e[1;34m'
mag=$'\e[1;35m'
cyn=$'\e[1;36m'
end=$'\e[0m'


for i in "$@"
    do
        case $i in
            --pod=*)
            POD_NAME="${i#*=}"
            ;;
            --attach)
            ATTACH=true
            ;;
            --command=*)
            COMMAND=true
            COMMAND_VALUE="${i#*=}"
            ;;
            --logs)
            LOGS=true
            ;;
            --wipedb)
            WIPE_DB=true
            ;;
            --restart)
            RESTART=true
            ;;
            *)
            ;;
        esac
done
if [[ "$WIPE_DB" = true ]]; then
  minikube ssh "sudo rm -rf /data/postgres"
 ./debug.sh --pod=postgres --restart
 ./debug.sh --pod=django --restart
 exit
fi


if [[ -z ${POD_NAME} ]]; then
    echo -ne "${red}[x]You must include a pod name.  \nExample: ./debug.sh --pod=django \n${end}"
   exit
fi

echo -ne "${grn}[+]Searching for Pod: ${POD_NAME}\n${end}"

POD=`kubectl get pods --selector=app=${POD_NAME} -o name`
if [[ -z ${POD} ]]; then
   echo -ne "${red}[-]Pod Not Found: ${POD_NAME}\n${end}"
   exit
else
    echo -ne "${yel}[+]Pod Found: ${POD}\n${end}"
fi

if [[ "$ATTACH" = true ]] ; then
    echo -ne "${yel}[+]Attaching to Pod: ${POD}\n${end}"
    kubectl attach -it ${POD}
elif [[ "$COMMAND" = true ]] ; then
    echo -ne "${yel}[+]Sending command \`${COMMAND_VALUE}\` to Pod: ${POD}\n${end}"
    kubectl exec --stdin --tty ${POD} -- ${COMMAND_VALUE}
elif [[ "$RESTART" = true ]] ; then
    echo -ne "${yel}[+]Restarting Pod: ${POD}\n${end}"
    kubectl delete ${POD}
elif [[ "$LOGS" = true ]] ; then
    echo -ne "${yel}[+]Getting Pod Logs: ${POD}\n${end}"
     kubectl logs ${POD} -f
else
    echo -ne "${red}[-]Action not set.  Choose attach or command.\nExamples:\n ./debug.sh --pod=${POD_NAME} --attach\n ./debug.sh --pod=${POD_NAME} --command=/bin/bash\n${end}"
   exit
fi
