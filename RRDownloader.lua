-- Computer Program Downloader Agent
-- By RlonRyan
--
-- PpKH1HS8
--
-- This program allows for the easy download of RR|Programs (for computercraft).

args = {...}

local overwrite = true

function checkVersion(filepath)
  -- Todo
  return false
end

function validate(filepath)
  if(not fs.exists(string.match(filepath, "&a+"))) then
    fs.makedir(string.match(filepath, "&a+"))
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

function downloadPaste(paste, filepath)
  if(not validate(filepath)) then
    return false
  else
    return shell.run("pastebin", "get", paste, filepath)
  end
end

function downloadHttp(address, filepath)
  if(not validate(filepath)) then
    return false
  else
    temp = http.get(address)
    if(temp) then
      content = temp.readAll()
      temp.close()
      temp = fs.open(filepath, "w")
      temp.write(content)
      return true
    else
      print("Unable to fetch file. Is the internet down?")
      print("Or have you not yet enabled http for computercraft?")
      return false
    end
  end
end

function getManifest(address)
  temp = http.get(address .. "/manifest.mf")
  if(temp) then
    manifest = textutils.unserialize(temp.readAll())
    manifest = textutils.unserialize(temp.readAll())
    temp.close()
    print(manifest[RRComputer]["author"])
    return manifest
  else
    print("Unable to fetch file. Is the internet down?")
    print("Or have you not yet enabled http for computercraft?")
    return false
  end
end

function downloadGitAddress(address)
  for k,v in pairs(getManifest(address)) do
    downloadGitHttp(address .. "/" .. v["file"], v["program"])
  end
end

function downloadGit(user, repo, branch)
  address = "https://raw.githubusercontent.com/" .. user .. "/" .. repo .. "/" .. branch
  print(address)
  for k,v in pairs(getManifest(address)) do
    downloadGitHttp(address .. "/" .. v["file"], v["program"])
  end
end

if(args[1] == "git" and table.getn(args) == 2) then
  downloadGitAddress(args[2])
elseif(args[1] == "git" and table.getn(args) >= 4) then
  downloadGit(args[2], args[3], args[4])
elseif(args[1] == "http") then
  downloadHttp(args[2], args[3])
else
  print("Invalid mode.")
end
