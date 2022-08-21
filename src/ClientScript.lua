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

-- Name to Function dict for remoteevent names (used in below function)
local NtF = {
	["FireClientTweenModel"] = executeTweenModel,
	["FireClientTweenInstance"] = executeTweenInstance,
	["FireClientTweenInstanceFull"] = executeTweenInstanceFull,
}

-- Block to connect RemoteEvents as they are made, removes the need for pre-making remote events
astraTween.ChildAdded:Connect(function(child)
	if child.ClassName == "RemoteEvent" and NtF[child.Name] then
		require(astraTween):getRemote(child.Name).OnClientEvent:Connect(NtF[child.Name])
	end	
end)
