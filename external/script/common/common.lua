--One-time load of the json routines
local json = (loadfile 'external/script/dkjson.lua')()

-- Get the one lime loaded JsonParser
function getJSONparser()
    return json
end

--debug table printing
function pt(t)
    print(table.concat(t, ','))
end

--check if a file or directory exists in this path
function f_exists(file)
    local ok, err, code = os.rename(file, file)
    if not ok then
        if code == 13 then
            --permission denied, but it exists
            return true
        end
    end
    return ok, err
end

--check if a directory exists in this path
function f_isdir(path)
    -- "/" works on both Unix and Windows
    return f_exists(path .. '/')
end

--check if file exists
function f_fileExists(file)
    if file == '' then
        return false
    end
    local f = io.open(file,'r')
    if f ~= nil then
        io.close(f)
        return true
    end
    return false
end

--fix for wrong x coordinate after flipping text/sprite (this should be fixed on source code level at some point)
function alignOffset(align)
    if align == -1 then
        return 1
    end
    return 0
end

--return table with key names
function f_extractKeys(str)
    local t = {}
    for i, c in ipairs(main.f_strsplit('%s*&%s*', str)) do --split string using "%s*&%s*" delimiter
        t[i] = c
    end
    return t
end

-- return a file with given accesProperty
-- @param motifFile the file to be retrieved
-- @param accesProperty the provided accesProperty (Read r, Write w+)
function getFile(motifFile, accesProperty)
    local file = io.open(motifFile, accesProperty)
    local content = file:read("*all")
    file:close()
    return content
end