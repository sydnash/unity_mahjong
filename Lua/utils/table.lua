--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local json = require("utils.json")

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
    return json.encode(tb, true)
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function table.fromjson(js)
    local tb, err = json.decode(js)
    assert(err == nil, err)

    return tb
end

-------------------------------------------------------------------
--
-------------------------------------------------------------------
function table.tostring(t, _n)
	if not appConfig.debug then return '' end 

	if t == nil then return 'nil' end
	if type(t) ~= 'table' then return '' end

	local _t = {}
	--_n = _n or 0
	function _t:_tostring(t, n)
		if _n and n > _n then return '' end

		self[t] = n
		local str = {}
		local fmt = {}

		n = n or 0
		for i=1,n do
			fmt[#fmt+1] = '  '
		end
		local fmt_str = table.concat(fmt)

		str[#str+1] = '{\n'
		if type(t) ~= 'table' then
			logError('not table' .. debug.traceback())
		end

		for k,v in pairs(t) do
			if type(v) == 'table' and not self[v] then
				if type(k) == 'number' then
					key = "[" .. tostring(k) .. "]"
				else
					key = tostring(k)
				end
				str[#str+1] = string.format('  %s%s=', fmt_str, key)
				str[#str+1] = self:_tostring(v, n+1)
			elseif type(v) == 'string' then
				local key
				if type(k) == "number" then
					key = '[' .. tostring(k) .. ']'
				else
					key = tostring(k)
				end
				str[#str+1] = string.format("  %s%s='%s',\n", fmt_str, key, tostring(v))
			else
				local key
				if type(k) == "number" then
					key = "[" .. tostring(k) .. "]"
				else
					key = tostring(k)
				end
				str[#str+1] = string.format("  %s%s='%s',\n", fmt_str, key, tostring(v))
			end
		end
		str[#str+1] = fmt_str..'},\n'

		return table.concat(str)
	end

	return _t:_tostring(t, 0)
end

--endregion
