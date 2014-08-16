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
  if(not fs.exists(dir)) then
    fs.makedir(string.match(filepath, ".*/"))
    return true
  elseif(not fs.exists(filepath))
    return true
  elseif(not checkversion)
    fs.delete(filepath)
    return true
  elseif(overwrite)
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
    return shell.run("pastebin", get", paste, filepath)
  end
end

function downloadHttp(address, filepath)
  if(not validate(filepath))
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
      temp.close()
      return false
    end
  end
end

function downloadGit(user, repo, branch, file, filepath)
  downloadHttp("https://raw.github.com/" .. user .. "/" .. repo .. "/" .. branch .. "/" .. file, filepath)
end

function downloadGitHttp(address, file, filepath)
  downloadHttp("https://raw.github.com/" .. user .. "/" .. repo .. "/" .. branch .. "/" .. file, filepath)
end

if(args[1] == "git") then
  local mode,user,repo,branch,file,filepath = args
  downloadGit(user, repo, branch, file, filepath)
elseif(args[1] == "githttp") then
  downloadHttp(args[2], args[3])
elseif(args[1] == "http") then
  downloadHttp(args[2], args[3])
elseif(args[1] == "githttpmanifest") then
  for k,v in pairs(args[3]) do
    downloadGitHttp(args[2], k, v["program"])
  end
else
  print("Invalid mode.")
end
