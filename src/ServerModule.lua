--[[
IMPORTANT!!!!!! THE MODULE WILL NOT WORK IF YOU DO NOT FOLLOW THESE STEPS
You need to add 3 RemoteEvents as children of this modulescript. I would add
an auto-setup if I knew how (would need a server script to do setup and that would complicate things :/)

Name them the following:
"FireClientTweenInstance"
"FireClientTweenInstanceFull"
"FireClientTweenModel"

]]--

-- MODULESCRIPT (Should be placed in ReplicatedStorage)
local ts = game:GetService("TweenService")
local AstraTween = {}

function AstraTween:checkStyle(input)
	if typeof(input) == "EnumItem" then
		return input
	elseif typeof(input) == "string" then
		return Enum.EasingStyle[input]
	else
		warn("Invalid EasingStyle!")
	end
end

function AstraTween:checkDir(input)
	if typeof(input) == "EnumItem" then
		return input
	elseif typeof(input) == "string" then
		return Enum.EasingDirection[input]
	else
		warn("Invalid EasingDirection!")
	end
end

function AstraTween:checkModel(input)
	if typeof(input) == "Instance" then
		if input:IsA("Model") then
			return input
		else
			warn("TweenModel: Target is not a model!")
			return input
		end
	else
		warn("TweenModel: Target is not a model!")
		return input
	end
end

function AstraTween:checkUIInput(input)
	if typeof(input) == "Instance" then
		if input:IsA("UIComponent") then
			return input
		else
			warn("TweenModel: Target is not a UI component!")
			return input
		end
	else
		warn("TweenModel: Target is not a instance!")
		return input
	end
end

function AstraTween:checkInstanceInput(input)
	if typeof(input) == "Instance" then
		return input
	else
		warn("TweenModel: Target is not a instance!")
		return input
	end
end

function AstraTween:CheckGoalTable(input)
	if type(input) == "table" then
		return input
	else
		warn("GoalTable is not a table!")
		return input
	end
end

function AstraTween:checkGoalCFrame(input)
	if typeof(input) == "CFrame" then
		return input
	elseif typeof(input) == "Instance" then
		if input:IsA("BasePart") or input:IsA("UnionOperation") then
			return input.CFrame
		end
	elseif typeof(input) == "Vector3" then
		return CFrame.new(input)
	else
		warn("Invalid End Goal! (CFrame, Vector3, or Part/Union)")
	end
end

function AstraTween:TweenModel(model:Model, time:number, style:Enum.EasingStyle, direction:Enum.EasingDirection, goalPosition)
	coroutine.wrap(function()	
		local model = AstraTween:checkModel(model)
		local style = AstraTween:checkStyle(style)
		local dir = AstraTween:checkDir(direction)
		local endCF = AstraTween:checkGoalCFrame(goalPosition)
		if model.PrimaryPart then
			script.FireClientTweenModel:FireAllClients(model, time, style, dir, endCF)
			wait(time)
			model:PivotTo(endCF)	
		else
			warn("Model does not have a PrimaryPart!")
			return
		end
	end)()
end

function AstraTween:TweenInstance(target:Instance, time:number, style:Enum.EasingStyle, direction:Enum.EasingDirection, goalTable)
	coroutine.wrap(function()
		target = AstraTween:checkInstanceInput(target)
		style = AstraTween:checkStyle(style)
		direction = AstraTween:checkDir(direction)
		goalTable = AstraTween:CheckGoalTable(goalTable)

		if target then
			script.FireClientTweenInstance:FireAllClients(target, time, style, direction, goalTable)
			wait(time)
			for i, v in pairs(goalTable) do
				target[i] = v
			end
		end
	end)()
end

function AstraTween:TweenInstanceFull(target:Instance, time:number, style:Enum.EasingStyle, direction:Enum.EasingDirection, repCount:number, reverses:boolean, delayTime:number, goalTable)
	coroutine.wrap(function()
		target = AstraTween:checkInstanceInput(target)
		style = AstraTween:checkStyle(style)
		direction = AstraTween:checkDir(direction)
		goalTable = AstraTween:CheckGoalTable(goalTable)

		if target then
			script.FireClientTweenInstanceFull:FireAllClients(target, time, style, direction, repCount, reverses, delayTime, goalTable)
			wait(time)
			for i, v in pairs(goalTable) do
				target[i] = v
			end
		end
	end)()
end

return AstraTween

