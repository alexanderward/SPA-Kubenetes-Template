set -e
red=$'\e[1;31m'
grn=$'\e[1;32m'
yel=$'\e[1;33m'
blu=$'\e[1;34m'
mag=$'\e[1;35m'
cyn=$'\e[1;36m'
end=$'\e[0m'

find_in_array() {
  local word=$1
  shift
  for e in "$@"; do [[ "$e" == "$word" ]] && return 0; done
  return 1
}

if [[ -z "$1" ]]; then
   STACK="local"
else
   STACK=$1
fi
stacks=("local" "dev" "staging" "prod")
find_in_array ${STACK} "${stacks[@]}" ||

if [[ $? = 1 ]]; then
   stackString=$(IFS=, ; echo "${stacks[*]}")
   echo -ne "${red}[x] ${STACK} is not a valid stack. Choose from: ${stackString}  \n${end}"
   exit
fi



echo -ne "${grn}[+]Starting Minikube\n${end}"
minikube start --v=4 --mount --mount-string="$PWD:/local-data/"  --cpus 4 --memory 8192

echo -ne "${grn}[+]Cleaning up Skaffold\n${end}"
skaffold delete

echo -ne "${grn}[+]Starting Skaffold - ${STACK}\n${end}"
if [[ ${STACK} = "local" ]]; then
   skaffold dev --no-prune=false --cache-artifacts=false -p local --port-forward --trigger polling #-vtrace
else
  skaffold run --no-prune=false --cache-artifacts=false -p ${STACK}
fi