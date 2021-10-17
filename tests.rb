require_relative 'BoardGame.rb'
require_relative 'space.rb'
require_relative 'piece.rb'
require_relative 'loop.rb'

puts 'Welcome to the Test Suite'

testSpace = Space.new(1,1)

puts("\nGet Position #{testSpace.getPosition}")
puts("\nGet Piece when Nil #{testSpace.getPiece}")
puts("\nGet Position As String #{testSpace.positionAsString}");

testPiece = Piece.new("White");
puts("\nAdd Piece to Empty Space\nExpected Output: true \nActual Output: #{testSpace.addPiece(testPiece)}")


gameBoard = GameBoard.new(6,6);
gameBoard.setup();

puts "\n\n\n\n\n\n\n\n\n\n\n\n\n"

puts testPiece.spacePosition
puts gameBoard.getValidMoves(testPiece);
