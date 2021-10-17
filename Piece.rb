# All require statements
require_relative 'space.rb'

# An instance of a game piece. Pieces have a location and an associated colour.
class Piece
  def initialize(colour)
    @colour = colour
    @space = nil
  end

  # This function gets the colour of a piece corresponding to what player the
  # piece belongs to.
  def getColour()
    return @colour
  end

  # Getter for piece.space
  def getSpace()
    if @space == nil
        return nil
    end
    return @space
  end

  # This method talks to the front end to highligh the piece
  def highlightUI(highlight)
    @colour = highlight
  end

  # Adds a space object to the piece
  def addSpace(space)
    # if space.getPiece() == nil
    #     return false
    # end
    @space = space
    return true
  end

  # Gets the position of the space variable
  def spacePosition()
    #Returns the position of the space variable or nil if no space
    if @space == nil
      return nil
    end
    return @space.getPosition()
  end

  # Gets the position of the space variable as a string
  def spacePositionAsString()
    #Returns the position of the space variable as a string or nil if no space.
    if @space == nil
        return nil
      end
      return @space.positionAsString()
  end

end
