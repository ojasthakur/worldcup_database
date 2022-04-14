#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

#clear database
$($PSQL "TRUNCATE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
	#CHECK IF YOU ARE AT THE FIRST LINE OF THE FILE
	if [[ $WINNER != "winner" && $OPPONENT != "OPPONENT" ]]
	then
		#INSERT ALL THE TEAMS INTO TEAMS TABLE - ADD UNIQUE TEAMS CONSIDERING EACH GAME
		#echo -e "\n Winner: $WINNER, Opponent=$OPPONENT"


		#check db for winner
		WINNER_ID=$($PSQL "SELECT team_id from teams where name='$WINNER'")
		#if not found
		if [[ -z $WINNER_ID ]]
		then
			#insert winner
			INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
			if [[ $INSERT_WINNER_RESULT == 'INSERT 0 1' ]]
			then
				echo -e "Inserted Winner into teams $WINNER"
			fi
			#GET NEW WINNDER_ID
			WINNER_ID=$($PSQL "SELECT team_id from teams where name='$WINNER'")
		fi


		#check db for opponent
		OPPONENT_ID=$($PSQL "SELECT team_id from teams where name='$OPPONENT'")
		#if not found
		if [[ -z $OPPONENT_ID ]]
		then
			#insert opponent
			INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
			if [[ $INSERT_OPPONENT_RESULT == 'INSERT 0 1' ]]
			then
				echo -e "Inserted OPPONENT into teams $OPPONENT"
			fi
			#GET NEW OPPONENT_ID
			OPPONENT_ID=$($PSQL "SELECT team_id from teams where name='$OPPONENT'")
		fi


		
		#INSERT ALL THE GAMES INTO THE GAMES TABLE
		#INSERT GAME INTO GAMES RESULT
		
		INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS )")
		if [[ $INSERT_GAME_RESULT == 'INSERT 0 1' ]]
		then
			echo -e "\nGame inserted into games"
		fi

	fi
done

