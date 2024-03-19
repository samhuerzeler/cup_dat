#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

$($PSQL "TRUNCATE teams, games")

cat games.csv | while IFS="," read YEAR ROUND TEAM OPPONENT TEAMGOALS OPPONENTGOALS
do
  if [[ $TEAM != winner ]]

  then
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$TEAM'")
    if [[ -z $TEAM_ID ]]
    then
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$TEAM')")
      echo $INSERT_TEAM_RESULT
    fi

    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    if [[ -z $OPPONENT_ID ]]
    then
      INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      echo $INSERT_OPPONENT_RESULT
    fi

    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$TEAM'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $TEAM_ID, $OPPONENT_ID, $TEAMGOALS, $OPPONENTGOALS)")
    echo $INSERT_GAME_RESULT
  fi
done
