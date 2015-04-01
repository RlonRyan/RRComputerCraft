mode = 0
length = 0
rows = 0
torch = 0

--
-- Positioning System Variables
--
x = 0    -- X-Coordinate on XY-plane centered on chest at position (0,0).
y = 1    -- Y-Coordinate. The chest is at position (0,0) or behind the turtle when it is started.
dir = 0  -- The directional heading of the turtle. Headings are in the set: {0,1,2,3} representing: {+y,+x,-y,-x} in a clockwise direction.

function init()

	term.clear()
	term.setCursorPos(1,1)
	term.write("Enter Mode:")
	mode = io.read()
	mode = tonumber(mode)
	term.write("Enter Length:")
	length = io.read()
	length = tonumber(length)
	term.write("Enter Rows:")
	rows = io.read()
	rows = tonumber(rows)
	term.write("Enter Torch Interval:")
	torch = io.read()
	torch = tonumber(torch)

end

function fuel()

	while turtle.getFuelLevel()  == 0 do

		turtle.select(1)
		turtle.refuel(1)

		if turtle.getFuelLevel() == 0 then

			term.write("Ran out of fuel! Refuel and press any key to continue!")
			io.read()

		end

	end

end

function row(l)

	for i=0,l,1 do

		fuel()

		while not turtle.forward() do

			turtle.dig()

		end

		if not turtle.detectDown() then

			turtle.select(3)
			turtle.placeDown()

		end

		if i % torch == 1 then

			turtle.turnLeft()
			turtle.turnLeft()
			turtle.select(2)
			turtle.place()
			turtle.turnRight()
			turtle.turnRight()

		end

		while turtle.detectUp() do

			turtle.digUp()

		end

	end
end

function turn()

	if mode == 1 then

		turtle.turnRight()

	else

		turtle.turnLeft()

	end

end

function turnback()

	if mode == -1 then

		turtle.turnRight()

	else

		turtle.turnLeft()

	end

end

function depositinventory()

	for i=4,9,1 do

		turtle.select(i)
		turtle.drop()

	end		

end

function main()

	init()

	for i=0,rows,1 do

		row(length)
		turn()
		row(2)
		turn()
		row(length)
		turn()
		row(2)

		pos = 2
		
		while not turtle.detect() do

			turtle.forward()
			pos = pos + 1

		end

		depositinventory()
		turn()
		turn()

		for ii=0,pos,1 do

			turtle.forward()

		end

		row(2)
		turnback()

	end

end

main()
