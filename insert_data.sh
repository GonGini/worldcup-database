#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WG OG
do
  if [[ $WINNER != "winner" ]]
  then
    # get team_id
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

    # if not found
    if [[ -z $TEAM_ID ]]
    then
      # insert team
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then 
        echo Inserted into teams, $WINNER

      fi
      # get new major_id
      TEAM_ID=$($PSQL "SELECT teams FROM teams WHERE name='$WINNER'")

    fi
  fi
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OP WG OG
do
  if [[ $OP != "opponent" ]]
  then
    # get team_id
    TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OP'")

    # if not found
    if [[ -z $TEAM_ID ]]
    then
      # insert team
      INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OP')")
      if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then 
        echo Inserted into teams, $OP

      fi
      # get new major_id
      TEAM_ID=$($PSQL "SELECT teams FROM teams WHERE name='$OP'")

    fi
  fi
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OP WG OG
do
  if [[ $YEAR != "year" ]]
  then
    # get team_id
    TEAM1_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    TEAM2_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OP'")

    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) 
                         VALUES($YEAR,'$ROUND',$TEAM1_ID,$TEAM2_ID,$WG,$OG)")
      if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
      then 
        echo Inserted into games, $WINNER 
      fi
    fi
done