#cd backend/service
#
#echo "[ + ] Collect Static"
#python manage.py collectstatic --noinput

echo "[ + ] Starting server"
gunicorn --bind :8000 --workers 4 service.wsgi