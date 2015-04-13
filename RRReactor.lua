local react = peripheral.find("BigReactors-Reactor")

function getReactor()
  react = peripheral.find("BigReactors-Reactor")
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

function outputPower(p)
  f = p / 100000
  if (f >= 50) then
    output(tostring(p) .. "rf", colors.green)
  elseif (f >= 25) then
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

function printInfo()
  term.clear()
  term.setCursorPos(1, 1)
  output("Reactor Controller")
  output("\n")
  output("==================")
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

  output("Power: ")
  outputPower(react.getEnergyStored())
  output("\n")

  output("Fill: ")
  outputFill(react.getEnergyStored() / 10000000)
  output("\n")
end

function power()
  if (react.getActive() and (react.getEnergyStored() / 100000 > 90)) then
    react.setActive(false)
  elseif (react.getEnergyStored() / 100000 < 25) then
    react.setActive(true)
  end
end

function run()
  getReactor()
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
