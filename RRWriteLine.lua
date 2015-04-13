-- Write Program
-- By RlonRyan

args = {...}

function validate(filepath)
  if(string.find(filepath, "/") and not fs.exists(string.match(filepath, "%a+"))) then
    fs.makeDir(string.match(filepath, "%a+"))
    return true
  elseif(not fs.exists(filepath)) then
    return true
  else
    return true
  end
end

line = ""

for i = 3,table.getn(args) do
  line = line .. " " .. args[i]
end

if(validate(args[1])) then
    
  temp = fs.open(args[1], args[2])
    
  if(not temp) then
    print("Cannot write file: " .. filepath)
    temp.close()
    return false
  end
    
  temp.writeLine(line)
  temp.close()
  return true
    
end
