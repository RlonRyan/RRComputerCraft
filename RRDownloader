-- Computer Program Downloader Agent
-- By RlonRyan
--
-- PpKH1HS8
--
-- This program allows for the easy download of RR|Programs (for computercraft).

args = {...}

local overwrite = true

function checkVersion(path)
  -- Todo
  return false
end

function validate(path)
  if(not fs.exists(dir)) then
    fs.makedir(string.match(path, ".*/"))
    return true
  elseif(not fs.exists(path))
    return true
  elseif(not checkversion)
    fs.delete(path)
    return true
  elseif(overwrite)
    fs.delete(path)
    return true
  else
    return false
  end
end

function downloadPaste(paste, path)
  if(not validate(path)) then
    return false
  else
    return shell.run("pastebin", get", paste, path)
  end
end

function downloadGit(user, repo, branch, file, path)
  if(not validate(path))
    return false
  else
    temp = http.get("https://raw.github.com/" .. user .. "/" .. repo .. "/" .. branch .. "/" .. file)
    if(temp) then
      content = temp.readAll()
      temp.close()
      temp = fs.open(path, "w")
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

for ipair
