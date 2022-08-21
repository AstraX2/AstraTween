-- LOCALSCRIPT (Should be a descendant of StarterPlayerScripts)
local rootPath = game.ReplicatedStorage -- Change this to wherever AstraTween is parented to. Defaults to game.ReplicatedStorage
local astraTween = rootPath:WaitForChild("AstraTween")
local ts = game:GetService("TweenService")

local function executeTweenModel(model, time, style, dir, endCF)
	local tempCFV = Instance.new("CFrameValue")
	tempCFV.Value = model.PrimaryPart.CFrame
	local ti = TweenInfo.new(time, style, dir)
	local connection = tempCFV.Changed:Connect(function(newCF)
		model:PivotTo(newCF)
	end)
	local tween = ts:Create(tempCFV, ti, {Value = endCF})
	tween:Play()
	tween.Completed:Connect(function()
		connection:Disconnect()
		tempCFV:Destroy()
	end)
end

local function executeTweenInstance(target, time, style, dir, goalTable)
	local ti = TweenInfo.new(time, style, dir)
	local tween = ts:Create(target, ti, goalTable)
	tween:Play()
end

local function executeTweenInstanceFull(target, time, style, dir, repCount, rev, delCount, goalTable)
	local ti = TweenInfo.new(time, style, dir, repCount, rev, delCount)
	local tween = ts:Create(target, ti, goalTable)
	tween:Play()
end

astraTween.FireClientTweenModel.OnClientEvent:Connect(function(model, time, style, dir, endCF)
	coroutine.wrap(executeTweenModel)(model, time, style, dir, endCF)
end)
astraTween.FireClientTweenInstance.OnClientEvent:Connect(function(target, time, style, dir, goalTable)
	coroutine.wrap(executeTweenInstance)(target, time, style, dir, goalTable)
end)
astraTween.FireClientTweenInstanceFull.OnClientEvent:Connect(function(target, time, style, direction, repCount, reverses, delayTime, goalTable)
	coroutine.wrap(executeTweenInstanceFull)(target, time, style, direction, repCount, reverses, delayTime, goalTable)
end)
