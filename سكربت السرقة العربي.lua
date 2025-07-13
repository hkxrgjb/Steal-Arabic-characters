
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/jensonhirst/Orion/main/source"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")

local touchingEnabled = false
local collectedParts = {}


local function notify(text)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = "تنبيه",
			Text = text,
			Duration = 5
		})
	end)
end


local function getPlayerBase()
	local bases = workspace:FindFirstChild("Bases")
	if not bases then
		notify("لم يتم العثور على مجلد Bases")
		return nil
	end

	for i = 1, 8 do
		local base = bases:FindFirstChild("Base" .. i)
		if base then
			local owner = base:FindFirstChild("Owner")
			if owner and owner:IsA("ObjectValue") and owner.Value == player then
				return base
			end
		end
	end
	notify("لم يتم العثور على أرضك")
	return nil
end


local function touch(part)
	local char = player.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	firetouchinterest(hrp, part, 0)
	task.wait(0.03)
	firetouchinterest(hrp, part, 1)
end


local function collectParts()
	collectedParts = {}
	local base = getPlayerBase()
	if not base then return end
	local stands = base:FindFirstChild("Stands")
	if not stands then
		notify("لم يتم العثور على مجلد Stands")
		return
	end

	for i = 1, 27 do
		local stand = stands:FindFirstChild("Stand" .. i)
		if stand then
			local collect = stand:FindFirstChild("Collect")
			if collect and collect:IsA("BasePart") then
				table.insert(collectedParts, collect)
			end
		end
	end

	if #collectedParts > 0 then
		notify("تم العثور على " .. tostring(#collectedParts) .. " من Collect")
	else
		notify("لم يتم العثور على أي Collect في Stand1 إلى Stand27")
	end
end


RunService.RenderStepped:Connect(function()
	if touchingEnabled then
		for _, part in ipairs(collectedParts) do
			touch(part)
		end
	end
end)



local window = OrionLib:MakeWindow({
	Name = "اسرق الشخصيات العربي DARK",
	HidePremium = false,
	SaveConfig = false,
	IntroText = "مرحبا بك في السكربت"
})



local tab = window:MakeTab({
	Name = "الرئيسية",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local tab1 = window:MakeTab({
	Name = "الانتقالات",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})


local tab2 = window:MakeTab({
	Name = "شخصيات فارم",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})


local tab3 = window:MakeTab({
	Name = "السرقة",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})




tab:AddToggle({
	Name = "جمع تلقائي",
	Default = false,
	Callback = function(value)
		touchingEnabled = value
		if value then
			collectParts()
			notify("بدأ جمع Collect")
		else
			notify("تم إيقاف الجمع")
		end
	end
})



local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer

local touchEnabled = false
local connection


local function notify(title, text)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = title,
			Text = text,
			Duration = 5
		})
	end)
end


local function waitForHRP()
	local char = player.Character or player.CharacterAdded:Wait()
	return char:WaitForChild("HumanoidRootPart", 10)
end


local function getPlayerBase()
	local basesFolder = workspace:FindFirstChild("Bases")
	if not basesFolder then return nil end

	for i = 1, 8 do
		local base = basesFolder:FindFirstChild("Base" .. i)
		if base then
			local owner = base:FindFirstChild("Owner")
			if owner and owner:IsA("ObjectValue") and owner.Value == player then
				return base
			end
		end
	end
	return nil
end


local function touchLock(part)
	local hrp = waitForHRP()
	if not hrp or not part then return end
	for i = 1, 2 do
		firetouchinterest(hrp, part, 0)
		task.wait(0.1)
		firetouchinterest(hrp, part, 1)
	end
end


tab:AddToggle({
	Name = "حماية منطقتك",
	Default = false,
	Callback = function(state)
		touchEnabled = state

		if state then
			local base = getPlayerBase()
			if base then
				local lock = base:FindFirstChild("Lock")
				if lock and lock:IsA("BasePart") then
					notify("بدأ اللمس", "يتم الآن لمس Lock الخاص بك بسرعة...")
					connection = RunService.RenderStepped:Connect(function()
						touchLock(lock)
					end)
				else
					notify("خطأ", "لم يتم العثور على Lock داخل أرضك.")
				end
			else
				notify("لم يتم العثور", "لم يتم العثور على أرضك (Base1~Base8).")
			end
		else
			if connection then
				connection:Disconnect()
				connection = nil
			end
			notify("تم الإيقاف", "تم إيقاف لمس Lock.")
		end
	end
})




local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer


local function notify(title, text)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = title,
			Text = text,
			Duration = 3
		})
	end)
end


local function getHRP()
	local char = player.Character or player.CharacterAdded:Wait()
	return char:WaitForChild("HumanoidRootPart", 10)
end


local function teleportTo(part)
	local hrp = getHRP()
	if hrp and part then
		hrp.CFrame = CFrame.new(part.Position + Vector3.new(0, 3, 0))
	end
end


local function interactWithModel(model)
	local interacted = false
	for _, v in ipairs(model:GetDescendants()) do
		if v:IsA("ProximityPrompt") then
			for i = 1, 10 do
				pcall(function()
					fireproximityprompt(v, 0)
					fireproximityprompt(v, 1)
				end)
				task.wait(0.01)
			end
			interacted = true
			break
		end
	end
	return interacted
end


local nameMap = {
	["Chef_Crabracadabra"] = "الشيف كرابرا كدابرا",
	["Tung_Tung_Tung_Sahur"] = "تم تم سحور",
	["Cappuccino_Assassino"] = "كابتشينو القاتل",
	["Bananita_Dolphinita"] = "موزة دلفينة",
	["Tim_Cheese"] = "تيم الجبنة",
	["Noobini_Pizzanini"] = "النوبي بيتزا",
	["Chimpanzini_Bananini"] = "شمبانزي موزي",
	["Ballerina_Cappuccina"] = "راقصة الكابتشينو",
	["Bombombini_Gusini"] = "بومبوم غوزيني",
	["Los_Tralaleritos"] = "فرقة ترالاليريتوس",
	["Bombardiro_Crocodilo"] = "قاذف التماسيح",
	["Hacked_Tung_Tung_Tung_Sahur"] = "المخترق - تم تم سحور",
	["Tralalero_Tralala"] = "ترالاليرو ترالالا",
	["Orangutini_Ananassini"] = "أورانغوتان الأناناس"
}

local selectedName = nil
local isRunning = false


tab2:AddDropdown({
	Name = "اختر الهدف",
	Default = nil,
	Options = (function()
		local out = {}
		for _, v in pairs(nameMap) do table.insert(out, v) end
		return out
	end)(),
	Callback = function(value)
		for eng, arab in pairs(nameMap) do
			if arab == value then
				selectedName = eng
				notify("تم اختيار الهدف", value)
				break
			end
		end
	end
})


tab2:AddToggle({
	Name = "تشغيل التفاعل المستمر",
	Default = false,
	Callback = function(value)
		isRunning = value
		if value then
			notify("التفاعل بدأ", "جاري البحث والتفاعل...")
		else
			notify("تم الإيقاف", "تم إيقاف التفاعل.")
		end
	end
})


task.spawn(function()
	while true do
		task.wait(0.25)

		if not isRunning or not selectedName then continue end

		local moving = workspace:FindFirstChild("MovingOn")
		if not moving then continue end

		for _, model in ipairs(moving:GetChildren()) do
			if model:IsA("Model") and model.Name == selectedName then
				local inBase = model:FindFirstChild("InBase")
				if inBase and inBase:IsA("BoolValue") and inBase.Value == true then
					continue
				end

				local proxy = model:FindFirstChild("Proxy")
				if proxy and proxy:IsA("BasePart") then
					local origin = getHRP().CFrame
					teleportTo(proxy)
					task.wait(0.05)

					local success = interactWithModel(model)
					task.wait(0.05)

					getHRP().CFrame = origin

					if success then
						local originalName = model.Name
						model.Name = originalName .. "_Used"

						task.delay(8, function()
							if model and model.Parent then
								model.Name = originalName
							end
						end)
					end
				end
			end
		end
	end
end)




local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer

local selectedBaseName = nil
local selectedStand = nil
local baseDropdown
local standDropdown
local attackAndStealEnabled = false

local function notify(title, text)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = title,
			Text = text,
			Duration = 4
		})
	end)
end

local function getHRP()
	local char = player.Character or player.CharacterAdded:Wait()
	return char:WaitForChild("HumanoidRootPart", 10)
end

local function getPlayerBase()
	local bases = Workspace:FindFirstChild("Bases")
	if not bases then return nil end
	for i = 1, 8 do
		local base = bases:FindFirstChild("Base" .. i)
		if base and base:FindFirstChild("Owner") and base.Owner.Value == player then
			return base
		end
	end
	return nil
end

local function teleportTo(part)
	local hrp = getHRP()
	if hrp and part then
		hrp.CFrame = part.CFrame + Vector3.new(0, 3, 0)
	end
end

local function interactWithModel(model)
	for _, v in ipairs(model:GetDescendants()) do
		if v:IsA("ProximityPrompt") then
			fireproximityprompt(v)
			task.wait(0.05)
			return true
		end
	end
	return false
end

local function wasPromptActivated(model)
	for _, v in ipairs(model:GetDescendants()) do
		if v:IsA("ProximityPrompt") then
			return v.Enabled == false or v.Parent == nil
		end
	end
	return false
end

local function PreventFallDamage()
	local char = player.Character
	if not char then return end
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
		humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
		humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
	end
end

task.spawn(function()
	while true do
		task.wait(1)
		pcall(PreventFallDamage)
	end
end)

local function FlingPlayerSmart(target)
	local targetHRP = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
	local char = player.Character
	local humanoid = char and char:FindFirstChild("Humanoid")
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not targetHRP or not hrp then return false end

	local toggle = 0.1
	local lastPos = targetHRP.Position
	local endTime = tick() + 5 
	local successThreshold = 30 

	while tick() < endTime do
		if humanoid then
			humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
			humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
			humanoid:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
		end

		if not targetHRP or not targetHRP.Parent then break end

		local distance = (targetHRP.Position - lastPos).Magnitude
		if distance >= successThreshold then
			return true
		end

		lastPos = targetHRP.Position

		local originalVel = hrp.Velocity
		hrp.CFrame = targetHRP.CFrame + Vector3.new(0, 0.5, 0)
		hrp.Velocity = originalVel * 10000 + Vector3.new(0, 10000, 0)
		RunService.RenderStepped:Wait()
		hrp.Velocity = originalVel
		RunService.Stepped:Wait()
		hrp.Velocity = originalVel + Vector3.new(0, toggle, 0)
		toggle = -toggle
		RunService.Heartbeat:Wait()
	end

	local finalDistance = (targetHRP.Position - lastPos).Magnitude
	return finalDistance >= successThreshold
end

local function isValidModel(model, ownerName, standNumber)
	local inBase = model:FindFirstChild("InBase")
	local owner = model:FindFirstChild("Owner")
	local stand = model:FindFirstChild("StandNumber")
	if not (inBase and owner and stand) then return false end
	if not inBase:IsA("BoolValue") or not inBase.Value then return false end
	if not stand:IsA("IntValue") or stand.Value ~= standNumber then return false end

	local realOwnerName = nil
	if typeof(owner.Value) == "string" then
		realOwnerName = owner.Value
	elseif typeof(owner.Value) == "Instance" and owner.Value:IsA("Player") then
		realOwnerName = owner.Value.Name
	elseif owner:IsA("StringValue") then
		realOwnerName = owner.Value
	elseif owner:IsA("ObjectValue") and owner.Value and owner.Value:IsA("Player") then
		realOwnerName = owner.Value.Name
	end

	return realOwnerName == ownerName
end

local function findModelFromMovingOn(ownerName, standNumber)
	local folder = Workspace:FindFirstChild("MovingOn")
	if not folder then return nil end
	for _, item in ipairs(folder:GetChildren()) do
		if isValidModel(item, ownerName, standNumber) then
			notify("✔", "تم العثور في MovingOn لستند " .. standNumber)
			return item
		end
	end
	return nil
end

local function findModelFromAnywhere(ownerName, standNumber)
	for _, item in ipairs(Workspace:GetChildren()) do
		if item:IsA("Model") and isValidModel(item, ownerName, standNumber) then
			notify("✔", "تم العثور في Workspace العام لستند " .. standNumber)
			return item
		end
	end
	return nil
end


baseDropdown = tab3:AddDropdown({
	Name = "اختر البيت",
	Default = nil,
	Options = {},
	Callback = function(value)
		selectedBaseName = string.match(value, "Base%d+")
	end
})

standDropdown = tab3:AddDropdown({
	Name = "اختار منطقة السرقة",
	Default = nil,
	Options = {},
	Callback = function(value)
		selectedStand = value
	end
})

tab3:AddToggle({
	Name = "تطير و سرقة",
	Default = false,
	Callback = function(state)
		attackAndStealEnabled = state
	end
})

task.spawn(function()
	while true do
		task.wait(1)
		local baseOptions, standOptions = {}, {}

		local bases = Workspace:FindFirstChild("Bases")
		if bases then
			for i = 1, 8 do
				local base = bases:FindFirstChild("Base" .. i)
				if base then
					local owner = base:FindFirstChild("Owner")
					local ownerName = (owner and owner.Value and owner.Value:IsA("Player")) and owner.Value.Name or "فارغ"
					table.insert(baseOptions, "Base" .. i .. " - " .. ownerName)
				end
			end
			baseDropdown:Refresh(baseOptions, true)
		end

		for i = 1, 27 do
			table.insert(standOptions, "Stand" .. i)
		end
		standDropdown:Refresh(standOptions, true)
	end
end)

tab3:AddButton({
	Name = "سرقة",
	Callback = function()
		if not selectedBaseName or not selectedStand then
			notify("خطأ", "اختر البيت والمنطقة أولاً")
			return
		end

		local base = Workspace.Bases:FindFirstChild(selectedBaseName)
		local stands = base and base:FindFirstChild("Stands")
		local ownerVal = base and base:FindFirstChild("Owner")
		local ownerName = ownerVal and ownerVal.Value and ownerVal.Value.Name
		local num = tonumber(selectedStand:match("%d+"))

		local stand = stands and stands:FindFirstChild(selectedStand)
		local targetModel = nil

		if stand then
			for _, v in ipairs(stand:GetChildren()) do
				if v:IsA("Model") and v:FindFirstChild("Proxy") then
					targetModel = v
					break
				end
			end
		end

		if not targetModel and ownerName then
			targetModel = findModelFromMovingOn(ownerName, num) or findModelFromAnywhere(ownerName, num)
		end

		if not targetModel then
			notify("فشل", "لم يتم العثور على الكائن")
			return
		end

		local hrp = getHRP()
		local origin = hrp.CFrame

		local proxy = targetModel:FindFirstChild("Proxy") or targetModel
		teleportTo(proxy)
		task.wait(0.05)
		interactWithModel(targetModel)
		task.wait(0.05)
		if not wasPromptActivated(targetModel) then
			interactWithModel(targetModel)
		end

		local myBase = getPlayerBase()
		if myBase then
			local xAmount = myBase:FindFirstChild("xAmount")
			if xAmount then
				teleportTo(xAmount)
				task.wait(0.1)
			end
		end

		hrp.CFrame = origin
		notify("تم", "تمت السرقة الفردية.")
	end
})

tab3:AddButton({
	Name = "سرقة الكل",
	Callback = function()
		if not selectedBaseName then
			notify("خطأ", "اختر البيت أولاً")
			return
		end

		local base = Workspace.Bases:FindFirstChild(selectedBaseName)
		local stands = base and base:FindFirstChild("Stands")
		local ownerVal = base and base:FindFirstChild("Owner")
		local ownerName = ownerVal and ownerVal.Value and ownerVal.Value.Name
		if not stands or not ownerName then return end

		local hrp = getHRP()
		local origin = hrp.CFrame

		task.spawn(function()
			if attackAndStealEnabled and ownerVal and ownerVal.Value:IsA("Player") then
				if not FlingPlayerSmart(ownerVal.Value) then
					notify("فشل", "الهدف لم يطر.")
					return
				end
			end

			for i = 1, 27 do
				local stand = stands:FindFirstChild("Stand" .. i)
				local targetModel = nil

				if stand then
					for _, v in ipairs(stand:GetChildren()) do
						if v:IsA("Model") and v:FindFirstChild("Proxy") then
							targetModel = v
							break
						end
					end
				end

				if not targetModel then
					targetModel = findModelFromMovingOn(ownerName, i) or findModelFromAnywhere(ownerName, i)
				end

				if targetModel then
					local proxy = targetModel:FindFirstChild("Proxy") or targetModel
					teleportTo(proxy)
					task.wait(0.05)
					interactWithModel(targetModel)
					task.wait(0.05)
					if not wasPromptActivated(targetModel) then
						interactWithModel(targetModel)
					end

					local myBase = getPlayerBase()
					if myBase then
						local xAmount = myBase:FindFirstChild("xAmount")
						if xAmount then
							teleportTo(xAmount)
							task.wait(0.05)
						end
					end
				end
			end

			hrp.CFrame = origin
			notify("تم", "تمت سرقة جميع الأهداف.")
		end)
	end
})





local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer

local autoStealOnJoinLeave = false

local function notify(title, text)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = title,
			Text = text,
			Duration = 4
		})
	end)
end

local function getHRP()
	local char = player.Character or player.CharacterAdded:Wait()
	return char:WaitForChild("HumanoidRootPart", 10)
end

local function teleportTo(part)
	local hrp = getHRP()
	if hrp and part then
		hrp.CFrame = part.CFrame + Vector3.new(0, 3, 0)
	end
end

local function interactWithModel(model)
	for _, v in ipairs(model:GetDescendants()) do
		if v:IsA("ProximityPrompt") and v.Enabled then
			pcall(fireproximityprompt, v)
			task.wait(0.05)
			return true
		end
	end
	return false
end

local function wasPromptActivated(model)
	for _, v in ipairs(model:GetDescendants()) do
		if v:IsA("ProximityPrompt") then
			return not v.Enabled or v.Parent == nil
		end
	end
	return false
end

local function getPlayerBaseByName(ownerName)
	local bases = Workspace:FindFirstChild("Bases")
	if not bases then return nil end
	for i = 1, 8 do
		local base = bases:FindFirstChild("Base" .. i)
		if base and base:FindFirstChild("Owner") then
			local o = base.Owner.Value
			local oName = typeof(o) == "Instance" and o:IsA("Player") and o.Name or tostring(o)
			if oName == ownerName then
				return base
			end
		end
	end
	return nil
end

local function isValidModel(model, ownerName, standNumber)
	local inBase = model:FindFirstChild("InBase")
	local owner = model:FindFirstChild("Owner")
	local stand = model:FindFirstChild("StandNumber")
	if not (inBase and owner and stand) then return false end
	if not inBase:IsA("BoolValue") or not inBase.Value then return false end
	if not stand:IsA("IntValue") or stand.Value ~= standNumber then return false end

	local realOwnerName = nil
	if typeof(owner.Value) == "string" then
		realOwnerName = owner.Value
	elseif typeof(owner.Value) == "Instance" and owner.Value:IsA("Player") then
		realOwnerName = owner.Value.Name
	elseif owner:IsA("StringValue") then
		realOwnerName = owner.Value
	elseif owner:IsA("ObjectValue") and owner.Value and owner.Value:IsA("Player") then
		realOwnerName = owner.Value.Name
	end

	return realOwnerName == ownerName
end

-- تنفيذ السرقة الذكية المستمرة
local function executeSmartStealForPlayer(playerName)
	if playerName == player.Name then return end

	local hrp = getHRP()
	local origin = hrp.CFrame

	local base = getPlayerBaseByName(playerName)
	local stands = base and base:FindFirstChild("Stands")
	local ownerVal = base and base:FindFirstChild("Owner")
	local ownerName = ownerVal and ownerVal.Value and (typeof(ownerVal.Value) == "Instance" and ownerVal.Value.Name or tostring(ownerVal.Value))

	if not base or not stands or not ownerName then return end

	-- متغير لتتبع ما إذا تم العثور على كائنات للسرقة في الدورة الحالية
	local foundAny = true

	while foundAny do
		foundAny = false -- نفترض لا يوجد كائنات في البداية

		for i = 1, 27 do
			local stand = stands:FindFirstChild("Stand" .. i)
			local targetModel = nil

			-- البحث داخل Stand
			if stand then
				for _, v in ipairs(stand:GetChildren()) do
					if v:IsA("Model") and v:FindFirstChild("Proxy") then
						targetModel = v
						break
					end
				end
			end

			-- البحث في MovingOn
			if not targetModel then
				local folder = Workspace:FindFirstChild("MovingOn")
				if folder then
					for _, item in ipairs(folder:GetChildren()) do
						if isValidModel(item, ownerName, i) then
							targetModel = item
							break
						end
					end
				end
			end

			-- البحث في Workspace العام
			if not targetModel then
				for _, item in ipairs(Workspace:GetChildren()) do
					if item:IsA("Model") and isValidModel(item, ownerName, i) then
						targetModel = item
						break
					end
				end
			end

			-- إذا تم العثور على كائن
			if targetModel then
				foundAny = true -- وجدنا كائن في هذه الدورة

				local proxy = targetModel:FindFirstChild("Proxy") or targetModel
				teleportTo(proxy)
				task.wait(0.1)

				interactWithModel(targetModel)
				task.wait(0.1)

				if not wasPromptActivated(targetModel) then
					interactWithModel(targetModel)
				end

				-- الانتقال إلى xAmount الخاصة بالمستخدم (لاعب السكربت)
				local myBase = getPlayerBaseByName(player.Name)
				if myBase then
					local xAmount = myBase:FindFirstChild("xAmount")
					if xAmount then
						teleportTo(xAmount)
						local timeout = tick() + 5
						while (getHRP().Position - xAmount.Position).Magnitude > 5 and tick() < timeout do
							task.wait(0.1)
						end
					end
				end
			end
		end

		-- إذا لم يعثر على أي كائن في دورة كاملة تتوقف الحلقة
		if not foundAny then
			break
		end
	end

	hrp.CFrame = origin
	notify("✔", "تمت سرقة كل شيء من: " .. playerName)
end

-- زر التبديل
tab3:AddToggle({
	Name = "سرقة عند دخول/خروج لاعب(غير مستقر) ",
	Default = false,
	Callback = function(state)
		autoStealOnJoinLeave = state
		if state then
			notify("✅", "تم تفعيل السرقة التلقائية")
		else
			notify("⛔", "تم إيقاف السرقة التلقائية")
		end
	end
})

-- عند دخول لاعب
Players.PlayerAdded:Connect(function(plr)
	if autoStealOnJoinLeave then
		task.spawn(function()
			executeSmartStealForPlayer(plr.Name)
		end)
	end
end)

-- عند خروج لاعب
Players.PlayerRemoving:Connect(function(plr)
	if autoStealOnJoinLeave then
		task.spawn(function()
			executeSmartStealForPlayer(plr.Name)
		end)
	end
end)





tab:AddLabel("نظام مراقبة وقت البيت")


local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

local selectedBaseName = nil
local baseDropdown
local watching = false
local originalSubject = camera.CameraSubject


local function notify(text)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = "تنبيه",
			Text = text,
			Duration = 4
		})
	end)
end


local function getBaseOptions()
	local bases = Workspace:FindFirstChild("Bases")
	if not bases then return {} end

	local list = {}
	for i = 1, 8 do
		local base = bases:FindFirstChild("Base" .. i)
		if base then
			local owner = base:FindFirstChild("Owner")
			local ownerName = (owner and owner.Value and owner.Value:IsA("Player")) and owner.Value.Name or "فارغ"
			table.insert(list, "Base" .. i .. " - " .. ownerName)
		end
	end
	return list
end


local function parseBaseName(displayText)
	return string.match(displayText, "^(Base%d+)")
end


baseDropdown = tab:AddDropdown({
	Name = "اختر بيتًا",
	Default = nil,
	Options = getBaseOptions(),
	Callback = function(value)
		selectedBaseName = parseBaseName(value)
	end
})


task.spawn(function()
	local lastList = {}
	while true do
		task.wait(2)
		if baseDropdown then
			local newList = getBaseOptions()
			local changed = false
			if #newList ~= #lastList then
				changed = true
			else
				for i = 1, #newList do
					if newList[i] ~= lastList[i] then
						changed = true
						break
					end
				end
			end
			if changed then
				baseDropdown:Refresh(newList, true)
				lastList = newList
			end
		end
	end
end)


tab:AddToggle({
	Name = "عرض الكاميرا داخل البيت",
	Default = false,
	Callback = function(state)
		watching = state

		if state then
			if not selectedBaseName then
				notify("يرجى اختيار بيت أولاً")
				return
			end

			local bases = Workspace:FindFirstChild("Bases")
			if not bases then
				notify("لم يتم العثور على مجلد Bases")
				return
			end

			local base = bases:FindFirstChild(selectedBaseName)
			if not base then
				notify("لم يتم العثور على " .. selectedBaseName)
				return
			end

			local lock = base:FindFirstChild("Lock")
			if not lock or not lock:IsA("BasePart") then
				notify("لم يتم العثور على Lock داخل " .. selectedBaseName)
				return
			end


			originalSubject = camera.CameraSubject


			camera.CameraType = Enum.CameraType.Custom
			camera.CameraSubject = lock
			notify("تم نقل الكاميرا إلى داخل البيت")
		else
		
			camera.CameraType = Enum.CameraType.Custom
			camera.CameraSubject = originalSubject
			notify("تمت إعادة الكاميرا إليك")
		end
	end
})


local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer

local selectedBase = nil
local selectedFloor = "الطابق الأرضي"
local baseDropdown
local lastOptions = {}


local function notify(title, text)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = title,
			Text = text,
			Duration = 4
		})
	end)
end


local function getHRP()
	local char = player.Character or player.CharacterAdded:Wait()
	return char:WaitForChild("HumanoidRootPart", 10)
end


local function getBaseOptions()
	local bases = workspace:FindFirstChild("Bases")
	if not bases then return {} end

	local list = {}
	for i = 1, 8 do
		local base = bases:FindFirstChild("Base" .. i)
		if base then
			local owner = base:FindFirstChild("Owner")
			local ownerName = (owner and owner.Value and owner.Value:IsA("Player")) and owner.Value.Name or "فارغ"
			table.insert(list, "Base" .. i .. " - " .. ownerName)
		end
	end
	return list
end


local function parseBaseName(displayName)
	local base = string.match(displayName, "^(Base%d+)")
	return base
end


local function teleportPlayer()
	local baseName = parseBaseName(selectedBase or "")
	if not baseName then
		notify("خطأ", "الرجاء اختيار بيت.")
		return
	end

	local bases = workspace:FindFirstChild("Bases")
	if not bases then
		notify("خطأ", "لم يتم العثور على مجلد Bases.")
		return
	end

	local base = bases:FindFirstChild(baseName)
	if not base then
		notify("خطأ", "لم يتم العثور على " .. baseName)
		return
	end

	local hrp = getHRP()
	if not hrp then return end

	if selectedFloor == "الطابق الأرضي" then
		local lock = base:FindFirstChild("Lock")
		if lock and lock:IsA("BasePart") then
			hrp.CFrame = CFrame.new(lock.Position + Vector3.new(0, 5, 0), lock.Position)
			notify("تم النقل", "تم نقلك إلى الطابق الأرضي.")
		else
			notify("خطأ", "لا يوجد Lock في " .. baseName)
		end
	elseif selectedFloor == "الطابق الثاني" then
		local stands = base:FindFirstChild("Stands")
		if stands then
			local stand24 = stands:FindFirstChild("Stand24")
			if stand24 then
				local collect = stand24:FindFirstChild("Collect")
				if collect and collect:IsA("BasePart") then
					hrp.CFrame = CFrame.new(collect.Position + Vector3.new(0, 5, 0), collect.Position)
					notify("تم النقل", "تم نقلك إلى الطابق الثاني.")
				else
					notify("خطأ", "لا يوجد Collect داخل Stand24.")
				end
			else
				notify("خطأ", "لا يوجد Stand24 داخل " .. baseName)
			end
		else
			notify("خطأ", "لا يوجد مجلد Stands داخل " .. baseName)
		end
	end
end


baseDropdown = tab1:AddDropdown({
	Name = "اختر بيتًا",
	Default = nil,
	Options = getBaseOptions(),
	Callback = function(value)
		selectedBase = value
	end
})


tab1:AddDropdown({
	Name = "اختر الطابق",
	Default = "الطابق الأرضي",
	Options = {"الطابق الأرضي", "الطابق الثاني"},
	Callback = function(val)
		selectedFloor = val
	end
})


tab1:AddButton({
	Name = "نقل",
	Callback = teleportPlayer
})


task.spawn(function()
	while true do
		task.wait(2)
		if baseDropdown then
			local newOptions = getBaseOptions()

			local changed = false
			if #newOptions ~= #lastOptions then
				changed = true
			else
				for i = 1, #newOptions do
					if newOptions[i] ~= lastOptions[i] then
						changed = true
						break
					end
				end
			end

			if changed then
				baseDropdown:Clear()
				for _, option in ipairs(newOptions) do
					baseDropdown:Add(option)
				end
				lastOptions = newOptions
			end
		end
	end
end)




OrionLib:Init()
