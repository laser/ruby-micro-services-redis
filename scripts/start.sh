if [ -z "$PORT" ]
then
  PORT=5000
fi

bundle exec rails s -p $PORT 2>&1 &
cd services/user_service; DB_YML_PATH=../../config/database.yml bundle exec ruby ./app.rb -p 3001
