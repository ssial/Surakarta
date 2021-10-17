require_relative'./player.rb'
require_relative'./BoardGame.rb'
require 'colorize'

class Match
  ENUM_MATCH_TYPES = :totalGames, :totalPoints
  ENUM_MATCH_STATES = :inProgress, :readyToStart, :done

  def initialize(players, board, matchType, limit)
    if ENUM_MATCH_TYPES.include?(matchType)
      @matchType = matchType
    else
      raise "Invalid matchType"
    end
    @limit = limit
    @currentGame = 1
    @state = ENUM_MATCH_STATES[1]
    @turn = players[0]
    @player1 = players[0]
    @player2 = players[1]
    @player1.setPlayerMatch(self)
    @player2.setPlayerMatch(self)
    @board = board
  end

  #Starts up the game, assigns pieces to the players, and prompts player 1 to start
  def start()
    pieceArray = @board.setup()
    #Assigns pieces to players
    @state = ENUM_MATCH_STATES[0]
    @player2.setPieces(pieceArray[0])
    @player1.setPieces(pieceArray[1])
    @turn = @player1
    @board.printBoard()
    @player1.promptAction()

  end

  #Ends a match, checks to see if the the conditions to win have been reached,
  #if they have print out the winner, if no winner yet then call reset
  def endGame()
    @player1.tally()
    @player2.tally()

    print "Game  #{@currentGame} is over, tally for each player\n"
    print "Player1:   #{@player1.getTotalPoints()}  Player2:   #{@player2.getTotalPoints()}\n"
    if (@matchType == ENUM_MATCH_TYPES[0])
      if(@currentGame == @limit)
        @turn = nil
        @state = ENUM_MATCH_STATES[2]
      end
    elsif(@matchType == ENUM_MATCH_TYPES[1])
      if(@player1.getTotalPoints() >= @limit || @player2.getTotalPoints() >= @limit)
        @turn = nil
        @state = ENUM_MATCH_STATES[2]
      end
    end

    if (@state != ENUM_MATCH_STATES[2])
      reset()
    else
      if (@player1.getTotalPoints > @player2.getTotalPoints)
        print(@player1.getName() + " has won")
      elsif (@player2.getTotalPoints > @player1.getTotalPoints)
        print(@player2.getName() + " has won")
      else
        print("It's a tie")
      end

    end

  end

  # Shows the player the list of valid moves for the piece they select then has them select a piece
  def processSelection(piece)
    arrayValidMoves = @board.getValidActions(piece)
    if (arrayValidMoves == {})
      print("This piece has no valid actions \n")
      @board.printBoard()
      @turn.promptAction()

    else
      print("Below are the list of coordinates you can move\n")
      print(arrayValidMoves)
      print("\n")
      hasCoordinates = nil
      spaceToMove = nil
      while hasCoordinates == nil
        print(@turn.getName + " please enter the coordinates of where you would like to move your piece (X then Y no space): ")
        coordinates = gets.chomp
        arrayValidMoves.each{|value|
          if value[0] == coordinates
            hasCoordinates = true
            spaceToMove = coordinates
          end
        }
      end
      @turn.move(spaceToMove)
    end
  end

  #Calls the board to move the piece
  def processMove(piece, position)
    removedPiece = @board.movePiece(piece, position)
    if removedPiece==nil

    else
      if @turn.getName()==@player2.getName()
        @player1.deletePiece(removedPiece)
      else
        @player2.deletePiece(removedPiece)
      end
    end
    checkForWin()
  end

  #Checks if a player has won
  def checkForWin()
    if (@player1.getNumRemainingPieces() == 0 || @player2.getNumRemainingPieces() == 0)
      endGame()
    else
      switchTurn()
      @board.printBoard()
      @turn.promptAction()

    end
  end

  #Resets the board state, calls board clear and setup, increases the current
  #game counter, and sets the turn to player1 and prompts action
  def reset()
    @board.clear()
    @board.setup()
    @currentGame = @currentGame + 1;
    @turn = @player1
    @board.printBoard()
    @turn.promptAction()

  end

  #switches player turn
  def switchTurn()
    if @turn == @player1
      @turn = @player2
    else
      @turn = @player1
    end
  end

end

print ("Please enter the name for player 1: " .colorize(:magenta))
player1Name = gets.chomp
print ("Please enter the name for player 2: " .colorize(:cyan))
player2Name = gets.chomp

if (player1Name == player2Name)
  print"Player's can't have the same name"
else
  match = Match.new([Player.new(player1Name), Player.new(player2Name)], GameBoard.new(6,6), :totalGames, 1)
  match.start()
end
