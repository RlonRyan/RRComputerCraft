--
-- Option Variables
--
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

function output(text, color)
  color = color or colors.white
  term.setTextColor(color)
  write(text)
  term.setTextColor(colors.white)
end

function outputln(text, color) -- Dirty Funtion.
  color = color or colors.white
  term.setTextColor(color)
  print(text)
  term.setTextColor(colors.white)
end

function bar()
	outputln("================", colors.lightGray)
end

function br()
	print()
end

function err(...)
  -- TODO: Add Error formatter.
  br()
  bar()
  for line in arg do
    outputln(text, colors.red)
  end
  bar()
  br()
end

function reset()
    term.clear()
    term.setCursorPos(1,1)
    outputln("RR|Mine", colors.green)
    bar()
    br()
end

function init()

	reset()
	output("Enter Mode: ")
	mode = io.read()
	mode = tonumber(mode)
	
	reset()
	output("Enter Length: ")
	length = io.read()
	length = tonumber(length)
	
	reset()
	output("Enter Rows: ")
	rows = io.read()
	rows = tonumber(rows)
	
	reset()
	output("Enter Torch Interval: ")
	torch = io.read()
	torch = tonumber(torch)
	
	reset()
	output("Name? (y/n): ")
	if (io.read() == y) then
		shell.run(label, "set", "RR|MiningTurtle")
	end

end

function pov(dist)
	
	if dir == 0 then
		return {x, y + dist}
	elseif dir == 1 then
		return {x + dist, y}
	elseif dir == 2 then
		return {x, y - dist}
	elseif dir == 3 then
		return {x - dist, y}
	end
	
end

function fuel()

	if turtle then
		
		while turtle.getFuelLevel()  == 0 do
		
			turtle.select(1)
			turtle.refuel(1)
			
			if turtle.getFuelLevel() == 0 then
			
				err("Ran out of fuel! Refuel and press any key to continue!")
				io.read()
			end
			
		end
		
	end

end

function turn()

	if mode == 1 then
		
		if turtle then
			turtle.turnRight()
		end
		
		dir = dir + 1
		
		if dir > 3 then
			dir = 0
		end
		
	else
		
		if turtle then
			turtle.turnLeft()
		end
		
		dir = dir - 1
		
		if dir < 0 then
			dir = 3
		end
		
	end

end

function turnback()

	if mode == 1 then
		
		if turtle then
			turtle.turnLeft()
		end
		
		dir = dir - 1
		
		if dir < 0 then
			dir = 3
		end
		
	else
		
		if turtle then
			turtle.turnRight()
		end
		
		dir = dir + 1
		
		if dir > 3 then
			dir = 0
		end
		
	end

end

function face(d)
	
	while not dir == d do
		turn()
	end
	
end

function move()
	
	if (not turtle) or (turtle.forward()) then
		
		if dir == 0 then
			y = y + 1
		elseif dir == 1 then
			x = x + 1
		elseif dir == 2 then
			y = y - 1
		elseif dir == 3 then
			x = x - 1
		end
		
		if (not turtle) then
			output("X: " .. x .. " Y: " .. y)
			io.read()
		else
			outputln("X: " .. x .. " Y: " .. y)
		end
		
	end
	
end

function depositinventory()

	if not turtle then
		return
	end
	
	for i=4,16,1 do
		
		turtle.select(i)
		turtle.drop()
		
	end		

end

function row(l)

	for i=1,l,1 do
		
		fuel()
		
		while turtle and turtle.detect() do
			
			turtle.dig()
			
		end
		
		move()
		
		if turtle and not turtle.detectDown() then
			
			turtle.select(3)
			turtle.placeDown()
			
		end
		
		if i % torch == 1 then
			
			turn()
			turn()
			
			if turtle then
				turtle.select(2)
				turtle.place()
			else
				tp = pov(1)
				outputln("Torch at X: " .. tp[1] .. " Y: " .. tp[2], colors.yellow)
			end
			
			turnback()
			turnback()
			
		end
		
		while turtle and turtle.detectUp() do
			
			turtle.digUp()
			
		end
		
	end
	
end

function main()
	
	init()
	
	for i=1,rows,1 do
		
		reset()
		outputln("Start Row: " .. i)
		bar()
		
		row(length)
		
		bar()
		outputln("End Row: " .. i)
		
		reset()
		outputln("Cutting Over")
		bar()
		
		turn()
		row(3)
		turn()
		
		bar()
		outputln("Cut Over")
		
		reset()
		outputln("Starting Row Back: " .. i)
		bar()
		
		row(length)
		
		bar()
		outputln("End Row Back: " .. i)
		
		turn()
		
		reset()
		outputln("Begin homing.")
		bar()
		
		pos = x
		
		row(2)
		
		while (not (x == 0)) do
			
			while turtle and turtle.detect() do
				turtle.dig()
			end
			move()
			
		end
		
		bar()
		outputln("Home.")
		
		turnback()
		depositinventory()
		turnback()
		
		if (i == rows) then
			
			reset()
			outputln("Done.", colors.lime)
			return
			
		end
		
		reset()
		outputln("Returning to mine.")
		bar()
		
		while (not (x == pos)) do
			
			while turtle and turtle.detect() do
				turtle.dig()
			end
			move()
			
		end
		
		bar()
		print("Back at mining location.")
		
		reset()
		print("Shifting Over.")
		bar()
		
		row(3)
		turnback()
		
		bar()
		print("Shifted Over.")
		
	end

end

main()
