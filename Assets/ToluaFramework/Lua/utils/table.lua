--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local json = require("utils.json")
-- local json = require("cjson")

table.empty = {}

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function table.swap(t, ka, kb)
    local a = t[ka]
    t[ka] = t[kb]
    t[kb] = a
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function table.removeItem(t, o)
    for k, v in pairs(t) do
        if v == o then
            table.remove(t, k)
            break    
        end
    end
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function table.tojson(tb)
    return json.encode(tb)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function table.fromjson(js)
    if string.isNilOrEmpty(js) then
        return nil 
    else
        return json.decode(js)
    end
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function table.tostring(object)
    local lookupTable = {}
    local result = {}

    local function _v(v)
        if type(v) == "string" then
            v = "\"" .. v .. "\""
        end
        return tostring(v)
    end

    local function _vardump(object, label, indent, nest)
        --label = label or "<var>"
        local postfix = ""
        if nest > 1 then postfix = "," end
        if type(object) ~= "table" then
            if type(label) == "string" and #label > 0 then
                result[#result +1] = string.format("%s[\"%s\"] = %s%s", indent, label, _v(object), postfix)
            elseif type(label) == "number" then
                result[#result +1] = string.format("%s[%d] = %s%s", indent, label, _v(object), postfix)
            else
                result[#result +1] = string.format("%s%s%s", indent, _v(object), postfix)
            end
        elseif not lookupTable[object] then
            lookupTable[object] = true

            if type(label) == "string" and #label > 0  then
                result[#result +1 ] = string.format("%s[\"%s\"] = {", indent, label)
            elseif type(label) == "number" then
                result[#result +1 ] = string.format("%s[%d] = {", indent, label)
            else
                result[#result +1 ] = string.format("%s{", indent)
            end

            local indent2 = indent .. "    "
            local keys = {}
            local values = {}
            for k, v in pairs(object) do
                keys[#keys + 1] = k
                values[k] = v
            end

            table.sort(keys, function(a, b)
                if type(a) == "number" and type(b) == "number" then
                    return a < b
                else
                    return tostring(a) < tostring(b)
                end
            end)

            for i, k in ipairs(keys) do
                _vardump(values[k], k, indent2, nest + 1)
            end

            result[#result +1] = string.format("%s}%s", indent, postfix)
        end
    end

    _vardump(object, "", "", 1)
    return table.concat(result, "\n")
end


function table.bubbleSort(t, comp, len)
    if not comp then
        comp = function (a1, a2)
            return a1 < a2
        end
    end
    len = len or #t

    if len <= 1 then
        return
    end

    local s = len - 1
    local e = len - 1
    local tmp
    for j = 1, e do 
        s = len - j
        for i = s, e do
            if not comp(t[i], t[i + 1]) then
                tmp = t[i + 1]
                t[i + 1] = t[i]
                t[i] = tmp
            else 
                break
            end
        end
    end
end
-------------------------------------------------------------------
--
-------------------------------------------------------------------
local function escape(k)
    local ret = k
    if type(ret) ~= "string" then
        ret = tostring(ret)
    end
    ret = string.gsub(k, "[^a-zA-Z0-9%-_%.!%*]", function (c)
        return string.format("%%%02X", string.byte(c))
    end)
    ret = string.gsub(ret, " ", "+")
    return ret
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function table.toUrlArgs(t)
    local b = {}
    for k, v in pairs(t) do
        b[#b + 1] = (escape(k) .. "=" .. escape(v))
    end
    return table.concat(b, "&")
end 

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function table.clone(t)
    local lookup_table = {}

    local function _copy(o)
        if type(o) ~= "table" then 
            return o
        elseif lookup_table[o] then
            return lookup_table[o]
        end

        local new_table = {}
        lookup_table[o] = new_table

        for key, value in pairs(o) do
            new_table[_copy(key)] = _copy(value)
        end

        return setmetatable(new_table, getmetatable(o))
    end

    return _copy(t)
end

--endregion
