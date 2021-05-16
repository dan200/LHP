
local lhp = {}

local CODE_START = "<?lua"
local CODE_END = "?>"
local ESCAPED_NEWLINE = "\\\n"

local function load_impl( sInput, sChunkName, env )
	local tFunctions = {}
	
	local nPos = 1
	while nPos <= sInput:len() do
		local nCodeStart = string.find( sInput, CODE_START, nPos, true )
		if nCodeStart == nPos then
			local nCodeEnd = string.find( sInput, CODE_END, nPos + 1, true )
			local sCode
			if nCodeEnd then
				sCode = string.sub( sInput, nCodeStart + CODE_START:len(), nCodeEnd - 1 )
				nPos = nCodeEnd + CODE_END:len()
			else
				sCode = string.sub( sInput, nCodeStart + CODE_START:len() )
				nPos = sInput:len() + 1
			end
			if setfenv then
				-- Lua 5.1
				local fnCode, err = loadstring( sCode, sChunkName )
				if fnCode then
					err = nil
					setfenv( fnCode, env )
					table.insert( tFunctions, fnCode )
				end
			else
				-- Lua 5.3
				local fnCode, err = load( sCode, sChunkName, "t", env )
				if fnCode then
					err = nil
					table.insert( tFunctions, fnCode )
				end
			end
			if err then
				return false, err
			end
		else
			local sText
			if nCodeStart then
				sText = string.sub( sInput, nPos, nCodeStart - 1 )
				nPos = nCodeStart
			else
				sText = string.sub( sInput, nPos )				
				nPos = sInput:len() + 1
			end
			while sText do
				local nEscapedNewline = string.find( sText, ESCAPED_NEWLINE )
				if nEscapedNewline then
					local sFragment = string.sub( sText, 1, ESCAPED_NEWLINE - 1 )
					table.insert( tFunctions, function() io.write(sFragment) end )
					sText = string.sub( sText, nEscapedNewline + ESCAPED_NEWLINE:len() )
				else
					local sFragment = sText
					table.insert( tFunctions, function() io.write(sFragment) end )
					sText = nil
				end
			end
		end
	end
	
	return function()
		for n=1,#tFunctions do
			tFunctions[n]()
		end
	end
end

local function run_impl( sInput, sChunkName, env )
	local fnCode, err = load_impl( sInput, sInputPath, env )
	if fnCode then
		fnCode()
	else
		error(err, 0 )
	end
end

local function dofile_impl( sPath, env )
	local inputFile = io.open(sPath, "r")
	if not inputFile then
		error( "Could not open file for reading: "..sPath )
	end

	local sReadAll = (setfenv and "*a") or "a"
	local sInput = inputFile:read(sReadAll)
	inputFile:close()

	run_impl( sInput, sPath, env )
end

local function make_new_environment()
	local env = {}
	for k,v in pairs(_G) do
		env[k] = v
	end
	env.include = function( sPath )
		dofile_impl( sPath, env )
	end
	env.print = function( ... )
		io.write(table.concat({...}, "\t"))
		io.write("\n")
	end
	env.echo = io.write	
	return env
end

-- Compile the input text to an executable function
function lhp.load( sInput, sChunkName )
	return load_impl( sInput, sChunkName, make_new_environment() )
end

-- Compile the input text and immediately run it
function lhp.run( sInput, sChunkName )
	return run_impl( sInput, sChunkName, make_new_environment() )
end

-- Read the contents of the given file and immediately compile and execute it
function lhp.dofile( sPath )
	return dofile_impl( sPath, make_new_environment() )
end

return lhp
