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

function playHistory:getHistoryFunc()
    if self.mClubId == nil then
        return networkManager.getPlayHistory
    else
        return function(lasttime, callback)
            networkManager.queryFriendsterStatistics(self.mClubId, lasttime, callback)
        end
    end
end

function playHistory:getHistoryDetailFunc()
    if self.mClubId == nil then
        return networkManager.getPlayHistoryDetail
    else
        return function(typ, historyId, round, callback)
            networkManager.getClubPlayHistoryDetail(self.mClubId, typ, historyId, round, callback)
        end
    end
end

--for normal
function playHistory:updateHistory(callback)
    local func = self:getHistoryFunc()
    func(self.mLastTime, function(data)
        if data == nil then
            if callback then callback(false) end
            return
        end

        self:setData(data)
        if callback then callback(true) end
    end)
end

function playHistory:getScoreDetail(id, callback)
    local history = self:findHistoryById(id)

    if history.PlayTimes == 0 or (history.ScoreDetail and #history.ScoreDetail == history.PlayTimes) then
		callback(true, history.ScoreDetail)
		return
    end
    
    local func = self:getHistoryDetailFunc()
    func(0, history.Id, 0, function(data)
        if data == nil then
            callback(false)
            return 
        end

        if data.RetCode ~= retc.ok then
            callback(true, nil)
            return
        end
		
        history.ScoreDetail = data.ScoreDetail
		callback(true, history.ScoreDetail)
	end)
end

function playHistory:getPlayDetail(id, round, callback)
    local history = self:findHistoryById(id)

    if history.PlaybackMsg == nil then
		history.PlaybackMsg = {}
	end

    if history.PlaybackMsg[round] then
        callback(true, history.PlaybackMsg[round])
		return
	end
	
    local func = self:getHistoryDetailFunc()
    func(2, id, round - 1, function(data)
        if data == nil then
            callback(false)
            return 
        end

        if data.RetCode ~= retc.ok or string.isNilOrEmpty(data.OnePlayback) then
            callback(true, nil) --战绩回放不存在
            return
        end

        history.PlaybackMsg[round] = data.OnePlayback
        callback(true, history.PlaybackMsg[round])
    end)
end

return playHistory
