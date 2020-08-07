-------------------------------------------
----------- FUNCTION AREA START -----------
-------------------------------------------
local green  = "|cff00ff00";
local yellow = "|cffffff00";
local red = "|cffff0000";

local l = AceLibrary("AceLocale-2.2"):new("AstronaX")

function print(string, r, g, b)
	if ( DEFAULT_CHAT_FRAME ) then 
		r = tonumber(r) or 0
		g = tonumber(g) or 255
		b = tonumber(b) or 0
		
		if tonumber(r) > 1 then r = r / 100; end
		if tonumber(g) > 1 then r = g / 100; end
		if tonumber(b) > 1 then r = b / 100; end
		DEFAULT_CHAT_FRAME:AddMessage(string, r, g, b);
		ChatFrame3:AddMessage(string, r, g, b);
	end
end

function FirstCharUpper(str)
  if str ~= nil then
    str = string.lower(str)
    return (str:gsub("^%l", string.upper))
  else
    return ""
  end
end

function loop_table_sorted(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys 
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

function CleanArrayDublicates(array)
  local hash = {}
  local res = {}

  for _,v in ipairs(array) do
     if (not hash[v]) then
         res[#res+1] = v -- you could print here instead of saving to result table if you wanted
         hash[v] = true
     end
  end
  return res
end

function GetArraySize(array)
  if array ~= nil then
    local count = 0
    for _, _ in pairs( array ) do
      count = count + 1
    end
    return count
  else
    return 0
  end
end

function rgb2Hex(rgb)
  if rgb ~= nil then
    local hexadecimal = ''

    for _, value in pairs(rgb) do
      local hex = ''

      while(value > 0)do
        local index = math.fmod(value, 16) + 1
        value = math.floor(value / 16)
        hex = string.sub('0123456789ABCDEF', index, index) .. hex			
      end

      if(string.len(hex) == 0)then
        hex = '00'

      elseif(string.len(hex) == 1)then
        hex = '0' .. hex
      end

      hexadecimal = hexadecimal .. hex
    end

    return hexadecimal
  else
    return "ff"
  end
end

function str_pad(val,Zeros)
	local length = math.floor(math.log10(val)+1)
	if length >= 1 then
		return string.rep('0', Zeros - length)..val
	else 
		return string.rep('0', Zeros - 1)..val
	end
end

function round(num, idp)
	local mult = 10^(idp or 0)
	return math.floor(num * 100 * mult + 0.5) / mult
end

function isValueInsideArray(array, val)
    for _, value in ipairs(array) do
        if value == val then
            return true
        end
    end
    return false
end

function isKeyInsideArray(array, k)
    for key, _ in ipairs(array) do
        if key == k then
            return true
        end
    end
    return false
end

function RunSlashCmd(cmd)
  local slash, rest = cmd:match("^(%S+)%s*(.-)$")
  for name, func in pairs(SlashCmdList) do
     local i, slashCmd = 1
     repeat
        slashCmd, i = _G["SLASH_"..name..i], i + 1
        if slashCmd == slash then
           return true, func(rest)
        end
     until not slashCmd
  end
  -- Okay, so it's not a slash command. It may also be an emote.
  local i = 1
  while _G["EMOTE" .. i .. "_TOKEN"] do
     local j, cn = 2, _G["EMOTE" .. i .. "_CMD1"]
     while cn do
        if cn == slash then
           return true, DoEmote(_G["EMOTE" .. i .. "_TOKEN"], rest);
        end
        j, cn = j+1, _G["EMOTE" .. i .. "_CMD" .. j]
     end
     i = i + 1
  end
end
--obsolete?
function canRepair()
  return false
  -- if CanMerchantRepair() == 1 then
  --   local cost, canRepair = GetRepairAllCost()
  -- if tonumber(AstronaX:GetArmorStatus()) < 80 then
  --   print('Armor: '..AstronaX:GetArmorStatus()..' Costs: '..cost);
	-- 	if not canRepair or cost <= 5000 then return end
	-- 	local money = GetMoney()
	-- 	local gbAmount = GetGuildBankWithdrawMoney()
	-- 	local gbMoney = GetGuildBankMoney()
	-- 	if IsInGuild() and ((gbAmount == -1 and gbMoney > cost) or gbAmount > cost) then
	-- 	  return 2, cost
	-- 	elseif money > cost then
	-- 	  return 1, cost
	-- 	end
	-- end
  -- end
end

function isChannelJoined(channelname)
  local chanList = { GetChannelList() }
  for i=1, #chanList, 2 do
    if chanList[i+1] == channelname or chanList[i+1] == FirstCharUpper(channelname) then
      return true
    end
  end
  return false
end

function isRaid() 
  if GetNumRaidMembers() <= 10 then
    SetCVar("showLootSpam", 1)
  else
    SetCVar("showLootSpam", 0)
  end
  
  -- set viewdistance low if yes else to max
	local result = false
	if GetNumRaidMembers() > 1 and not(IsFlying()) and not(GetZoneText() == "Dalaran" or GetZoneText() == "Wintergrasp" or GetZoneText() == "Tausendwintersee") then
    if not(IsLeadOrAssist()) and isChannelJoined("world") then
      LeaveChannelByName("world");
      --print(AstronaXDB.addon_color.."World channel "..AstronaXDB.addon_highlight.."left.")
    end
    if AstronaXDB[UnitName("player")]["farclip_toggle"] ~= nil and AstronaXDB[UnitName("player")]["farclip_toggle"] == 1 then
      SetCVar( "farclip", 400 );
    end
		result = true
  elseif not(UnitIsDeadOrGhost("player")) then    
    if AstronaXDB[UnitName("player")]["farclip_toggle"] ~= nil and AstronaXDB[UnitName("player")]["farclip_toggle"] == 1 then
      SetCVar( "farclip", AstronaXDB.farclip );
    end
    if not(isChannelJoined("world")) then
      JoinChannelByName("world");
      ChatFrame_AddChannel(DEFAULT_CHAT_FRAME, "world");
      --print(AstronaXDB.addon_color.."World channel "..AstronaXDB.addon_highlight.."joined.")
    else
      return result
    end
    
	end
	return result
end

function isParty()
	local result = false
	if GetNumPartyMembers() > 0 then
		result = true
	end
	return result
end

function isInGroup()
	local type = false -- solo = 0 / grouped = 1
	if isParty() or isRaid() then
		type = true
	end
	return type
end

function IsLead()
  if
  (
    isParty() and IsPartyLeader("player")
  ) or (
    GetNumRaidMembers() > 1 and IsRaidLeader("player") 
  )
  then
    return true
  else
    return false
  end
end

function IsLeadOrAssist()
  if (
    isParty() and IsPartyLeader("player")
  ) or (
    GetNumRaidMembers() > 1 and IsRaidLeader("player") -- kein isRaid() sonst stack overflow
  ) then
    return true
  end
  for i=1,40 do
    local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML = GetRaidRosterInfo(i);
    if name == UnitName("player") and rank == 1 then
      return true
    end
  end
  return false
end

function isInCombat(name)
	if name == nil then
		name = "player";
	end
	return UnitAffectingCombat(name);
end

function GetClassColor(englishClass)
--        None = 0 
--        Warrior = 1 
--        Paladin = 2 
--        Hunter = 3 
--        Rogue = 4 
--        Priest = 5 
--        DeathKnight = 6 
--        Shaman = 7 
--        Mage = 8 
--        Warlock = 9 
--        Monk = 10 
--        Druid = 11 
	local classcolor = "|cffffdd00"
	
	if englishClass == "DEATHKNIGHT" then classcolor =  "|cffC41F3B" end
	if englishClass == "DRUID" then classcolor =  "|cffFF7D0A" end
	if englishClass == "HUNTER" then classcolor =  "|cffABD473" end
	if englishClass == "MAGE" then classcolor =  "|cff69CCF0" end
	if englishClass == "PALADIN" then classcolor =  "|cffF58CBA" end
	if englishClass == "PRIEST" then classcolor =  "|cffFFFFFF" end
	if englishClass == "SHAMAN" then classcolor =  "|cff0070DE" end
	if englishClass == "WARLOCK" then classcolor =  "|cff9482C9" end
	if englishClass == "WARRIOR" then classcolor =  "|cffC79C6E" end
	
	return classcolor;
end

function GetClassName(playername)
	if playername == nil then
		playername = "player";
	end
	local _, englishClass = UnitClass(playername)
	return englishClass;
end

function GetClassPriorities(class)
  local classPriorities = nil
  local spacer = yellow.." > "..red
	if class == "DEATHKNIGHT" then   classPriorities =  red.."Def 540"..spacer.."Hit 263"..spacer.."Exp 26"..spacer.."Armor" end
	if class == "DRUID" then         classPriorities =  red.."Hit 263"..spacer.."Spell"..spacer.."Crit"..spacer.."Haste"..spacer.."Spirit" end
	if class == "HUNTER" then        classPriorities =  red.."Hit 164"..spacer.."Agi/Arp 1400"..spacer.."Crit"..spacer.."AP"..spacer.."Haste" end
	if class == "MAGE" then          classPriorities =  red.."Hit 289"..spacer.."Spell"..spacer.."Haste"..spacer.."Crit"..spacer.."Int" end
	if class == "PALADIN" then       classPriorities =  red.."Hit 263"..spacer.."Exp 26"..spacer.." Strength"..spacer.."Crit"..spacer.."Agi" end
	if class == "PRIEST" then        classPriorities =  red.."Hit 368"..spacer.."Spell"..spacer.."Haste"..spacer.."Int"..spacer.."Spirit" end
	if class == "SHAMAN" then        classPriorities =  red.."Spell"..spacer.."Haste 735"..spacer.."MP5"..spacer.."Int"..spacer.."Crit" end
	if class == "WARLOCK" then       classPriorities =  red.."Hit 446"..spacer.."Spell"..spacer.."Haste 1370"..spacer.."Crit"..spacer.."Spirit" end
	if class == "WARRIOR" then       classPriorities =  red.."Hit 263"..spacer.."Exp 26"..spacer.."Arp 1400"..spacer.."Strength" end
  return classPriorities
end

function GetGearscoreColored(val_gearscore)
	if val_gearscore == nil then
    val_gearscore = 0
  end
  local Red, Blue, Green = GearScore_GetQuality( val_gearscore );
  Red = string.format("%02x", Red * 255)
  Green = string.format("%02x", Green * 255)
  Blue = string.format("%02x", Blue * 255)
  
  --local tmp = string.format('%.1f', round_to_k(val_gearscore))
  return Red..Green..Blue..val_gearscore
end

function GetGroupCount()
	if GetGroupType() == "raid" then
		return GetNumRaidMembers()
	elseif GetGroupType() == "party" then
		return GetNumPartyMembers()
	else
		return 1
	end
end

function GetGroupType()
	if isRaid() then
		return "raid"
	elseif isParty() then
		return "party"
	else 
		return "player"
	end
end

function GetInstanceSize()
  local mode = GetInstanceDifficulty()
  if mode == 1 then return "10nh" -- oder 5nh
  elseif mode == 2 then return "25nh" -- oder 5hc
  elseif mode == 3 then return "10hc or heroic?"
  elseif mode == 4 then return "25hc"
  else return "unknown"
  end
end

function GetLootType()
  local tmp = GetLootMethod()
  if tmp then
    return l[tmp]
  else
    return l["Personal"]
  end
end

function GetSpellCooldownSeconds(string)
	local start, duration, enabled = GetSpellCooldown(string);
	--if start== nil then start=0; end
	if duration== nil then duration=0; end 

	if start ~= nil and enabled == 0 then
		--DEFAULT_CHAT_FRAME:AddMessage(string.." is currently active. " .. duration .. " remaining.");
		return true;
	elseif start ~= nil  and ( start > 0 and duration > 0) then
		local remaining = (start + duration - GetTime());
		if remaining < 1.5 then remaining = 0; end
		--DEFAULT_CHAT_FRAME:AddMessage(string.." is on cooldown for " .. remaining .. " seconds.");
		return remaining;
	else
		--DEFAULT_CHAT_FRAME:AddMessage(string.." is ready.");
		return 0;
	end
end

function PlaySoundFileAstronax(soundpath)
	if tonumber(GetCVar("Sound_MasterVolume")) > 0 and tonumber(GetCVar("Sound_SFXVolume")) > 0 and tonumber(GetCVar("Sound_EnableSFX")) == 1 then
		PlaySoundFile(soundpath,"SFX")
	end
end

function format_money(money, icons, fulldisplay, kshort)
  local GOLD_TEXT = "|cffffd700";
  local SILVER_TEXT = "|cffc7c7cf";
  local COPPER_TEXT = "|cffeda55f";

	if fulldisplay == nil then fulldisplay = false end
	if icons == nil then icons = false end
	--money = tonumber(money)
  
	if money > 0 then
		local money_g = math.floor(money / 10000)
		
		local money_k = money % 100
		money_k = str_pad(money_k, 2)
		
		local money_s = (money % 10000 - money_k) / 100
		money_s = str_pad(money_s, 2)
		
		local text_money = ""
		if money_g > 0 or fulldisplay then
      if money_g > 1000 and kshort then
        money_g = math.floor( money_g / 1000 + 0.5).."k"
      end
			if icons then
				text_money = text_money.."|TInterface\\Icons\\inv_misc_coin_01:12|t "..GOLD_TEXT..money_g.."|r "
			else
				text_money = text_money..GOLD_TEXT..money_g.."|r "
			end
		end
		if tonumber(money_s) > 0 and fulldisplay or fulldisplay then
			if icons then
				text_money = text_money.." |TInterface\\Icons\\inv_misc_coin_03:12|t "..SILVER_TEXT..money_s.."|r "
			else
				text_money = text_money..SILVER_TEXT..money_s.."|r "
			end
		end
		if tonumber(money_k) > 0 and fulldisplay or fulldisplay then	
			if icons then
				text_money = text_money.." |TInterface\\Icons\\inv_misc_coin_06:12|t "..COPPER_TEXT..money_k.."|r "
			else
				text_money = text_money..COPPER_TEXT..money_k.."|r "
			end
		end
		return text_money
	else 
		return money
	end
end

--------------------------------------------
-- holt alle mails gleichzeitig ab mit rechtsklick
--local gttsiiHook = function(tooltip, index, ...)
--	local _, _, _, _, money, COD, _, hasItem, _, wasReturned, _, canReply = GetInboxHeaderInfo(index)
--	if money > 0 or COD > 0 or hasItem then tooltip:AddLine("Shift - Take Item") end
--	if not wasReturned and canReply then tooltip:AddLine("Ctrl - Return Item") end
--	return ...
--end
--local gttsii = GameTooltip.SetInboxItem
--GameTooltip.SetInboxItem = function(tooltip, index, ...)
	--return gttsiiHook(tooltip, index, gttsii(tooltip, index, ...))
--end

--------------------------------------------
