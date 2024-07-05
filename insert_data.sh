#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE teams, games")
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WGOALS OGOALS
do
  #Insert teams
  if [[ $WINNER != winner ]]
  then
    echo -e "$WINNER\n$OPPONENT" | while read TEAM
    do
      #Check if team exist or not
      CHECK=$($PSQL "SELECT name FROM teams WHERE name = '$TEAM'")
      if [[ -z $CHECK ]]
      then
        INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$TEAM')")
      fi
    done
  fi

  #Insert games
  if [[ $YEAR != year ]]
  then
    #Get teams' id
    WID=$($PSQL "SELECT team_id FROM teams WHERE name = '$WINNER'")
    OID=$($PSQL "SELECT team_id FROM teams WHERE name = '$OPPONENT'")
    INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR,'$ROUND', $WID, $OID, $WGOALS, $OGOALS)")
  fi
done