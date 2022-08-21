--[[
{EXPERIMENTAL BRANCH CHANGES}
* Replacing wait() with task.wait() (idk why i didn't do this before)
* Attempting to remove the need for manual RemoteEvent setup

- removed any functions used in TweenUI (there's no need for it)


-- main branch notes ---------------------------------------------------------------------------------------
IMPORTANT!!!!!! THE MODULE WILL NOT WORK IF YOU DO NOT FOLLOW THESE STEPS
You need to add 3 RemoteEvents as children of this modulescript. I would add
an auto-setup if I knew how (would need a server script to do setup and that would complicate things :/)

Name them the following:
"FireClientTweenInstance"
"FireClientTweenInstanceFull"
"FireClientTweenModel"
------------------------------------------------------------------------------------------------------------

]]--

-- MODULESCRIPT (Should be placed in ReplicatedStorage)
local ts = game:GetService("TweenService")
local AstraTween = {}

local _fireCTIrem, _fireCTIFrem, _fireCTMrem -- fireClientTweenInstance, fireClientTweenInstanceFull, fireClientTweenModel (will be set later)

local remotes = {["FireClientTweenInstance"] = _fireCTIrem, ["FireClientTweenInstanceFull"] = _fireCTIFrem, ["FireClientTweenModel"] = _fireCTMrem}

function AstraTween:getRemote(name):RemoteEvent
  if remotes[name] then
    return remotes[name]
  else
    local named = script:FindFirstChild(name)
    if named then
      remotes[name] = named
      return named
    end

    local newRemote = Instance.new("RemoteEvent")
    newRemote.Name = name
    newRemote.Parent = script
    remotes[name] = newRemote
    return newRemote
  end
end

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
	local model = AstraTween:checkModel(model)
	local style = AstraTween:checkStyle(style)
	local dir = AstraTween:checkDir(direction)
	local endCF = AstraTween:checkGoalCFrame(goalPosition)
                        
	if model.PrimaryPart then
		AstraTween:getRemote("FireClientTweenModel"):FireAllClients(model, time, style, dir, endCF)
		task.delay(time, function()
		        model:PivotTo(endCF)	
                end)
	else
		warn("Model does not have a PrimaryPart!")
		return
	end
end

function AstraTween:TweenInstance(target:Instance, time:number, style:Enum.EasingStyle, direction:Enum.EasingDirection, goalTable)
	target = AstraTween:checkInstanceInput(target)
	style = AstraTween:checkStyle(style)
	direction = AstraTween:checkDir(direction)
	goalTable = AstraTween:CheckGoalTable(goalTable)

	if target then
		AstraTween:getRemote("FireClientTweenInstance"):FireAllClients(target, time, style, direction, goalTable)
		task.delay(time, function()
		        for i, v in pairs(goalTable) do
			        target[i] = v
			end
                end)
	end
end

function AstraTween:TweenInstanceFull(target:Instance, time:number, style:Enum.EasingStyle, direction:Enum.EasingDirection, repCount:number, reverses:boolean, delayTime:number, goalTable)
	target = AstraTween:checkInstanceInput(target)
	style = AstraTween:checkStyle(style)
	direction = AstraTween:checkDir(direction)
	goalTable = AstraTween:CheckGoalTable(goalTable)
	
        if target then
		AstraTween:getRemote("FireClientTweenInstanceFull"):FireAllClients(target, time, style, direction, repCount, reverses, delayTime, goalTable)
		task.delay(time, function()
		        for i, v in pairs(goalTable) do
		        	target[i] = v
		        end
                end)
	end
end

return AstraTween

