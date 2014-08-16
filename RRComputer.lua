-- Computer Program Agent
-- By RlonRyan
--
-- PpKH1HS8
--
-- This program allows for the easy setup of RR|Programs (for computercraft).
-- It will also attempt to update RR|Programs when run.
-- It uses the RR|Programs list (jpvAAJS5) found on pastebin to find programs.
-- It also uses the RR|Install program (94rbEkV7) to download and install those programs.
--
-- Dependencies:
-- Bedrock GUI
-- (All dependencies will auto-download and install)
--
-- Installation instructions:
-- Use: pastebin get PpKH1HS8 RR|Computer
--
-- Install disk instructions:
-- Save the line:
-- shell.run("pastebin get PpKH1HS8 RR|Computer")
-- To disk/autorun
--
-- Run instructions:
-- Use: RR|Computer

local path = shell.getRunningProgram() .. "Resources"

term.clear()
term.setCursorPos(1,1)

print("RR|Program Setup")
print("================")
print("Validating Directories")
fs.delete(path)
fs.makeDir(path)
fs.makeDir(path .. "/Views")
print("================")
print("Updating programs list.")
shell.run("pastebin get jpvAAJS5 " .. path .. "/RR|Programs")
list = fs.open(path .. "/RR|Programs", "r")
programs = textutils.unserialize(list.readAll())
list.close()
print("================")
print("Updating installation agent.")
shell.run("pastebin get 94rbEkV7 " .. path .. "/RR|Install")
print("================")
print("Obtaining Dependencies.")
fs.delete("RR|BedrockInstall")
shell.run("pastebin get jBwRtzbG RR|BedrockInstall")
shell.run("RR|BedrockInstall")
-- Fix filepath
Bedrock.ProgramPath = path
-- Obtain view(s)
shell.run("pastebin get F8WKXGGe " .. path .. "/Views/main.view")
print("================")
print("Initialization Completed.")
print("================")

--print("")
--write("Press any key to continue.")
--io.read()

term.clear()
term.setCursorPos(1,1)

print("RR|Program Setup")
print("==================")
print("Available Programs")
print("==================")
menu = {}
i = 1
for k,v in pairs(programs) do
	menu[i] = k
	print(i .. ".) " .. k .. " by " .. v["author"])
	i = i + 1
end
print("==================")
print("Select Programs: ")
print("==================")
run = ""
for selection in string.gmatch(io.read(), "[^%s]+") do
	selection = tonumber(selection)
	run = run .. " " .. programs[menu[selection]]["name"] .. " " .. programs[menu[selection]]["address"]
end
print("==================")
if(run ~= nul) then
	shell.run(path .. "/RR|Install" .. run)
end
