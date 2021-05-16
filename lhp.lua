
local lhp = require "liblhp"

local tArgs = { ... }
local sInputPath = tArgs[1]
local sOutputPath = tArgs[2]
if not sInputPath then
    io.stderr:write( "Usage: lhp <inputfile> [<outputfile>]" )
    return
end

if sOutputPath then
	local outputFile = io.open(sOutputPath, "w")
	if not outputFile then
        error( "Could not open file for writing: "..sOutputPath, 0 )
	end
	io.output(outputFile)
end

lhp.dofile(sInputPath)
