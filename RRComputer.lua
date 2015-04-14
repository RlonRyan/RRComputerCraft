-- Computer Program Agent
-- By RlonRyan
--
-- UgW5W9FM
--
-- This program allows for the easy setup of RR|Programs (for ComputerCraft).
-- It will also attempt to update RR|Programs when run.
-- It uses the RR|Programs list found on github to find programs.
--
-- Dependencies:
-- (All dependencies will auto-download and install)
--
-- Installation instructions:
-- Use: pastebin get UgW5W9FM RR|Computer
--
-- Install disk instructions:
-- Save the line:
-- shell.run("pastebin get UgW5W9FM RR|Computer")
-- To disk/autorun
--
-- Run instructions:
-- Use: RR|Computer

local path = shell.getRunningProgram() .. "Resources"

local overwrite = true

function output(text, color)
  color = color or colors.white
  term.setTextColor(color)
  write(text)
end

function outputln(text, color) -- Dirty Funtion.
  color = color or colors.white
  term.setTextColor(color)
  print(text)
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
    outputln("RR|Program Setup", colors.green)
    bar()
    br()
end

function validate(filepath)
  --print(string.match(filepath, "%a+"))
  if(string.find(filepath, "/") and not fs.exists(string.match(filepath, "%a+"))) then
    fs.makeDir(string.match(filepath, "%a+"))
    return true
  elseif(not fs.exists(filepath)) then
    return true
  elseif(not checkversion) then
    fs.delete(filepath)
    return true
  elseif(overwrite) then
    fs.delete(filepath)
    return true
  else
  	err("Bad filepath: " .. filepath)
    return false
  end
end

function downloadPaste(paste, filepath)
  if(not validate(filepath)) then
    return false
  else
    return shell.run("pastebin", "get", paste, filepath)
  end
end

function downloadHttp(address, filepath)
  if(not validate(filepath)) then
  	err("Could not download: " .. address .. " to: " .. filepath)
    return false
  else
    print("Installing: " .. address .. " to: " .. filepath)
    temp = http.get(address)
    if(temp) then
      content = temp.readAll()
      temp.close()
      temp = fs.open(filepath, "w")
      if(not temp) then
      	err("Cannot write file: " .. filepath)
      	return false
      end
      temp.write(content)
      temp.close()
      return true
    else
      err("Unable to fetch file. Is the internet down?", "Or have you not yet enabled http for computercraft?")
      return false
    end
  end
end

function getManifest(address)
  temp = http.get(address .. "/manifest.mf")
  if(temp) then
    manifest = textutils.unserialize(temp.readAll())
    temp.close()
    return manifest
  else
    err("Unable to fetch file. Is the internet down?", "Or have you not yet enabled http for computercraft?")
    return false
  end
end

reset()

print("Validating Directories.")
fs.delete(path)
fs.makeDir(path)

reset()

print("Updating programs list.")
programs = getManifest("https://raw.githubusercontent.com/RlonRyan/RRComputerCraft/master")

reset()

print("Updating installation agent.")
downloadHttp("https://raw.githubusercontent.com/RlonRyan/RRComputerCraft/master/RRDownloader.lua", path .. "/RRDownloader")

reset()

print("Obtaining Dependencies.")

reset()

print("Initialization Completed.")
bar()
print("")
output("Press any key to continue.")
io.read()

reset()

print("Available Programs")
bar()
menu = {}
i = 1
for k,v in pairs(programs) do
	menu[i] = k
	print(i .. ".) " .. k .. " by " .. v["author"])
	i = i + 1
end
bar()
print("Select Programs: ")
bar()

selections = string.gmatch(io.read(), "[^%s]+")

bar()

for selection in selections do
	selection = tonumber(selection)
	shell.run(path .. "/RRDownloader" .. " http " .. "https://raw.githubusercontent.com/RlonRyan/RRComputerCraft/master/" .. programs[menu[selection]]["file"] .. " " .. programs[menu[selection]]["program"])
end

term.clear()
term.setCursorPos(1,1)
