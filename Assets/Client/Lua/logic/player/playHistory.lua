local playHistory = class("playHistory_data")

function playHistory:ctor(clubId)
    self.mDatas = {}
    self.mLastTime = 0
    self.mClubId = clubId
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
        local cached = self:findHistoryById(v.Id)
        if not cached then
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

--for normal
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
    local history = self:findHistoryById(id)
    if history.PlayTimes == 0 or (history.ScoreDetail and #history.ScoreDetail == history.PlayTimes) then
		cb(true, history.ScoreDetail)
		return
	end
    networkManager.getPlayHistoryDetail(0, history.Id, 0, function(ok, data)
        if not ok then
            cb(false)
            return 
        end
        if data.RetCode ~= retc.ok then
            cb(true, nil)
            return
        end
		history.ScoreDetail = data.ScoreDetail
		cb(true, history.ScoreDetail)
	end)
end
function playHistory:getPlayDetail(id, round, cb)
    local history = self:findHistoryById(id)

    if history.PlaybackMsg == nil then
		history.PlaybackMsg = {}
	end

    if history.PlaybackMsg[round] then
        cb(true, history.PlaybackMsg[round])
		return
	end
	
    networkManager.getPlayHistoryDetail(2, id, round - 1, function(ok, data)
        if not ok then
            cb(false)
            return 
        end

        if data.RetCode ~= retc.ok or data.OnePlayback == "" then
            cb(true, nil) --战绩回放不存在
            return
        end

        history.PlaybackMsg[round] = data.OnePlayback
        cb(true, history.PlaybackMsg[round])
    end)
end

return playHistory
