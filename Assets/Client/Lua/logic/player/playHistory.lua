local playHistory = class("playHistory_data")

function playHistory:ctor()
    self.mDatas = {}
    self.mLastTime = 0
end

function playHistory:setData(data)
    if data == nil then
        return
    end
    if self.mDatas == nil then
        self.mDatas = data
    else
        self:insertHistory(data)
    end
    self:sort()
end

function playHistory:sort()
    if not self.mDatas then 
        return
    end
    self.mLastTime = 0
    for _, v in pairs(self.mDatas) do
        if self.mLastTime < v.EndTime then
            self.mLastTime = v.EndTime
        end
    end
    local function comp(m1, m2)
        if m1.EndTime >= m2.EndTime then
            return true
        end
        return false
    end
    table.bubbleSort(self.mDatas, comp)
end

function playHistory:findHistoryById(id)
    for _, v in pairs(self.mDatas) do
        if v.Id == id then
            return v
        end
    end
    return nil
end

function playHistory:insertHistory(data)
    for _, v in pairs(data) do
        local cacheMail = self:findHistoryById(v.Id)
        if not cacheMail then
            table.insert(self.mDatas, v)
        end
    end
end

function playHistory:getData()
	if self.mDatas == nil then
		self.mDatas = {}
	end
    return self.mDatas
end

function playHistory:getLastTime()
    return self.mLastTime
end

function playHistory:updateHistory(cb)
    networkManager.getPlayHistory(self.mLastTime, function(ok, data)
        log("deskhistory:updatehistory " .. table.tostring(data))
        if not ok then
            if cb then cb(false) end
            return
        end
        self:setData(data)
        if cb then cb(true) end
    end)
end

function playHistory:getScoreDetail(id, cb)
end

return playHistory