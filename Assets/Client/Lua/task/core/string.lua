
string.empty = ""

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function string.isNilOrEmpty(str)
    return str == nil or str == string.empty
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function string.startsWith(str, val)
    return string.find(str, val) == 1
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function string.endsWith(str, val)
    local rstr = string.reverse(str)  
    local rval = string.reverse(val)
    
    return string.startsWith(rstr, rval) 
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function string.split(input, delimiter)
    input = tostring(input)
    delimiter = tostring(delimiter)
    if (delimiter=='') then return false end
    local pos,arr = 0, {}
    -- for each divider found
    for st,sp in function() return string.find(input, delimiter, pos, true) end do
        table.insert(arr, string.sub(input, pos, st - 1))
        pos = sp + 1
    end
    table.insert(arr, string.sub(input, pos))
    return arr
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function string.ltrim(input)
    return string.gsub(input, "^[ \t\n\r]+", "")
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function string.rtrim(input)
    return string.gsub(input, "[ \t\n\r]+$", "")
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function string.trim(input)
    input = string.gsub(input, "^[ \t\n\r]+", "")
    return string.gsub(input, "[ \t\n\r]+$", "")
end

function string.urlEncode(s)
    s = string.gsub(s, "([^%w%.%- ])", function(c) return string.format("%%%02X", string.byte(c)) end)
    return string.gsub(s, " ", "+")
end
 
function string.urlDecode(s)
    s = string.gsub(s,"+"," ")
    s = string.gsub(s, '%%(%x%x)', function(h) return string.char(tonumber(h, 16)) end)
    return s
end
