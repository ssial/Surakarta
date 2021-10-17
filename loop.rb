# Written by Sawaiba Sial
# CIS3260

class Loop
    def initialize(length, width, offset, boardSpaces)
        if offset==1
            @spaces = ["10","40", "01", "11", "21", "31", "41", "51", "12", "42", "13", "43", "04", "14", "24", "34", "44", "54", "15", "45"]
            @loop_exits = {["10","B"] => "01", ["40","F"] => "51", ["01","F"] => "10", ["51","B"] => "40", ["04","B"] => "15", ["54","F"] => "45", ["15","F"] => "04", ["45","B"] => "54"}
        else
            @spaces = ["30", "20", "21", "31", "02", "12", "22", "32", "42", "52", "03", "13", "23", "33", "43", "53", "24", "34", "25", "35"]
            @loop_exits = {["20","B"] => "02", ["02","F"] => "20", ["30","F"] => "52", ["52","B"] => "30", ["53","F"] => "35", ["35","B"] => "53", ["25","F"] => "03", ["03","B"] => "25"}
        end
        @selfIntersections = {}
        @boardSpaces = boardSpaces
    end

    def validcapture(collision, colour)
        colour2 = :red
        if colour != colour2
            return true
        end
        return false
    end


    def getCollisions(piece)
        testedFLoops = Array.new
        collisions = Array.new
        fcollisions = Array.new
        bcollisions = Array.new
        testCoordHash = piece.spacePosition()

        # Test forward/clockwise paths
        flc = firstLoopCheck(testCoordHash, true)

        if flc
            testedFLoops.push(flc)
            testCoord = @loop_exits[[flc,"F"]]
            testCoordHash = {"x" => testCoord[0].to_i, "y" => testCoord[1].to_i}
            fcollisions.push(testCoordHash)
            (1..4).each do
                result = forward(testCoordHash, testedFLoops)
                if result
                    testedFLoops.push(result[0])
                    testCoord = @loop_exits[[result[0],"F"]]
                    testCoordHash = {"x" => testCoord[0].to_i, "y" => testCoord[1].to_i}
                    if result[1].kind_of?(Hash)
                            fcollisions.push(result[1])
                    end
                end
            end
            testCoord = @loop_exits[[testedFLoops.last,"F"]]
            testCoordHash = {"x" => testCoord[0].to_i, "y" => testCoord[1].to_i}
            result = clearPath(testCoordHash, {"x" => testedFLoops.first[0].to_i, "y" => testedFLoops.first[1].to_i})
            if result.kind_of?(Hash)
                    fcollisions.push(result)
            end
        end

        # Test backward/anti-clockwise paths
        testedBLoops = Array.new
        testCoordHash = piece.spacePosition()

        flc = firstLoopCheck(testCoordHash, false)


        if flc
            testedBLoops.push(flc)
            testCoord = @loop_exits[[flc,"B"]]
            testCoordHash = {"x" => testCoord[0].to_i, "y" => testCoord[1].to_i}
            bcollisions.push(testCoordHash)
            (1..4).each do
                result = backward(testCoordHash, testedBLoops)
                if result
                    testedBLoops.push(result[0])
                    testCoord = @loop_exits[[result[0],"B"]]
                    testCoordHash = {"x" => testCoord[0].to_i, "y" => testCoord[1].to_i}
                    if result[1].kind_of?(Hash)
                            bcollisions.push(result[1])
                    end
                end
            end
            testCoord = @loop_exits[[testedBLoops.last,"B"]]
            testCoordHash = {"x" => testCoord[0].to_i, "y" => testCoord[1].to_i}
            result = clearPath(testCoordHash, {"x" => testedBLoops.first[0].to_i, "y" => testedBLoops.first[1].to_i})
            if result.kind_of?(Hash)
                    bcollisions.push(result)
            end
        end

        if fcollisions[0] == nil
        else
            collisions.push(fcollisions[0])
        end

        if bcollisions[0] == nil
        else
            collisions.push(bcollisions[0])
        end
     
        return collisions


    end

    def spaceEmpty(coord)
        key = coord["x"].to_s + coord["y"].to_s
        if @boardSpaces[key].getPiece()
            return false
        end
        return true
    end

    def firstLoopCheck(position, forward)
        if forward
            possible_exits = @loop_exits.keys.select{|e| e.include?"F"}
        else
            possible_exits = @loop_exits.keys.select{|e| e.include?"B"}
        end

        coords = 0
        possible_exits.each do |i|
            coords = i[0]
            coordsHash = {"x" => coords[0].to_i, "y" => coords[1].to_i}
            if (position["x"]-coordsHash["x"])==0 and (position["y"]-coordsHash["y"])==0
                result = clearPath(position, coordsHash)
                if result and !result.kind_of?(Hash)
                    return coords
                end
            elsif position["y"] - coordsHash["y"] == 0 and (position["y"]==0 or position["y"]==5)
            elsif position["x"] - coordsHash["x"] == 0 and (position["x"]==0 or position["x"]==5)
            else
                result = clearPath(position, coordsHash)
                if result and !result.kind_of?(Hash)
                    return coords
                end
            end
        end
        return false
    end

    # returns true if there's a clear path between two given points, false if there's no direct path, otherwise returns an array of pieces that block the direct path
    def clearPath(p1,p2)
        if (p1["x"]-p2["x"])==0 and (p1["y"]-p2["y"])==0
            return true
        elsif (p1["x"]-p2["x"])==0 || (p1["y"]-p2["y"])==0
            # points are in same column
            if (p1["x"]-p2["x"])==0
                compA1 = p1["y"]
                compA2 = p1["x"]
                compB1 = p2["y"]
                compB2 = p2["x"]
                if p2["y"]>p1["y"]
                    increment = true
                else
                    increment = false
                end
                compy = true
            # points are in same row
            else
                compA1 = p1["x"]
                compA2 = p1["y"]
                compB1 = p2["x"]
                compB2 = p2["y"]
                if p2["x"]>p1["x"]
                    increment = true
                else
                    increment = false
                end
                compy = false
            end

            counter = 0
            collisions = Array.new
            comp = compA1
            until comp==compB1
                if increment
                    comp+=1
                else
                    comp-=1
                end
                #need to call spaceAt() from gameboard class -> returns Space obj then use Space.getPiece() to check if it's empty or not
                if compy
                    position = {"x" => compA2, "y" => comp}
                    if spaceEmpty(position)
                        counter+=1
                    else
                        return position
                    end
                else
                    position = {"x" => comp, "y" => compA2}
                    if spaceEmpty(position)
                        counter+=1
                    else
                        return position
                    end
                end
            end

            if counter==(compB1-compA1)
                return true
            end
            return collisions
        end
        return false
    end

    #find nearest loop exit in clockwise direction
    def forward(position, avoid)
        possible_exits = @loop_exits.keys.select{|e| e.include?"F"}
        coords = 0

        possible_exits.each do |i|
            coords = i[0]
            if !avoid.include?coords
                coordsHash = {"x" => coords[0].to_i, "y" => coords[1].to_i}
                if position["y"] - coordsHash["y"] == 0 and (position["y"]==0 or position["y"]==5)
                elsif position["x"] - coordsHash["x"] == 0 and (position["x"]==0 or position["x"]==5)
                else
                    result = clearPath(position, coordsHash)
                    if result
                        return coords, result
                    end
                end

            end
        end
        return false
    end

    #find nearest loop exit in counter-clockwise direction
    def backward(position, avoid)
        possible_exits = @loop_exits.keys.select{|e| e.include?"B"}
        coords = 0

        possible_exits.each do |i|
            coords = i[0]
            if !avoid.include?coords
                coordsHash = {"x" => coords[0].to_i, "y" => coords[1].to_i}
                if position["y"] - coordsHash["y"] == 0 and (position["y"]==0 or position["y"]==5)
                elsif position["x"] - coordsHash["x"] == 0 and (position["x"]==0 or position["x"]==5)
                else
                    result = clearPath(position, coordsHash)
                    if result
                        return coords, result
                    end
                end

            end
        end
        return false
    end

    def positionInLoop(position)

    end

end
