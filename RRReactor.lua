local RPOWER = 10000000
local TPOWER = 1000000
local LIQCAP = 2600

local react = peripheral.find("BigReactors-Reactor")
local turbines = nil
local activecool = false
local w, h = term.getSize()

function getReactor()
  react = peripheral.find("BigReactors-Reactor")
  activecool = react.isActivelyCooled()
end

function getTurbines()
  turbines = {peripheral.find("BigReactors-Turbine")}
end

function getRPM()
	local rpm = 0;
	for i,t in ipairs(turbines) do
		rpm = rpm + t.getRotorSpeed()
	end
	return (rpm / table.getn(turbines))
end

function getReactorPowerFill()
	return react.getEnergyStored() / RPOWER
end

function getTurbinePowerFill()
	local p = 0
	
	for i,t in ipairs(turbines) do
		p = p + t.getEnergyStored()
	end
  	return (p / (TPOWER * table.getn(turbines)))
end

function setTurbinesActive(value)
	for i,t in ipairs(turbines) do
		t.setActive(value)
	end
end

function output(text, color)
  color = color or colors.white
  term.setTextColor(color)
  write(text)
end

function outputBool(b)
  if (b) then
    output("true", colors.green)
  else
    output("false", colors.red)
  end
end

function outputPower()
  local p = 0
  local f = 0
  if (activecool) then
  	for i,t in ipairs(turbines) do
		p = p + t.getEnergyStored()
	end
  	f = p / (TPOWER * table.getn(turbines))
  else
  	p = react.getEnergyStored()
  	f = p / RPOWER
  end
  
  if (f >= .50) then
    output(tostring(p) .. "rf", colors.green)
  elseif (f >= .25) then
    output(tostring(p) .. "rf", colors.yellow)
  else
    output(tostring(p) .. "rf", colors.red)
  end
end

function outputFill(f)
  f = f * 100
  if (f >= 50) then
    output(tostring(f) .. "%", colors.green)
  elseif (f >= 25) then
    output(tostring(f) .. "%", colors.yellow)
  else
    output(tostring(f) .. "%", colors.red)
  end
end

function outputPowerFill()
  local p = 0
  local f = 0
  if (activecool) then
  	for i,t in ipairs(turbines) do
		p = p + t.getEnergyStored()
	end
  	f = p / (TPOWER * table.getn(turbines))
  else
  	p = react.getEnergyStored()
  	f = p / RPOWER
  end
  
  outputFill(f)
end

function outputCoolant(c)
  local c = react.getCoolantAmount()
  local f = c / LIQCAP
  
  if (f >= .50) then
    output(tostring(c) .. "mB", colors.green)
  elseif (f >= .25) then
    output(tostring(c) .. "mB", colors.yellow)
  else
    output(tostring(c) .. "mB", colors.red)
  end
end

function outputSteam()
  local steam = react.getHotFluidAmount()
  local f = steam / LIQCAP
  
  if (f >= .75) then
    output(tostring(steam) .. "mB", colors.red)
  elseif (f >= .50) then
    output(tostring(steam) .. "mB", colors.yellow)
  else
    output(tostring(steam) .. "mB", colors.green)
  end
end

function outputRPM()
  local r = getRPM()
  
  if (r >= 2000) then
    output(tostring(r) .. "RPM", colors.red)
  elseif (r >= 1900) then
    output(tostring(r) .. "RPM", colors.yellow)
  elseif (r >= 1700) then
    output(tostring(r) .. "RPM", colors.green)
  else
    output(tostring(r) .. "RPM", colors.yellow)
  end
end

function printInfo()
  term.clear()
  term.setCursorPos(1, 1)
  for i=1, ((w - 18) / 2), 1 do
  	output(" ")
  end
  output("Reactor Controller")
  output("\n")
  for i=1, w, 1 do
  	output("=")
  end
  output("\n")
  
  output("Connected: ")
  outputBool(react.getConnected())
  output("\n")
  
  output("Active: ")
  outputBool(react.getActive())
  output("\n")

  output("Fuel: ")
  outputFill(react.getFuelAmount() / react.getFuelAmountMax())
  output("\n")

  if(activecool) then
    output("Coolant: ")
    outputCoolant()
    output("\n")
    
    output("Steam: ")
    outputSteam()
    output("\n")
    
    output("RPM: ")
    outputRPM()
    output("\n")
  end
  
  output("Power: ")
  outputPower()
  output("\n")

  output("Fill: ")
  outputPowerFill()
  output("\n")
end

function power()
  if (activecool) then
  	if ((react.getActive() and ((react.getHotFluidAmount() / LIQCAP) > .75)) or ((react.getCoolantAmount() / LIQCAP) < .25) or (getTurbinePowerFill() > .75)) then
      react.setActive(false)
    elseif (((react.getHotFluidAmount() / LIQCAP) < .25) and ((react.getCoolantAmount() / LIQCAP) > .75) and (getTurbinePowerFill() < .25)) then
      react.setActive(true)
      setTurbinesActive(true)
    end
  else
    if (react.getActive() and (getReactorPowerFill() > .90)) then
      react.setActive(false)
    elseif (getReactorPowerFill() < .25) then
      react.setActive(true)
    end
  end
end

function run()
  getReactor()
  if (activecool) then
  	getTurbines()
  end
  while react do
    power()
    printInfo()
    sleep(0.5)
  end
  term.clear()
  term.setCursorPos(1,1)
  print("Reactor Connection Lost!")
end

run()
