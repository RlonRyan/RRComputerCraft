-- Program Setup
-- By RlonRyan
--
-- 94rbEkV7
--
-- This program downloads pastebin computercraft programs supplied to it in a name, pastecode pair in its arguments.
-- This program is intended for use by the RR|Computer Program.

-- Obtain arguments
local arg = { ... }

-- Get filepath
path = shell.getRunningProgram() .. "Resources"

-- Clean up the screen
term.clear()
term.setCursorPos(1,1)

	print("RR|Program Setup")
	print("================")
	print("Install List:")

	for i=1,table.getn(arg),2 do
		print("\t" .. arg[i])
	end

	for i=1,table.getn(arg),2 do
		name = arg[i]
		address = arg[i + 1]
		if (not (address == nul or address == "")) then
			print("================")
			print("Obtaining program: " .. name)
			while(fs.exists(name)) do
				term.clear()
				term.setCursorPos(1,1)
				print("RR|Program Setup")
				print("================")
				print("File: " .. name .. " already exists!")
				write("Overwrite? (y/n):")
				if (io.read() == "y") then
					fs.delete(name)
				else
					write("Rename? (y/n):")
					if io.read() == "y" then
						print("Enter new name: ")
						name = io.read()
					else
						print(name .. " skipped.")
						break
					end
				end
			print("================")
		end
		
		write("Set as startup? (y/n): ")
		
		if(io.read() == "y") then
			startup = fs.open("startup", "w")
			startup.write("shell.run(\"" .. name .. "\")")
			startup.close()
		end
		
		print("================")
		
		shell.run("pastebin get " .. address .. " " .. name)
	else
		print("Malformed parameters. Program skipped.")
	end
end

print("================")
print("Setup complete.")
print("================")
