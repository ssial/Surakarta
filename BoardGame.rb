#GameBoard class Represents the interface where the game is played, responsible for visualizing, validating, tracking game actions.
require_relative 'space.rb'
require_relative 'loop.rb'

class GameBoard

	#Constructor
	def initialize(length,width)
		@length = length;
		@width = width;
		@spaces = Hash.new
		#Creates spaces with the number of spaces equal to length xwidth with their values based on the corresponding coordinates
		for i in 0..5 do
			for j in 0..5 do
				@spaces["#{i}#{j}"] = Space.new(i,j)
			end
		end
		@outerloop = Loop.new(6,6,2,@spaces)
		@innerloop = Loop.new(6,6,1,@spaces)
		@validDestinations = Hash.new
	end

	#This method is called by the match method to create the pieces within at the right spaces for a game of surakarta
	def setup
		#clear all pieces from spaces. Creates 2D array to hold pieces for both players
		self.clear();
		pieces = Array.new(2) {Array.new(12)};

		for i in 0..11 do
			pieces[0][i] = Piece.new(:cyan);
		end

		for i in 0..11 do
			pieces[1][i] = Piece.new(:magenta);
		end

		#adds pieces to the starting positions on the board
		pieceCount = 0;
		for j in 0..1 do
			for i in 0..5 do
				@spaces["#{i}#{j}"].addPiece(pieces[0][pieceCount]);
				pieceCount = pieceCount + 1;
			end
		end

		pieceCount = 0;
		for j in 4..5 do
			for i in 0..5 do
				@spaces["#{i}#{j}"].addPiece(pieces[1][pieceCount]);
				pieceCount = pieceCount + 1;
			end
		end

		return pieces
	end

	#This method is called by the match to clear all of the spaces within the game board
	def clear
		count = 0
		@spaces.each do |key, value|
			count = count + 1
			value.removePiece;
		end
	end

	#This method is used to move the given piece to the corresponding spot on the gameboard if its a valid move for the piece
	def movePiece(piece,position)
		@validDestinations = getValidActions(piece);
		if @validDestinations.has_key?(position) == true
			piece.getSpace().removePiece()
			piece.addSpace(@spaces[position])
			if @spaces[position]==nil
				@spaces[position].addPiece(piece)
				return nil
			else
				piece2 = @spaces[position].getPiece()
				@spaces[position].removePiece()
				@spaces[position].addPiece(piece)
				return piece2
			end

			resetMovesUI();
		else
			return false
		end

	end

	#Returns the position as “x” + “y” as a string.
	def positionAsString(position)
		string = "#{position.fetch("x")}#{position.fetch("y")}";
	end

	#This function is used to update the valid moves within the validDestinations hash and show the valid moves within the UI
	def getValidActions(piece)

		validMoves = getValidMoves(piece);
		validCaptures = getValidCaptures(piece)

		if(validCaptures == nil)
			return validMoves
		else
			validCaptures.each{|coordinates|
				if @spaces[positionAsString(coordinates)].getPiece()
					if @spaces[positionAsString(coordinates)].getPiece().getColour != piece.getColour()
						validMoves[positionAsString(coordinates)] = true
					end
				end
			}
			return validMoves
		end
	end

	def getValidMoves(piece)
		validMoves = Hash.new()
		permutation_piece = {"x" => piece.spacePosition.fetch("x"), "y" => piece.spacePosition.fetch("y")}
		permutation_piece["x"] += 1

		if(spaceAt(permutation_piece) != nil && spaceAt(permutation_piece).getPiece == nil)
			validMoves[positionAsString(permutation_piece)] = true
		end

		permutation_piece = {"x" => piece.spacePosition.fetch("x"), "y" => piece.spacePosition.fetch("y")}
		permutation_piece["x"] += -1

		if(spaceAt(permutation_piece) != nil && spaceAt(permutation_piece).getPiece == nil)
			validMoves[positionAsString(permutation_piece)] = true
		end

		permutation_piece = {"x" => piece.spacePosition.fetch("x"), "y" => piece.spacePosition.fetch("y")}
		permutation_piece["y"] += 1

		if(spaceAt(permutation_piece) != nil && spaceAt(permutation_piece).getPiece == nil)
			validMoves[positionAsString(permutation_piece)] = true
		end

		permutation_piece = {"x" => piece.spacePosition.fetch("x"), "y" => piece.spacePosition.fetch("y")}
		permutation_piece["y"] += -1

		if(spaceAt(permutation_piece) != nil && spaceAt(permutation_piece).getPiece == nil)
			validMoves[positionAsString(permutation_piece)] = true
		end

		return validMoves
	end

	def getValidCaptures(piece)
		innerCollisions = @innerloop.getCollisions(piece)
		outerCollisions = @outerloop.getCollisions(piece)
		if innerCollisions == nil && outerCollisions == nil
			return nil
		elsif innerCollisions == nil
			return outerCollisions
		elsif outerCollisions == nil
			return innerCollisions
		else
			combinedCollisions = innerCollisions + outerCollisions;
			#print combinedCollisions
			return combinedCollisions
		end
	end

	def spaceAt(position)
		key = "#{position.fetch("x")}#{position.fetch("y")}";
		@spaces.fetch(key,nil)
	end

	#UI TBD
	def showMovesUI
		#Not implemented due to text base
	end

	#UI TBD
	def resetMovesUI
		#Not implemented due to text base
	end

	def printBoard
		print("\n         X: 0 1 2 3 4 5\n")
		print("     ___________   ___________\n")
		print("    |    _____  | |  _____    |\n")
		print("Y:  |   |     | | | |     |   |\n")
		print("0   |   |   ")

		if (@spaces["00"].getPiece == nil)
		  print ". "
		else
		  print "o " .colorize(@spaces["00"].getPiece().getColour())
		end

		if (@spaces["10"].getPiece == nil)
		  print ". "
		else
		  print "o " .colorize(@spaces["10"].getPiece().getColour())
		end

		if (@spaces["20"].getPiece == nil)
		  print ". "
		else
		  print "o " .colorize(@spaces["20"].getPiece().getColour())
		end

		if (@spaces["30"].getPiece == nil)
		  print ". "
		else
		  print "o " .colorize(@spaces["30"].getPiece().getColour())
		end

		if (@spaces["40"].getPiece == nil)
		  print ". "
		else
		  print "o " .colorize(@spaces["40"].getPiece().getColour())
		end

		if (@spaces["50"].getPiece == nil)
		  print "."
		else
		  print "o" .colorize(@spaces["50"].getPiece().getColour())
		end

		print("   |   |\n")
		print("1   |   |__ ")
		if (@spaces["01"].getPiece == nil)
			print ". "
		else
			print "o " .colorize(@spaces["01"].getPiece().getColour())
		end

		if (@spaces["11"].getPiece == nil)
			print ". "
		else
			print "o " .colorize(@spaces["11"].getPiece().getColour())
		end

		if (@spaces["21"].getPiece == nil)
			print ". "
		else
			print "o " .colorize(@spaces["21"].getPiece().getColour())
		end

		if (@spaces["31"].getPiece == nil)
			print ". "
		else
			print "o " .colorize(@spaces["31"].getPiece().getColour())
		end

		if (@spaces["41"].getPiece == nil)
			print ". "
		else
			print "o " .colorize(@spaces["41"].getPiece().getColour())
		end

		if (@spaces["51"].getPiece == nil)
			print "."
		else
			print "o" .colorize(@spaces["51"].getPiece().getColour())
		end
		print(" __|   |\n")
		STDOUT.flush
		print("2   \\______ ")
		if (@spaces["02"].getPiece == nil)
			print ". "
		else
			print "o " .colorize(@spaces["02"].getPiece().getColour())
		end

		if (@spaces["12"].getPiece == nil)
			print ". "
		else
			print "o " .colorize(@spaces["12"].getPiece().getColour())
		end

		if (@spaces["22"].getPiece == nil)
			print ". "
		else
			print "o " .colorize(@spaces["22"].getPiece().getColour())
		end

		if (@spaces["32"].getPiece == nil)
			print ". "
		else
			print "o " .colorize(@spaces["32"].getPiece().getColour())
		end

		if (@spaces["42"].getPiece == nil)
			print ". "
		else
			print "o " .colorize(@spaces["42"].getPiece().getColour())
		end

		if (@spaces["52"].getPiece == nil)
			print "."
		else
			print "o" .colorize(@spaces["52"].getPiece().getColour())
		end
		print(" ______/\n")
		print("3    ______ ")
		if (@spaces["03"].getPiece == nil)
			print ". "
		else
			print "o " .colorize(@spaces["03"].getPiece().getColour())
		end

		if (@spaces["13"].getPiece == nil)
			print ". "
		else
			print "o " .colorize(@spaces["13"].getPiece().getColour())
		end

		if (@spaces["23"].getPiece == nil)
			print ". "
		else
			print "o " .colorize(@spaces["23"].getPiece().getColour())
		end

		if (@spaces["33"].getPiece == nil)
			print ". "
		else
			print "o " .colorize(@spaces["33"].getPiece().getColour())
		end

		if (@spaces["43"].getPiece == nil)
			print ". "
		else
			print "o " .colorize(@spaces["43"].getPiece().getColour())
		end

		if (@spaces["53"].getPiece == nil)
			print "."
		else
			print "o" .colorize(@spaces["53"].getPiece().getColour())
		end
		print(" ______\n")


		print("4   /    __ ")
		if (@spaces["04"].getPiece == nil)
			print ". "
		else
			print "o " .colorize(@spaces["04"].getPiece().getColour())
		end

		if (@spaces["14"].getPiece == nil)
			print ". "
		else
			print "o " .colorize(@spaces["14"].getPiece().getColour())
		end

		if (@spaces["24"].getPiece == nil)
			print ". "
		else
			print "o " .colorize(@spaces["24"].getPiece().getColour())
		end

		if (@spaces["34"].getPiece == nil)
			print ". "
		else
			print "o " .colorize(@spaces["34"].getPiece().getColour())
		end

		if (@spaces["44"].getPiece == nil)
			print ". "
		else
			print "o " .colorize(@spaces["44"].getPiece().getColour())
		end

		if (@spaces["54"].getPiece == nil)
			print "."
		else
			print "o" .colorize(@spaces["54"].getPiece().getColour())
		end
		print(" __    \\")
		print("\n")
		print("5   |   |   ")
		if (@spaces["05"].getPiece == nil)
			print ". "
		else
			print "o " .colorize(@spaces["05"].getPiece().getColour())
		end

		if (@spaces["15"].getPiece == nil)
			print ". "
		else
			print "o " .colorize(@spaces["15"].getPiece().getColour())
		end

		if (@spaces["25"].getPiece == nil)
			print ". "
		else
			print "o " .colorize(@spaces["25"].getPiece().getColour())
		end

		if (@spaces["35"].getPiece == nil)
			print ". "
		else
			print "o " .colorize(@spaces["35"].getPiece().getColour())
		end

		if (@spaces["45"].getPiece == nil)
			print ". "
		else
			print "o " .colorize(@spaces["45"].getPiece().getColour())
		end

		if (@spaces["55"].getPiece == nil)
			print "."
		else
			print "o" .colorize(@spaces["55"].getPiece().getColour())
		end
		print("   |   |\n")
		print("    |   |     | | | |     |   |\n")
		print("    |   |_____| | | |_____|   |\n")
		print("    |___________| |___________|\n")
		print("\n")
	end

end
