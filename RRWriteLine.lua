-- Write Program
-- By RlonRyan

args = {...}

function validate(filepath, overwrite)
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

line = ""

for i = 3,table.getn(args) do
  line = line .. args[i]
end

if(validate(args[1], args[2] == "a")) then
    
  temp = fs.open(filepath, args[1])
    
  if(not temp) then
    print("Cannot write file: " .. filepath)
    return false
  end
    
  temp.write()
  temp.close()
  return true
    
end
