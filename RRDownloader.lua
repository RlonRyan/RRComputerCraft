-- Computer Program Downloader Agent
-- By RlonRyan
--
-- PpKH1HS8
--
-- This program allows for the easy download of RR|Programs (for computercraft).

args = {...}

local overwrite = true

--
-- Common Output Functions
--

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
  outputln("")
  output("Press any key to continue.")
  io.read()
end

function reset()
    term.clear()
    term.setCursorPos(1,1)
    outputln("RR|Downloader", colors.green)
    bar()
    br()
end

--
-- Main Functions
--

function checkVersion(filepath)
  -- Todo
  return false
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
    return false
  end
end

function getManifest(address)
  temp = http.get(address .. "/manifest.mf")
  if(temp) then
    manifest = textutils.unserialize(temp.readAll())
    temp.close()
    return manifest
  else
    print("Unable to fetch file. Is the internet down?")
    print("Or have you not yet enabled http for computercraft?")
    return false
  end
end

function downloadPaste(paste, filepath)

  outputln("Downloading Paste... ")
  
  if(not validate(filepath)) then
  	err("Invalid Filepath: " .. filepath)
    return false
  else
    return shell.run("pastebin", "get", paste, filepath)
  end
  
  outputln(" Complete!")
  
end

function downloadHttp(address, filepath)
  if(not validate(filepath)) then
  	err("Invalid Filepath: " .. filepath)
    return false
  else
  	
  	br()
  	outputln("Downloading")
  	bar()
  	
  	output("Retrieving Temp. File... ")
    temp = http.get(address)
    
    if (not temp) then
    	err("Unable to fetch file. Is the internet down? \n Or have you not yet enabled http for computercraft?")
    	return false
	end
	
    outputln("Retrieved.")
    
    br()
    output("Reading File... ")
    content = temp.readAll()
    temp.close()
    outputln("Read.")
    
    br()
    output("Writing File... ")
    temp = fs.open(filepath, "w")
    if(not temp) then
    	err("Cannot write file: " .. filepath)
    	return false
    end
    temp.write(content)
    temp.close()
    outputln(" Complete!")
    
    return true

  end
end

function downloadGit(user, repo, branch, file, name)
	
	output("Compiling GitHub Address: ")
  	address = "https://raw.githubusercontent.com/" .. user .. "/" .. repo .. "/" .. branch .. "/" .. file
  	outputln(address, colors.gray)
  	bar()
  	
  	downloadHttp(address, name)
  	
end

function downloadGitFull(user, repo, branch)
	
	output("Compiling GitHub Address: ")
  	address = "https://raw.githubusercontent.com/" .. user .. "/" .. repo .. "/" .. branch
  	outputln(address, colors.gray)
  	
  	for k,v in pairs(getManifest(address)) do
    	downloadHttp(address .. "/" .. v["file"], v["program"])
  	end
  	
end

--
--	Main Code
--

reset()

if (table.getn(args) < 3) then
	
	err("Not enough arguments provided to download.")
	return false
	
end

outputln("Downloading Program: " .. args[table.getn(args)])
bar()
outputln("\tFrom: " .. args[2])
outputln("\tVia: " .. args[1])
bar()

if(args[1] == "paste" and table.getn(args) == 3) then
	downloadPaste(args[2], args[3])
elseif(args[1] == "http" and table.getn(args) == 3) then
	downloadHttp(args[2], args[3])
elseif((args[1] == "git" or args[1] == "github") and table.getn(args) >= 6) then
	downloadGit(args[2], args[3], args[4], args[5], args[6])
else
	err("Invalid mode.")
end

reset()
outputln("Downloading Program: " .. args[table.getn(args)])
bar()
outputln("\tFrom: " .. args[2])
outputln("\tVia: " .. args[1])
bar()
outputln("Done.", colors.lime)
bar()
outputln("")
output("Press any key to continue.")
io.read()
