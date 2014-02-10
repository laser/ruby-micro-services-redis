if [ -z "$PORT" ]
then
  PORT=5000
fi

bundle exec rails s -p $PORT
