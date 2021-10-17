require_relative 'piece.rb'

class Space

	#Constructor
	def initialize(length,width)
		@position = {"x" => length, "y" => width};
		@piece = nil;
	end

	# Getter for space.position
	def getPosition()
		@position;
	end

	# Getter for space.piece
	def getPiece()
		@piece;
	end

	#Highlights the space with a phantom piece (grey piece)to show it is a valid move
	def highlightSpaceUI()
		#Not implemented due to ui
	end

	# Adds a piece to the space, and updates the position of the piece
	def addPiece(piece)
		if(@piece == nil)
			@piece = piece;
			@piece.addSpace(self);
			return true;
		else
			return false;
		end
	end

	#Removes piece from space
	def removePiece
		if(@piece == nil)
			return nil;
		else
			removedPiece = @piece;
			@piece = nil;
			return removedPiece;
		end
	end

	#Returns the position as “x” + “y” as a string.
	def positionAsString()
		string = @position.values_at("x") + @position.values_at("y");
	end

end
