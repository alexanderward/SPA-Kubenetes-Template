red=$'\e[1;31m'
grn=$'\e[1;32m'
yel=$'\e[1;33m'
blu=$'\e[1;34m'
mag=$'\e[1;35m'
cyn=$'\e[1;36m'
end=$'\e[0m'

echo -ne "${yel}[ + ] Setting up SSH for remote Interpreter use \n${end}"
/usr/sbin/sshd
export -p > local/remote_interpreter/env_var.sh

echo -ne "${yel}[ + ] Collect Static Files for Admin Panel \n${end}"
python manage.py collectstatic --noinput

echo -ne "${yel}[ + ] Migrating Database \n${end}"
python manage.py migrate --noinput

echo -ne "${yel}[ + ] Starting server \n${end}"
python manage.py runserver 0.0.0.0:8000