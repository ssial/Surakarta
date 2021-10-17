class Player
  def initialize(name)
    @name = name
    @match = nil
    @pieces = nil
    @selectedPiece = nil
    @totalPoints = 0
  end

  #returns the total points of the player
  def getTotalPoints()
    @totalPoints
  end

  # returns the name of the player
  def getName()
    @name
  end

  #sets the pieces of the player
  def setPieces(pieces)
    @pieces = pieces
  end

  #selects a piece and calls the match process selection
  def select(piece)
    @selectedPiece = piece
    @match.processSelection(@selectedPiece)
  end

  #prompts the user to select a piece to pick up
  def promptAction()
    hasCoordinates = nil
    pieceToPickup = nil
    while hasCoordinates == nil
      @pieces.each {|pie|
        x = pie.spacePosition["x"]
        y = pie.spacePosition["y"]
        str = x.to_s + y.to_s
        print(str)

        print("\n")

      }
      print("\n" + @name + " please enter the coordinates of piece you wish to pick up (X then Y no space): ")
      coordinates = gets.chomp

      @pieces.each {|pie|
        x = pie.spacePosition["x"]
        y = pie.spacePosition["y"]
        str = x.to_s + y.to_s

        if str == coordinates
          hasCoordinates = true
          pieceToPickup = pie
          break
        end
      }
    end

    select(pieceToPickup)
  end

  #calls match to move a piece
  def move(position)
    @match.processMove(@selectedPiece, position)
  end

  #sets the match
  def setPlayerMatch(match)
    @match = match
  end

  #Test when piece is added
  # def deletePiece(piece)
  #   pieceToDelete = nil
  #   @pieces.each {|pie|
  #   x = pie.spacePosition["x"]
  #   y = pie.spacePosition["y"]
  #   str = x.to_s + y.to_s

  #     if pie.getSpace().getPosition() == piece.getSpace().getPosition()
  #       pieceToDelete = pie
  #       break
  #     end
  #   }
  #   if pieceToDelete != nil
  #     @pieces.delete(pieceToDelete)
  #   end
  # end
  def deletePiece(piece)
    pieceToDelete = nil
    @pieces.each {|pie|
      x = pie.spacePosition["x"]
      y = pie.spacePosition["y"]
      str1 = x.to_s + y.to_s
      x2 = piece.spacePosition["x"]
      y2 = piece.spacePosition["y"]
      str2 = x2.to_s + y2.to_s
      if str1 == str2
        pieceToDelete = pie
        break
      end
    }
    if pieceToDelete != nil
      @pieces.delete(pieceToDelete)
    end
  end

  #gets the remaining number of pieces
  def getNumRemainingPieces()
    @pieces.length()
  end

  #tallys up the points of the game
  def tally
    @totalPoints = @totalPoints + @pieces.length()
  end

end
