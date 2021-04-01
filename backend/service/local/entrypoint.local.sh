echo "[ + ] Setting up SSH for remote Interpreter use"
/usr/sbin/sshd
export -p > local/remote_interpreter/env_var.sh


echo "[ + ] Copying Dependencies for IDE use"
rm local/venv.7z
cp /tmp/venv.7z local/venv.7z

echo "[ + ] Collect Static"
python manage.py collectstatic --noinput

echo "[ + ] Starting server"
python manage.py runserver 0.0.0.0:8000