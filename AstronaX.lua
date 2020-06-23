local player = UnitName("player")
local player_talents_points = "???"
local player_talents_image = ""
local unknownSpecIcon = "Interface\\Icons\\ability_seal"
local spacertab = "     ";
local activeGroup = nil
local specCache = {}
local world_player_list = {}
local pending_rezz = 0;
local maxLevel = 80
local pending_inviter = nil;
local inviting_unit = nil
local target_unit = nil
local mailCount = nil
local gone_afk_at = 0
local xp_current_status = 0
local last_sound_played = {}
local sound_played_counter = 1
local isApplicationOpen = false
    
local red    = "|cffff0000";
local orange = "|cffff8f00";
local green  = "|cff00ff00";
local yellow = "|cffffff00";
local white = "|cffffffff";
local purple = "|cffA330C9";

local addon_color  = "|cff009a1a";
local addon_warning  = red;
local addon_highlight  = yellow;

local color_redgrayed = "|cffcc0000"
local color_greengrayed = "|cff008800"
local color_blacked = "|cff333333"
local color_yellowgrayed = "|cff666600"

local reputation_colors = {
"|cffff0000",   -- 36000  Hated       - Red
"|cffff8100",   -- 3000   Hostile     - Orange
"|cffffd200",   -- 3000   Unfriendly  - Yellow
"|cffcde6cd",   -- 3000   Neutral     - Grey
"|cffffffff",   -- 6000   Friendly    - White
"|cff009a1a",   -- 12000  Honored     - Green
"|cff0000ff",   -- 21000  Revered     - Blue
"|cff9400d4"    -- 1000   Exalted     - Purple
}

local selectionIds = {
	49426,	-- frost
	47241,	-- triumph
	45624,	-- eroberung
	40753,	-- emblem ehre
	40752,	-- heldentum
  43228  -- splitter eines steinbewahrer
}

local sellJunkList = {
  33445,  -- honigminze
  35953,	-- talbukbrät
  39152,	-- schwerer froststoff verband anleitung
  35947,	-- glitzernde-frostkappe
  33454,	-- gesalzenes-wildbret
  38303,	-- ausdauermojo
  33444,	-- herbe robbenmilch
  33443,  -- saurer ziegenkäse
  33452,  -- Honiggetränkte Flechte
  37091,  -- rollder irgendwas
  37092,  -- rollder irgendwas
  37093,  -- rollder irgendwas
  37094,  -- rollder irgendwas
  37097,  -- rollder irgendwas
  37098,  -- rollder irgendwas
  43463,  -- rollder irgendwas
  43464,  -- rollder irgendwas
  43465,  -- rollder irgendwas
  43466   -- rollder irgendwas
}

local revival_responses = {
  "danke sehr",
  "gracias",
  "dankeschön",
  "vielen dank",
  "muchas gracias",
  "herzlichen dank",
  "thank you",
  "thx",
  "thanks"
}

local short_spec_names = ({
    ["Deathknight Blut"] = "BlutTank",
    ["Deathknight Frost"] = "FrostDK",
    ["Deathknight Unheilig"] = "UHDK",
    ["Druid Gleichgewicht"] = "Eule",
    ["Druid Wilder Kampf"] = "Feral",
    ["Druid Wiederherst."] = "Baum",
    ["Hunter Tierherrschaft"] = "BM",
    ["Hunter Treffsicherheit"] = "MM",
    ["Hunter Überleben"] = "SV",
    ["Mage Arkan"] = "ArkanMage",
    ["Mage Feuer"] = "FeuerMage",
    ["Mage Frost"] = "FrostMage",
    ["Paladin Heilig"] = "HolyPala",
    ["Paladin Schutz"] = "ProtPala",
    ["Paladin Vergeltung"] = "Retri",
    ["Priest Disziplin"] = "Diszi",
    ["Priest Heilig"] = "HolyPriest",
    ["Priest Schatten"] = "Shadow",
    ["Rogue Meucheln"] = "Mutilate",
    ["Rogue Kampf"] = "Combat",
    ["Rogue Täuschung"] = "PVP",
    ["Shaman Elementar"] = "Ele",
    ["Shaman Verstärk."] = "VS",
    ["Shaman Wiederherst."] = "Resto",
    ["Warlock Gebrechen"] = "Affli",
    ["Warlock Dämonologie"] = "Dämo",
    ["Warlock Zerstörung"] = "Dest",
    ["Warrior Waffen"] = "Arms",
    ["Warrior Furor"] = "Fury",
    ["Warrior Schutz"] = "ProtWarri",
})

local spec_icons = ({
    ["Deathknight Blut"] = "Interface\\Icons\\spell_shadow_bloodboil.blp",
    ["Deathknight Frost"] = "Interface\\Icons\\spell_frost_freezingbreath.blp",
    ["Deathknight Unheilig"] = "Interface\\Icons\\spell_shadow_blackplague.blp",
    ["Druid Gleichgewicht"] = "Interface\\Icons\\Spell_Nature_StarFall.blp",
    ["Druid Wilder Kampf"] = "Interface\\Icons\\Ability_Racial_BearForm.blp",
    ["Druid Wiederherst."] = "Interface\\Icons\\Spell_Nature_HealingTouch.blp",
    ["Hunter Tierherrschaft"] = "Interface\\Icons\\ability_hunter_beasttaming.blp",
    ["Hunter Treffsicherheit"] = "Interface\\Icons\\Ability_Marksmanship.blp",
    ["Hunter Überleben"] = "Interface\\Icons\\ability_hunter_swiftstrike.blp",
    ["Mage Arkan"] = "Interface\\Icons\\spell_holy_magicalsentry.blp",
    ["Mage Feuer"] = "Interface\\Icons\\spell_fire_flamebolt.blp",
    ["Mage Frost"] = "Interface\\Icons\\spell_frost_chillingbolt.blp",
    ["Paladin Heilig"] = "Interface\\Icons\\Spell_Holy_HolyBolt.blp",
    ["Paladin Schutz"] = "Interface\\Icons\\spell_holy_devotionaura.blp",
    ["Paladin Vergeltung"] = "Interface\\Icons\\Spell_Holy_AuraOfLight.blp",
    ["Priest Disziplin"] = "Interface\\Icons\\Spell_Holy_WordFortitude.blp",
    ["Priest Heilig"] = "Interface\\Icons\\Spell_Holy_GuardianSpirit.blp",
    ["Priest Schatten"] = "Interface\\Icons\\Spell_Shadow_ShadowWordPain.blp",
    ["Rogue Meucheln"] = "Interface\\Icons\\ability_rogue_eviscerate.blp",
    ["Rogue Kampf"] = "Interface\\Icons\\ability_backstab.blp",
    ["Rogue Täuschung"] = "Interface\\Icons\\ability_stealth.blp",
    ["Shaman Elementar"] = "Interface\\Icons\\spell_nature_lightning.blp",
    ["Shaman Verstärk."] = "Interface\\Icons\\spell_nature_lightningshield.blp",
    ["Shaman Wiederherst."] = "Interface\\Icons\\Spell_Nature_MagicImmunity.blp",
    ["Warlock Gebrechen"] = "Interface\\Icons\\spell_shadow_deathcoil.blp",
    ["Warlock Dämonologie"] = "Interface\\Icons\\Spell_Shadow_Metamorphosis.blp",
    ["Warlock Zerstörung"] = "Interface\\Icons\\spell_shadow_rainoffire.blp",
    ["Warrior Waffen"] = "Interface\\Icons\\ability_rogue_eviscerate.blp",
    ["Warrior Furor"] = "Interface\\Icons\\Ability_Warrior_InnerRage.blp",
    ["Warrior Schutz"] = "Interface\\Icons\\ability_warrior_defensivestance.blp",
})

local function_array = {
  "bar_timer_1kw",
  "bar_rs",
  "bar_ti",
  "bar_tp",
  "bar_gs",
  "bar_fe",
  "bar_te",
  "bar_he",
  "bar_og",
  "bar_gg",
  "bar_lm",
  "bar_ho",
  "bar_1k",
  "bar_rt",
  "aifa",
  "aifk",
  "aiff",
  "aifg",
  "aro",
  "abm",
  "abml",
  "alam",
  "are",
  "arol",
  "aslm",
  "aste",
  "cldr",
  "clgr",
  "iobr",
  "staui",
  "tyr",
  "tgham",
  "tlmc",
  "tmrc",
  "tkww",
  "tis",
  "txp",
  "twcrs",
  "farclip_toggle",
  "tooltip_dailyweekly",
  "tooltip_pvpweekly",
  "tooltip_ak",
  "tooltip_naxx",
  "tooltip_obsi",
  "tooltip_ulduar",
  "tooltip_onyxia",
  "tooltip_pdk",
  "tooltip_pdok",
  "tooltip_icc",
  "tooltip_rubi",
  "tooltip_gearscore",
  "tooltip_repair",
  "tooltip_emblem_264",
  "tooltip_emblem_232",
  "tooltip_emblem_226",
  "tooltip_emblem_213",
  "tooltip_emblem_200",
  "tooltip_emblem_1kw",
  "tooltip_honor",
  "tooltip_money",
  "tooltip_title",
  "tooltip_chardetails",
  "tooltip_instancelocks"
}

local Tablet = AceLibrary("Tablet-2.0")
local l = AceLibrary("AceLocale-2.2"):new("AstronaX")
local dewdrop = AceLibrary("Dewdrop-2.0")

AstronaX = AceLibrary("AceAddon-2.0"):new("FuBarPlugin-2.0", "AceConsole-2.0", "AceEvent-2.0", "AceDB-2.0")
--AstronaX.hasIcon = true
AstronaX.hasNoColor = true
AstronaX.title = "AstronaX";
AstronaX.defaultPosition = "CENTER"
AstronaX.clickableTooltip = true

AstronaX:RegisterDB("AstronaXDB")
AstronaX:RegisterDefaults("profile", {})

local options = {
  type = "group",
  name = "AstronaX "..l["Settings"],
  childGroups = "tab",
  args = {
     addon_color = {
      order = 1, type = "color", width = "full",
      name = l["addon_color"],
      desc = l["addon_color_help"],
      get = function()
        local r = tonumber(addon_color:sub(5, string.len(addon_color)-4),16) / 255
        local g = tonumber(addon_color:sub(7, string.len(addon_color)-2),16) / 255
        local b = tonumber(addon_color:sub(9, string.len(addon_color)),16) / 255
        return r,g,b
      end,
      set = function(_,r,g,b) 
        if( r ~= 0 and g ~= 0 and b ~= 0) then
          local rgb = {r*255,g*255,b*255};
          AstronaXDB.addon_color = "|cff"..rgb2Hex(rgb)
          addon_color = AstronaXDB.addon_color
        end; 
      end,
    },
    addon_highlight = {
      order = 1, type = "color", width = "full",
      name = l["addon_highlight"],
      desc = l["addon_highlight_help"],
      get = function()
        local r = tonumber(addon_highlight:sub(5, string.len(addon_highlight)-4),16) / 255
        local g = tonumber(addon_highlight:sub(7, string.len(addon_highlight)-2),16) / 255
        local b = tonumber(addon_highlight:sub(9, string.len(addon_highlight)),16) / 255
        return r,g,b
      end,
      set = function(_,r,g,b) 
        if( r ~= 0 and g ~= 0 and b ~= 0) then
          local rgb = {r*255,g*255,b*255};
          AstronaXDB.addon_highlight = "|cff"..rgb2Hex(rgb)
          addon_highlight = AstronaXDB.addon_highlight
        end; 
      end,
    },
    options_tooltip = {
      type = "group",
      name = "Tooltip",
      order = order,
      args = {
        tooltip_chardetails = {
          order = 1, type = "toggle", width = "full",
          name = l["tooltip_chardetails"],
          desc = l["tooltip_help"],
          get = function() if AstronaXDB[player]["tooltip_chardetails"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["tooltip_chardetails"] = new; end,
        },
        tooltip_instancelocks = {
          order = 2, type = "toggle", width = "full",
          name = l["tooltip_instancelocks"],
          desc = l["tooltip_help"],
          get = function() if AstronaXDB[player]["tooltip_instancelocks"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["tooltip_instancelocks"] = new; end,
        },
        tooltip_gearscore = {
          order = 10, type = "toggle", width = "full",
          name = l["tooltip_gearscore"],
          desc = l["tooltip_help"],
          get = function() if AstronaXDB[player]["tooltip_gearscore"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["tooltip_gearscore"] = new; end,
        },
        tooltip_repair = {
          order = 10, type = "toggle", width = "full",
          name = l["tooltip_repair"],
          desc = l["tooltip_help"],
          get = function() if AstronaXDB[player]["tooltip_repair"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["tooltip_repair"] = new; end,
        },
        tooltip_emblem_264 = {
          order = 10, type = "toggle", width = "full",
          name = l["tooltip_emblem_264"],
          desc = l["tooltip_help"],
          get = function() if AstronaXDB[player]["tooltip_emblem_264"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["tooltip_emblem_264"] = new; end,
        },
        tooltip_emblem_232 = {
          order = 10, type = "toggle", width = "full",
          name = l["tooltip_emblem_232"],
          desc = l["tooltip_help"],
          get = function() if AstronaXDB[player]["tooltip_emblem_232"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["tooltip_emblem_232"] = new; end,
        },
        tooltip_emblem_226 = {
          order = 10, type = "toggle", width = "full",
          name = l["tooltip_emblem_226"],
          desc = l["tooltip_help"],
          get = function() if AstronaXDB[player]["tooltip_emblem_226"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["tooltip_emblem_226"] = new; end,
        },
        tooltip_emblem_213 = {
          order = 10, type = "toggle", width = "full",
          name = l["tooltip_emblem_213"],
          desc = l["tooltip_help"],
          get = function() if AstronaXDB[player]["tooltip_emblem_213"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["tooltip_emblem_213"] = new; end,
        },
        tooltip_emblem_200 = {
          order = 10, type = "toggle", width = "full",
          name = l["tooltip_emblem_200"],
          desc = l["tooltip_help"],
          get = function() if AstronaXDB[player]["tooltip_emblem_200"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["tooltip_emblem_200"] = new; end,
        },
        tooltip_emblem_1kw = {
          order = 10, type = "toggle", width = "full",
          name = l["tooltip_emblem_1kw"],
          desc = l["tooltip_help"],
          get = function() if AstronaXDB[player]["tooltip_emblem_1kw"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["tooltip_emblem_1kw"] = new; end,
        },
        tooltip_honor = {
          order = 10, type = "toggle", width = "full",
          name = l["tooltip_honor"],
          desc = l["tooltip_help"],
          get = function() if AstronaXDB[player]["tooltip_honor"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["tooltip_honor"] = new; end,
        },
        tooltip_money = {
          order = 10, type = "toggle", width = "full",
          name = l["tooltip_money"],
          desc = l["tooltip_help"],
          get = function() if AstronaXDB[player]["tooltip_money"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["tooltip_money"] = new; end,
        },
        tooltip_title = {
          order = 10, type = "toggle", width = "full",
          name = l["tooltip_title"],
          desc = l["tooltip_help"],
          get = function() if AstronaXDB[player]["tooltip_title"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["tooltip_title"] = new; end,
        },
        tooltip_dailyweekly = {
          order = 10, type = "toggle", width = "full",
          name = l["tooltip_dailyweekly"],
          desc = l["tooltip_help"],
          get = function() if AstronaXDB[player]["tooltip_dailyweekly"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["tooltip_dailyweekly"] = new; end,
        },
        tooltip_pvpweekly = {
          order = 10, type = "toggle", width = "full",
          name = l["tooltip_pvpweekly"],
          desc = l["tooltip_help"],
          get = function() if AstronaXDB[player]["tooltip_pvpweekly"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["tooltip_pvpweekly"] = new; end,
        },
        tooltip_ak = {
          order = 20, type = "toggle", width = "full",
          name = l["tooltip_ak"],
          desc = l["tooltip_help"],
          get = function() if AstronaXDB[player]["tooltip_ak"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["tooltip_ak"] = new; end,
        },
        tooltip_naxx = {
          order = 30, type = "toggle", width = "full",
          name = l["tooltip_naxx"],
          desc = l["tooltip_help"],
          get = function() if AstronaXDB[player]["tooltip_naxx"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["tooltip_naxx"] = new; end,
        },
        tooltip_obsi = {
          order = 40, type = "toggle", width = "full",
          name = l["tooltip_obsi"],
          desc = l["tooltip_help"],
          get = function() if AstronaXDB[player]["tooltip_obsi"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["tooltip_obsi"] = new; end,
        },
        tooltip_ulduar = {
          order = 50, type = "toggle", width = "full",
          name = l["tooltip_ulduar"],
          desc = l["tooltip_help"],
          get = function() if AstronaXDB[player]["tooltip_ulduar"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["tooltip_ulduar"] = new; end,
        },
        tooltip_onyxia = {
          order = 60, type = "toggle", width = "full",
          name = l["tooltip_onyxia"],
          desc = l["tooltip_help"],
          get = function() if AstronaXDB[player]["tooltip_onyxia"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["tooltip_onyxia"] = new; end,
        },
        tooltip_pdk = {
          order = 70, type = "toggle", width = "full",
          name = l["tooltip_pdk"],
          desc = l["tooltip_help"],
          get = function() if AstronaXDB[player]["tooltip_pdk"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["tooltip_pdk"] = new; end,
        },
        tooltip_pdok = {
          order = 80, type = "toggle", width = "full",
          name = l["tooltip_pdok"],
          desc = l["tooltip_help"],
          get = function() if AstronaXDB[player]["tooltip_pdok"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["tooltip_pdok"] = new; end,
        },
        tooltip_icc = {
          order = 90, type = "toggle", width = "full",
          name = l["tooltip_icc"],
          desc = l["tooltip_help"],
          get = function() if AstronaXDB[player]["tooltip_icc"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["tooltip_icc"] = new; end,
        },
        tooltip_rubi = {
          order = 100, type = "toggle", width = "full",
          name = l["tooltip_rubi"],
          desc = l["tooltip_help"],
          get = function() if AstronaXDB[player]["tooltip_rubi"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["tooltip_rubi"] = new; end,
        },
	  },
	  },
	  options_loot = {
      type = "group",
      name = "Loot",
      order = order,
      args = {
        arol = {
          order = 31, type = "toggle", width = "full",
          name = l["arol"],
          desc = l["arol_help"],
          get = function() if AstronaXDB[player]["arol"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["arol"] = new; end,
        },
        cldr = {
          order = 32, type = "toggle", width = "full",
          name = l["cldr"],
          desc = l["cldr_help"],
          get = function() if AstronaXDB[player]["cldr"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["cldr"] = new; end,
        },
        clgr = {
          order = 33, type = "toggle", width = "full",
          name = l["clgr"],
          desc = l["clgr_help"],
          get = function() if AstronaXDB[player]["clgr"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["clgr"] = new; end,
        },
        alam = {
          order = 34, type = "toggle", width = "full",
          name = l["alam"],
          desc = l["alam_help"],
          get = function() if AstronaXDB[player]["alam"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["alam"] = new; end,
        },
        aslm = {
          order = 35, type = "toggle", width = "full",
          name = l["aslm"],
          desc = l["aslm_help"],
          get = function() if AstronaXDB[player]["aslm"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["aslm"] = new; end,
        },
        staui = {
          order = 36, type = "toggle", width = "full",
          name = l["staui"],
          desc = l["staui_help"],
          get = function() if AstronaXDB[player]["staui"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["staui"] = new; end,
        },
      }
    },
    options_auto = {
      type = "group",
      name = "Auto X",
      order = order,
      args = {
        farclip_toggle = {
          order = 1, type = "toggle", width = "full",
          name = l["farclip_toggle"],
          desc = l["farclip_toggle_help"],
          get = function() if AstronaXDB[player]["farclip_toggle"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["farclip_toggle"] = new; end,
        },
        farclip = {
          order = 2, type = "range", width = "full", min = 185, max = 4000, step = 5,
          name = l["farclip"],
          desc = l["farclip_help"],
          disabled = function() if AstronaXDB[player]["farclip_toggle"] == 0 then return true else return false end end,
          get = function() return tonumber(AstronaXDB.farclip) end,
          --get = function() return tonumber(GetCVar("farclip")) end,
          set = function(_,v) AstronaXDB.farclip = v; SetCVar( "farclip", v); end,
        },
        abm = {
          order = 11, type = "toggle", width = "full",
          name = l["abm"],
          desc = l["abm_help"],
          get = function() if AstronaXDB[player]["abm"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["abm"] = new; end,
        },
        abml = {
          order = 12, type = "toggle", width = "full",
          name = l["abml"],
          desc = l["abml_help"],
          get = function() if AstronaXDB[player]["abml"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["abml"] = new; end,
        },
        abmv = {
          order = 13, type = "range", width = "full", min = 0, max = 214000, step = 1000,
          name = l["abmv"],
          disabled = function() if ( AstronaXDB[player]["abml"] == 0 and AstronaXDB[player]["abm"] == 0 ) then return true else return false end end,
          get = function() return AstronaXDB[player]["abmv"] end,
          set = function(_,v) AstronaXDB[player]["abmv"] = v; end,
        },
        -------------------------
        twcrs = {
          order = 20, type = "toggle", width = "full",
          name = l["twcrs"],
          desc = l["twcrs_help"],
          get = function() if AstronaXDB[player]["twcrs"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["twcrs"] = new; end,
        },
        aifk = {
          order = 21, type = "toggle", width = "full",
          name = l["aifk"],
          desc = l["aifk_help"],
          get = function() if AstronaXDB[player]["aifk"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["aifk"] = new; end,
        },
        keyword = {
          order = 22, type = "input", width = "half",
          name = l["keyword"],
          disabled = function() if ( AstronaXDB[player]["aifk"] == 0 ) then return true else return false end end,
          get = function() return AstronaXDB.auto_inv_whisper_text end,
          set = function(_,v) AstronaXDB.auto_inv_whisper_text = v; end,
        },
        aifa = {
          order = 23, type = "toggle", width = "full",
          name = l["aifa"],
          desc = l["aifa_help"],
          get = function() if AstronaXDB[player]["aifa"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["aifa"] = new; end,
        },
         aiff = {
          order = 24, type = "toggle", width = "full",
          name = l["aiff"],
          desc = l["aiff_help"],
          get = function() if AstronaXDB[player]["aiff"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["aiff"] = new; end,
        },
        aifg = {
          order = 25, type = "toggle", width = "full",
          name = l["aifg"],
          desc = l["aifg_help"],
          get = function() if AstronaXDB[player]["aifg"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["aifg"] = new; end,
        },
        -------------------------
        are = {
          order = 41, type = "toggle", width = "full",
          name = l["are"],
          desc = l["are_help"],
          get = function() if AstronaXDB[player]["are"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["are"] = new; end,
        },
        aro = {
          order = 42, type = "toggle", width = "full",
          name = l["aro"],
          desc = l["aro_help"],
          get = function() if AstronaXDB[player]["aro"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["aro"] = new; end,
        },
        aste = {
          order = 43, type = "toggle", width = "full",
          name = l["aste"],
          desc = l["aste_help"],
          get = function() if AstronaXDB[player]["aste"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["aste"] = new; end,
        },
        tyr = {
          order = 44, type = "toggle", width = "full",
          name = l["tyr"],
          desc = l["tyr_help"],
          get = function() if AstronaXDB[player]["tyr"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["tyr"] = new; end,
        },
      }
    },
    options_info = {
      type = "group",
      name = "Infos",
      order = order,
      args = {
        iobr = {
          order = 51, type = "toggle", width = "full",
          name = l["iobr"],
          desc = l["iobr_help"],
          get = function() if AstronaXDB[player]["iobr"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["iobr"] = new; end,
        },
        tkww = {
          order = 52, type = "toggle", width = "full",
          name = l["tkww"],
          desc = l["tkww_help"],
          get = function() if AstronaXDB[player]["tkww"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["tkww"] = new; end,
        },
        tis = {
          order = 52, type = "toggle", width = "full",
          name = l["tis"],
          desc = l["tis_help"],
          get = function() if AstronaXDB[player]["tis"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["tis"] = new; end,
        },
        tgham = {
          order = 53, type = "toggle", width = "full",
          name = l["tgham"],
          desc = l["tgham_help"],
          get = function() if AstronaXDB[player]["tgham"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["tgham"] = new; end,
        },
        tlmc = {
          order = 54, type = "toggle", width = "full",
          name = l["tlmc"],
          desc = l["tlmc_help"],
          get = function() if AstronaXDB[player]["tlmc"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["tlmc"] = new; end,
        },
        tmrc = {
          order = 55, type = "toggle", width = "full",
          name = l["tmrc"],
          desc = l["tmrc_help"],
          get = function() if AstronaXDB[player]["tmrc"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["tmrc"] = new; end,
        },
        txp = {
          order = 56, type = "toggle", width = "full",
          name = l["txp"],
          desc = l["txp_help"],
          get = function() if AstronaXDB[player]["txp"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["txp"] = new; end,
        },
      }
    },
    options_bar = {
      type = "group",
      name = "FuBar",
      order = order,
      args = {
        bar_rs = {
          order = 60, type = "toggle", width = "full",
          name = l["bar_rs"],
          desc = l["bar_help"],
          get = function() if AstronaXDB[player]["bar_rs"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["bar_rs"] = new; AstronaX:OnTextUpdate(); end,
        },
        bar_ti = {
          order = 61, type = "toggle", width = "full",
          name = l["bar_ti"],
          desc = l["bar_help"],
          get = function() if AstronaXDB[player]["bar_ti"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["bar_ti"] = new; AstronaX:OnTextUpdate(); end,
        },
        bar_tp = {
          order = 62, type = "toggle", width = "full",
          name = l["bar_tp"],
          desc = l["bar_help"],
          get = function() if AstronaXDB[player]["bar_tp"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["bar_tp"] = new; AstronaX:OnTextUpdate(); end,
        },
        bar_gs = {
          order = 63, type = "toggle", width = "full",
          name = l["bar_gs"],
          desc = l["bar_help"],
          get = function() if AstronaXDB[player]["bar_gs"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["bar_gs"] = new; AstronaX:OnTextUpdate(); end,
        },
        bar_fe = {
          order = 64, type = "toggle", width = "full",
          name = l["bar_fe"],
          desc = l["bar_help"],
          get = function() if AstronaXDB[player]["bar_fe"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["bar_fe"] = new; AstronaX:OnTextUpdate(); end,
        },
        bar_te = {
          order = 65, type = "toggle", width = "full",
          name = l["bar_te"],
          desc = l["bar_help"],
          get = function() if AstronaXDB[player]["bar_te"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["bar_te"] = new; AstronaX:OnTextUpdate(); end,
        },
        bar_he = {
          order = 66, type = "toggle", width = "full",
          name = l["bar_he"],
          desc = l["bar_help"],
          get = function() if AstronaXDB[player]["bar_he"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["bar_he"] = new; AstronaX:OnTextUpdate(); end,
        },
        bar_1k = {
          order = 67, type = "toggle", width = "full",
          name = l["bar_1k"],
          desc = l["bar_help"],
          get = function() if AstronaXDB[player]["bar_1k"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["bar_1k"] = new; AstronaX:OnTextUpdate(); end,
        },
        bar_rt = {
          order = 68, type = "toggle", width = "full",
          name = l["bar_rt"],
          desc = l["bar_help"],
          get = function() if AstronaXDB[player]["bar_rt"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["bar_rt"] = new; AstronaX:OnTextUpdate(); end,
        },
        timer_1k = {
          order = 69, type = "toggle", width = "full",
          name = l["bar_timer_1kw"],
          desc = l["bar_help"],
          get = function() if AstronaXDB[player]["bar_timer_1kw"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["bar_timer_1kw"] = new; AstronaX:OnTextUpdate(); end,
        },
        bar_ho = {
          order = 70, type = "toggle", width = "full",
          name = l["bar_ho"],
          desc = l["bar_help"],
          get = function() if AstronaXDB[player]["bar_ho"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["bar_ho"] = new; AstronaX:OnTextUpdate(); end,
        },
        bar_og = {
          order = 71, type = "toggle", width = "full",
          name = l["bar_og"],
          desc = l["bar_help"],
          get = function() if AstronaXDB[player]["bar_og"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["bar_og"] = new; AstronaX:OnTextUpdate(); end,
        },
        bar_gg = {
          order = 72, type = "toggle", width = "full",
          name = l["bar_gg"],
          desc = l["bar_help"],
          get = function() if AstronaXDB[player]["bar_gg"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["bar_gg"] = new; AstronaX:OnTextUpdate(); end,
        },
        bar_lm = {
          order = 73, type = "toggle", width = "full",
          name = l["bar_lm"],
          desc = l["bar_help"],
          get = function() if AstronaXDB[player]["bar_lm"] == 1 then return true else return false end end,
          set = function(_,v) local new = 0 if v then new = 1 end AstronaXDB[player]["bar_lm"] = new; AstronaX:OnTextUpdate(); end,
        },
      }
    },
  },
};

LibStub("AceConfig-3.0"):RegisterOptionsTable("AstronaX", options)
LibStub("AceConfigDialog-3.0"):AddToBlizOptions("AstronaX")

-- init slash command to change autologin text
SLASH_AstronaX1, SLASH_AstronaX2 = "/ax", "/astronax";
SlashCmdList["AstronaX"] = AstronaX
function SlashCmdList.AstronaX(_cmd)
  local toggleStatusStrings = {l["disabled"], l["enabled"]}
  local cmd, parameter = strsplit(" ", _cmd:lower(), 2)
  local displayHelp = false
  local parameterIsDigit = false
  
  ---------------------------------------------------------------
  if ( parameter == nil) then
    displayHelp = true
  elseif( tonumber(parameter) ~= nil and tonumber(parameter) >= 0 ) then
    parameterIsDigit = true
    parameter = tonumber(parameter)
  elseif (parameter ~= nil) then
    parameterIsDigit = false
  else
    displayHelp = true
  end
  ---------------------------------------------------------------
  if(cmd == "aifk") then
    if( parameter ~= nil and string.match(parameter, '%a') and string.len(parameter) >= 2) then
      AstronaXDB.auto_inv_whisper_text = parameter;
      print(addon_color..l[cmd].." "..l["was %s and was set to %s."]:format(addon_highlight..l["activated"]..addon_color, addon_highlight..parameter..addon_color));
    elseif displayHelp then
      print(addon_color..l["How to use function %s?"]:format(addon_highlight..l[cmd]..addon_color))
      print(addon_color..l["Current status is %s and keyword is %s."]:format(addon_highlight..toggleStatusStrings[AstronaXDB[player][cmd]+1]..addon_color, addon_highlight..AstronaXDB.auto_inv_whisper_text..addon_color))
      print(addon_color.." "..SLASH_AstronaX1.." "..cmd.." "..addon_highlight.."0"..addon_color..spacertab..l["This will disable the function."])
      print(addon_color.." "..SLASH_AstronaX1.." "..cmd.." "..addon_highlight.."1"..addon_color..spacertab..l["This will enable the function."])
      print(addon_color.." "..SLASH_AstronaX1.." "..cmd.." "..addon_highlight..l["keyword"]..addon_color..spacertab..l["This will set the invite code to %s."]:format(addon_highlight..l["keyword"]..addon_color))
    elseif parameterIsDigit then
      AstronaXDB[player][cmd] = parameter
      print(addon_color..l["The function %s is now %s."]:format(addon_highlight..l[cmd]..addon_color, addon_highlight..toggleStatusStrings[parameter+1]..addon_color));
    else
      print(addon_color..l["The text for %s is too short, use 3 or more chars."]:format(addon_highlight..l[cmd]..addon_color));
    end
  elseif(cmd == "abm" or cmd == "abml") then
    if displayHelp then
      print(addon_color..l["How to use function %s?"]:format(addon_highlight..l[cmd]..addon_color))
      print(addon_color..l["Current status is %s and goldlimit set to %s."]:format(addon_highlight..toggleStatusStrings[AstronaXDB[player][cmd]+1]..addon_color, addon_highlight..AstronaXDB[player]["abmv"]..addon_color))
      print(addon_color.." "..SLASH_AstronaX1.." "..cmd.." "..addon_highlight.."0"..addon_color..spacertab..l["This will disable the function."])
      print(addon_color.." "..SLASH_AstronaX1.." "..cmd.." "..addon_highlight.."1"..addon_color..spacertab..l["This will enable the function."])
      print(addon_color.." "..SLASH_AstronaX1.." "..cmd.." "..addon_highlight..l["goldlimit"]..addon_color..spacertab..l["This will set gold ammount to keep on your character."])
    elseif(parameter >= 0) then
      if parameter == 0 or parameter == 1 then
        AstronaXDB[player]["abm"] = parameter
        print(addon_color..l["The function %s is now %s."]:format(addon_highlight..l[cmd]..addon_color, addon_highlight..toggleStatusStrings[parameter+1]..addon_color));
      elseif parameter > 1 then
        AstronaXDB[player]["abmv"] = parameter;
        print(addon_color..l[cmd].." "..l["is now %s and goldlimit was set to %s."]:format(addon_highlight..l["activated"]..addon_color, addon_highlight..parameter..addon_color));
      end
    else
      print(addon_color..l[cmd].." "..l["Paramter invalid, use 0 or 1 to change state, or higher number to set Goldlimit."])
    end
  elseif isValueInsideArray(function_array, cmd) then
    displayHelpForFunction(cmd, parameter)
  else
    print(addon_highlight..l["Displaying features with out commands:"])
    print(addon_color.."Auto Track Character Stats")
    print(addon_color.." - Class")
    print(addon_color.." - Emlems")
    print(addon_color.." - Gearscore")
    print(addon_color.." - Gold")
    print(addon_color.." - Honor")
    print(addon_color.." - WotLK RaidIDs")
    print(addon_color.." - TalentSpecs")
    print(addon_color.." - Apply for Raids or Search for a Raid GUI")
    print(addon_color.."Alt Trading Items -> based on DayTrader")
    print(addon_color.."Check Daily HC Status")
    print(addon_color.."Check Weekly PVP Quest")
    print(addon_color.."Check Weekly Raid Status")
    print(addon_color.."Click on FuBar or Minimap button to toggle Addon settings")
    print(addon_warning.."---------------------------------------------")
    print(addon_highlight..l["Displaying available commands:"])
    for k in pairs(function_array) do
      print(addon_color.." /ax "..addon_highlight..function_array[k]..addon_color..spacertab..l[function_array[k]])
    end
    print(addon_warning.."---------------------------------------------")
  end
end

function displayHelpForFunction(cmd, parameter)
  local helptext = l[cmd.."_help"]
  if ( parameter == 0 or parameter == 1 )  then
    AstronaXDB[player][cmd] = parameter
    print(addon_color..l["The function %s is now %s."]:format(addon_highlight..l[cmd]..addon_color, addon_highlight..toggleStatusStrings[parameter+1]..addon_color));
    AstronaX:OnTextUpdate()
  else
    print(addon_color..l["How to use function %s?"]:format(addon_highlight..l[cmd]..addon_color))
    print(addon_color..l["Current status is %s."]:format(addon_highlight..toggleStatusStrings[AstronaXDB[player][cmd]+1]..addon_color))
    if helptext and string.len(helptext) >= 2 then
      print(addon_color..helptext)
    end
    print(addon_color.." "..SLASH_AstronaX1.." "..cmd.." "..addon_highlight.."0"..addon_color..spacertab..l["This will disable the function."])
    print(addon_color.." "..SLASH_AstronaX1.." "..cmd.." "..addon_highlight.."1"..addon_color..spacertab..l["This will enable the function."])
  end
end

function AstronaX:OnInitialize()
	--self:SetIcon("Interface\\Icons\\trade_blacksmithing")
end

function AstronaX:OnEnable()
  self:RegisterEvent("ADDON_LOADED")
  self:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
  self:RegisterEvent("CHAT_MSG_CHANNEL")
  self:RegisterEvent("CHAT_MSG_WHISPER")
  self:RegisterEvent("CHAT_MSG_WHISPER_INFORM")
  self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
  self:RegisterEvent("CONFIRM_LOOT_ROLL")
  self:RegisterEvent("START_LOOT_ROLL")
  self:RegisterEvent("CONFIRM_DISENCHANT_ROLL")
	self:RegisterEvent("GUILDBANKFRAME_OPENED")
  self:RegisterEvent("LFG_PROPOSAL_SHOW")
  self:RegisterEvent("MAIL_INBOX_UPDATE")
  self:RegisterEvent("MERCHANT_SHOW")
  self:RegisterEvent("MERCHANT_CLOSED")
	self:RegisterEvent("PARTY_INVITE_REQUEST")
  self:RegisterEvent("PARTY_LOOT_METHOD_CHANGED")
  self:RegisterEvent("PLAYER_DIFFICULTY_CHANGED")
  self:RegisterEvent("PLAYER_DEAD")
	self:RegisterEvent("PLAYER_ENTERING_WORLD")
  self:RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	self:RegisterEvent("PLAYER_LOGOUT")
  self:RegisterEvent("PLAYER_MONEY")
  self:RegisterEvent("PLAYER_REGEN_ENABLED")
	self:RegisterEvent("PLAYER_TARGET_CHANGED")
	self:RegisterEvent("PLAYER_TALENT_UPDATE")
	self:RegisterEvent("PLAYER_UNGHOST")
	self:RegisterEvent("PLAYER_XP_UPDATE")
	self:RegisterEvent("QUEST_TURNED_IN")
	self:RegisterEvent("QUEST_QUERY_COMPLETE")
	self:RegisterEvent("RAID_INSTANCE_WELCOME")
	self:RegisterEvent("RAID_ROSTER_UPDATE")
	self:RegisterEvent("RESURRECT_REQUEST")
	self:RegisterEvent("UNIT_AURA")
	self:RegisterEvent("UNIT_MANA")
	self:RegisterEvent("UPDATE_FACTION")
	self:RegisterEvent("UPDATE_INSTANCE_INFO")
	self:RegisterEvent("ZONE_CHANGED")
	self:RegisterEvent("ZONE_CHANGED_INDOORS")
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
  SetCVar("cameraDistanceMax", 60)	
  if AstronaXDB[player] then
    self:UpdateTalents()
  end
	QueryQuestsCompleted()
end

local f = CreateFrame("Frame")
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
f:SetScript("OnEvent", OnEvent)

function AstronaX:ADDON_LOADED()
    if(not AstronaXDB) then
      AstronaXDB = {}
      print(addon_highlight..l["This is the first start up of AstronaX. Thank you for installing."])
    end
    if(not AstronaXDB[player] ) then
      AstronaXDB[player] = {}
      print(addon_highlight..l["This is the first use of AstronaX on this character. Database has been initialized."])
      print(addon_color..l["Please use %s or %s to display the help, you can enable or disable features as you like."]:format(addon_highlight..SLASH_AstronaX1..addon_color, addon_highlight..SLASH_AstronaX2..addon_color))
      print(addon_color..l["You can also use our GUI to change settings, just go to ESC -> Interface -> Addons -> AstronaX."])
      
      AstronaXDB[player]["abmv"] = 1000 --"gold auto balance money", "")    
      AstronaXDB[player]["abm"] = 0 --"gold auto balance money", "")
      AstronaXDB.auto_inv_whisper_text = "ainv";
      AstronaXDB.addon_color = green;
      AstronaXDB.addon_highlight = yellow;
    end
    
    for k in pairs(function_array) do
      if not(AstronaXDB[player][function_array[k]]) then
        AstronaXDB[player][function_array[k]] = 1
      end
    end
    if not(isRaid()) and GetCVar("farclip") ~= 400 and AstronaXDB[player]["farclip_toggle"] == 1 then
      AstronaXDB.farclip = GetCVar("farclip");
    elseif not(isRaid()) and GetCVar("farclip") == 400 and AstronaXDB[player]["farclip_toggle"] == 1 then
	  if AstronaXDB[UnitName("player")]["farclip_toggle"] ~= nil then
	    SetCVar( "farclip", AstronaXDB[UnitName("player")]["farclip_toggle"])
	  else
	    SetCVar( "farclip", 4000)
	  end
    end
    addon_color = AstronaXDB.addon_color
    addon_highlight = AstronaXDB.addon_highlight  
end

function AstronaX:ACTIVE_TALENT_GROUP_CHANGED()
  self:UpdateTalents()
end

function AstronaX:START_LOOT_ROLL(rollID)
  if AstronaXDB[player]["arol"] == 1 then
    self:AutoRollOnLoot(rollID)
  end
end

function AstronaX:CHAT_MSG_CHANNEL(msg, author, _, _, _, _, _, _, channel_name, _, _)
  if author ~= nil and author ~= "" and  msg ~= nil and msg ~= "" then
    self:GetLastChannelPostingAuthors(author, channel_name)
  end
  if AstronaXDB[player]["twcrs"] == 1 then
    self:InformOnRaidSearchRequests(msg, author, channel_name)
  end
end

function AstronaX:CHAT_MSG_WHISPER(msg, unit)
  if AstronaXDB[player]["aifk"] == 1 then
    self:AcceptInvWhisper(msg, unit)
  end
end

function AstronaX:CHAT_MSG_WHISPER_INFORM(msg, target)
  if AstronaXDB[player]["aifa"] == 1 then
    self:AcceptChatInvites(msg, target)
  end
  gone_afk_at = 0
end

function AstronaX:COMBAT_LOG_EVENT_UNFILTERED(_, event, _, sourceName, _, _, destName, _, spellID, spellName, _, SuffixParam1, _, _)
	if AstronaXDB[player]["tis"] == 1 and event == "SPELL_INTERRUPT" and destName and spellName and isInCombat() then
    if IsLeadOrAssist() then
      local channel_target = "PARTY"
      if GetNumRaidMembers() > 1 then
        channel_target = "RAID"
      end
      --SendChatMessage(l["%s used %s to interupt %s by %s"]:format(sourceName, GetSpellLink(spellID), GetSpellLink(SuffixParam1), destName), channel_target)
      print(GetClassColor(GetClassName(sourceName))..l["%s used %s to interupt %s by %s"]:format(sourceName..yellow, "|T"..select(3, GetSpellInfo(spellID))..":12|t"..GetSpellLink(spellID), "|T"..select(3, GetSpellInfo(SuffixParam1))..":12|t"..GetSpellLink(SuffixParam1), destName))
    else 
      print(GetClassColor(GetClassName(sourceName))..l["%s used %s to interupt %s by %s"]:format(sourceName..yellow, "|T"..select(3, GetSpellInfo(spellID))..":12|t"..GetSpellLink(spellID), "|T"..select(3, GetSpellInfo(SuffixParam1))..":12|t"..GetSpellLink(SuffixParam1), destName))
    end
	end
end

function AstronaX:CONFIRM_LOOT_ROLL(rollID, rollType)
  if AstronaXDB[player]["clgr"] == 1 then 
    self:AcceptRollConfirmation(rollID, rollType)
  end
end

function AstronaX:CONFIRM_DISENCHANT_ROLL(rollID, rollType)
  if AstronaXDB[player]["cldr"] == 1 then 
    self:AcceptRollConfirmation(rollID, rollType)
  end
end

function AstronaX:GUILDBANKFRAME_OPENED()
  if (AstronaXDB[player]["abm"] == 1 or AstronaXDB[player]["abml"] == 1) and AstronaXDB[player]["abmv"] > 0 then
    self:UpdateMoney()
  end
end

function AstronaX:LFG_PROPOSAL_SHOW()
  PlaySoundFileAstronax("Sound\\Interface\\levelup2.wav");	-- IGNORES VOLUME
end

function AstronaX:MAIL_INBOX_UPDATE()
    if AstronaXDB[player]["alam"] == 1 then
      self:UnregisterEvent("MAIL_INBOX_UPDATE")
      CheckInbox();
      self:GetMail();
      CheckInbox();
      self:RegisterEvent("MAIL_INBOX_UPDATE")
    end
end

function AstronaX:MERCHANT_SHOW()
    if AstronaXDB[player]["staui"] == 1 then
      self:AutoSellJunk()
    end
    if AstronaXDB[player]["are"] == 1 then
      self:AutoRepair()
    end
end

function AstronaX:MERCHANT_CLOSED()
	self:OnTextUpdate()
end

function AstronaX:PARTY_INVITE_REQUEST(inviter)
  if AstronaXDB[player]["aiff"] == 1 then
    self:AcceptFriendInvites(inviter)
  end
  if AstronaXDB[player]["aifg"] == 1 then
    self:AcceptGuildInvites(inviter)
  end
  if AstronaXDB[player]["aifa"] == 1 and pending_inviter then
    self:CheckInviteRequest(inviter)
  end
end

function AstronaX:PARTY_LOOT_METHOD_CHANGED()
  if AstronaXDB[player]["tlmc"] == 1 then
    PlaySoundFileAstronax("Sound\\Interface\\Glyph_MajorCreate.wav");	-- IGNORES VOLUME
    print(addon_color..l["Loot Method changed to %s."]:format(addon_highlight..GetLootType()..addon_color))
  end
  self:OnTextUpdate()
end

function AstronaX:PLAYER_DEAD()
  inviting_unit = nil
end

function AstronaX:PLAYER_DIFFICULTY_CHANGED()
  self:UpdateTalents()
  self:OnTextUpdate()
end

function AstronaX:PLAYER_ENTERING_WORLD()
  self:UpdateTalents()
  if AstronaXDB[player]["txp"] == 1 then
    xp_current_status = UnitXP("player")
    self:GetPlayerXPStatus()
  end
  self:GetRaidBlocks()
end

function AstronaX:PLAYER_EQUIPMENT_CHANGED()
  self:GetItemLevel()
	self:OnTextUpdate()
end

function AstronaX:PLAYER_FLAGS_CHANGED(unit)
  if unit == player and UnitIsAFK(player) then
    gone_afk_at = time()
  elseif not UnitIsAFK(player) then
    gone_afk_at = 0
  end
end

function AstronaX:PLAYER_LOGOUT()
  Recount:ResetData()
	self:UpdateTalents()
	self:GetRaidBlocks()
	self:GetDailyStatus()
	self:UpdateWeekly()
end

function AstronaX:PLAYER_MONEY()
  self:UpdateTalents()
  self:GetRaidBlocks()
	self:GetDailyStatus()
	self:UpdateWeekly()
	self:OnTextUpdate()
end

function AstronaX:PLAYER_REGEN_ENABLED()
  sound_played_counter = 0
  pending_rezz = 0
	self:OnTextUpdate()
  if AstronaXDB[player]["tgham"] == 1 then
    self:GetGroupStats()
  end
end

function AstronaX:PLAYER_TARGET_CHANGED()
  if AstronaXDB[player]["aslm"] == 1 then
    self:UpdateLootMethod()
  end
  if AstronaXDB[player]["aste"] == 1 then
    self:AutoSetTracking()
  end
end

function AstronaX:PLAYER_TALENT_UPDATE()
	self:UpdateTalents()
  self:OnTextUpdate()
end

function AstronaX:PLAYER_UNGHOST()
  self:AcceptRevival()
end

function AstronaX:PLAYER_XP_UPDATE(unit)
  if AstronaXDB[player]["txp"] == 1 then
    self:GetPlayerXPStatus(unit)
  end
end

function AstronaX:QUEST_TURNED_IN()
	self:UpdateWeekly()
	self:GetDailyStatus()
end

function AstronaX:QUEST_QUERY_COMPLETE()
	self:UpdateWeekly()
	self:GetDailyStatus()
end

function AstronaX:RAID_ROSTER_UPDATE()
  --isRaid()
end

function AstronaX:RAID_INSTANCE_WELCOME()
  isRaid()
  self:UpdateTalents()
  self:OnTextUpdate()
end

function AstronaX:RESURRECT_REQUEST(inviter)
  self:AcceptRevival(inviter)
end

function AstronaX:UNIT_AURA()
  self:GetUnitAuraUpdates()
end

function AstronaX:UNIT_MANA()
  if AstronaXDB[player]["tmrc"] == 1 then
    if GetClassName() == "DRUID" then
      local mm = UnitManaMax("player");
      local int = UnitStat("player", 4);
      local mfi = math.min(20,int)+15*(int-math.min(20,int));
      local BaseMana = mm - mfi
      self:GetReplenishmentReminder(l["spell_Anregen"], (BaseMana*2.25))
    elseif GetClassName() == "MAGE" then
      self:GetReplenishmentReminder(l["spell_Hervorrufung"], 0.4)
    elseif GetClassName() == "PALADIN" then
      self:GetReplenishmentReminder(l["spell_GoettlicheBitte"], 0.75)
    elseif GetClassName() == "PRIEST" then
      --self:GetReplenishmentReminder("Hymne der Hoffnung", 0.856)
      self:GetReplenishmentReminder(l["spell_Schattengeist"], 0.5)
    elseif GetClassName() == "SHAMAN" then
      self:GetReplenishmentReminder(l["spell_TotemderManaflut"], 0.66) --normal 0.75
    end
  end
end

function AstronaX:UPDATE_FACTION()
  self:OnTextUpdate()
  self:OnTextUpdate()
end

function AstronaX:UPDATE_INSTANCE_INFO()
  self:UpdateTalents()
  self:OnTextUpdate()
end

function AstronaX:ZONE_CHANGED()
  isRaid()
  self:GetRaidBlocks()
	self:GetDailyStatus()
	self:UpdateWeekly()
  self:UpdateTalents()
	self:OnTextUpdate()
	QueryQuestsCompleted()
end

function AstronaX:ZONE_CHANGED_INDOORS()
  isRaid()
  self:UpdateTalents()
	self:OnTextUpdate()
end

function AstronaX:ZONE_CHANGED_NEW_AREA()
  isRaid()
  self:UpdateTalents()
	self:OnTextUpdate()
end
------------------------------------------------------------------------------------------------------------------------------
function AstronaX:AcceptChatInvites(msg, target)
  if (string.match(msg, '%d.%dk') or string.match(msg, '%d%d%d%dgs') or msg == "+" or msg == "inv") and target ~= player then  -- matched 5.5k z.b.
    pending_inviter = target
    print(addon_color..l["Chat Partner %s is a possible inviter, AutoInvite will accept invites."]:format(addon_highlight..target..addon_color))
  elseif target ~= pending_inviter then
    pending_inviter = nil
  end
end

function AstronaX:AcceptFriendInvites(unit)
  local numberOfFriends = GetNumFriends();   
  for i = 1, numberOfFriends do
    local fname = GetFriendInfo(i);
    if( fname == unit ) then
      pending_inviter = unit
      self:CheckInviteRequest(unit)
      return
    end
  end
end

function AstronaX:AcceptGuildInvites(unit)
  local numTotalMembers = GetNumGuildMembers();
  for i = 1, numTotalMembers do
    local gname = GetGuildRosterInfo(i);
    if( gname == unit ) then
      pending_inviter = unit
      self:CheckInviteRequest(unit)
      return
    end
  end
end

function AstronaX:AcceptInvWhisper(msg, unit)
  if( unit ~= nil and msg ~= nil and AstronaXDB.auto_inv_whisper_text ~= nil) then
    if (msg:lower():match(AstronaXDB.auto_inv_whisper_text)) then
      pending_inviter = unit
      local inviting = true
      self:CheckInviteRequest(unit, inviting)
    end
  end
end

function AstronaX:AutoRepair()
  local method = nil
  local cost = 0
  
  if CanMerchantRepair() == 1 then
    local RepairCost, canRepair = GetRepairAllCost()
    if not canRepair or RepairCost == 0 then return end
    local money = GetMoney()
    -- gbammount currently selected Guild Rank can withdraw per day in GOLD instead of cupper
    local gbAmount = GetGuildBankWithdrawMoney()
    gbAmmount = gbAmount * 10000
    -- gbmoney amount of money in the guild bank in copper. 
    local gbMoney = GetGuildBankMoney()
    
    cost = RepairCost
    if IsInGuild() and ( RepairCost <= gbMoney and RepairCost <= gbAmount) then
    --if IsInGuild() and ((gbAmount == -1 and gbMoney > RepairCost) or gbAmount > RepairCost) then
      method = 2
    elseif money > RepairCost then
      method = 1
    else
      print(addon_color..l["You neither have enough gold in your poket nor offers your guildbank enough to pay your repair costs."])
    end
    
    if method == 2 or method == 1 then 
      local payedByWho = {l["personally"], l["by guildbank"]}
      local payByGuild = nil
      if method == 2 then
        payByGuild = 1
      end
      PlaySoundFileAstronax("Sound\\Spells\\ArmorKitBuffSound.wav");
      PlaySoundFileAstronax("Sound\\Interface\\LootCoinSmall.wav");
      RepairAllItems(payByGuild)
      print(addon_color..l["Repaircosts about %s have been payed %s."]:format(format_money(cost, true, true, true)..addon_color, addon_highlight..payedByWho[method]..addon_color));
    end
  end
end

function AstronaX:AcceptRevival(inviter)
  if inviter ~= nil then
      inviting_unit = inviter
  end
  PlaySoundFileAstronax("Sound\\Spells\\YarrrrImpact.wav");
  
  if isInGroup() and inviting_unit ~= nil then
    if pending_rezz == 1 and AstronaXDB[player]["iobr"] then
      SendChatMessage(l["%s's battle Rezz accepted"]:format(inviting_unit),GetGroupType());
      pending_rezz = 0;
    end
    if isInCombat(inviting_unit)== 1 and AstronaXDB[player]["aro"] then
      SendChatMessage(l["%s's battle Rezz received, accepting soon"]:format(inviting_unit),GetGroupType());
      pending_rezz = 1;
    else
      AcceptResurrect();
      StaticPopup1Button1:Click();
      if AstronaXDB[player]["tyr"] == 1 and inviting_unit ~= nil then
        SendChatMessage(revival_responses[math.random(1,table.getn(revival_responses))],"WHISPER" ,COMMON ,inviting_unit);
      end
    end
  end
end

function AstronaX:AcceptRollConfirmation(rollID, rollType)
  if ( rollType > 1 ) then
    ConfirmLootRoll( rollID, rollType );
    --RollID :    Number - As passed by the event. (The number increases with every roll you have in a party) 
    --roll :    Number - Type of roll: (also passed by the event)
    --	      1 : Need roll 
    --        2 : Greed roll 
    --        3 : Disenchant roll 
    StaticPopup1Button2:Click();
  end
end

function AstronaX:AutoRollOnLoot(rollID)
  local _, name, _, quality, bindOnPickUp, canNeed, _, canDisenchant = GetLootRollItemInfo(rollID);
  local rollType = 4 -- default nothing
  local rollTypeStrings = {l["needed"],l["greeded"],l["dizzed"],l["will manually select"]}
  
  if UnitLevel(player) == maxLevel and UnitIsDeadOrGhost(player) == nil then
    if canNeed and bindOnPickUp ~= 1 and not(isRaid()) then
      rollType = 1  -- 1 = need
    elseif isRaid() or AstronaXDB[player]["ilvl_minimum"] > 200 then
      if canDisenchant and quality <= 3 then
        rollType = 3  -- 3 = dizz
      elseif quality <= 3 then
        rollType = 2  -- 2 = gier
      end
    end
  end

  if rollType < 4 then
    RollOnLoot(rollID,rollType);
  end
  local quality_color = select(4, GetItemQualityColor(quality))
  --local itemLink, itemRarity, itemLevel, itemMinLevel, itemType = GetItemInfo(name)
  print(addon_color..l["Roll for"].." "..quality_color.."["..name.."]".." "..red..rollTypeStrings[rollType]..addon_color..addon_color..".")
end

function AstronaX:AutoSellJunk()
	local soldItems = 0;
	local sellPrice = 0;
  
  --print(addon_color..l["Selling Junk and unwanted items"])
	for bag=0,4 do
		for slot=0,GetContainerNumSlots(bag) do
			local itemLink = GetContainerItemLink(bag, slot)
			local itemCount = select(2, GetContainerItemInfo(bag,slot))
			local itemLock = select(3, GetContainerItemInfo(bag,slot))
			local itemQuality = select(4, GetContainerItemInfo(bag,slot))
			local itemId = GetContainerItemID(bag, slot);
            
			if itemId ~= nil and 
				itemQuality < 4 and 
				itemLock == nil and 
				itemCount < 10  and 
				isValueInsideArray(sellJunkList, itemId) or
				itemLink and select(3, GetItemInfo(itemLink)) == 0
			then
				print(addon_color..itemCount.."x "..itemLink) --..orange" Debug (ID:"..itemId.." Quality:"..itemQuality..")")
				sellPrice = sellPrice + (select(11, GetItemInfo(itemLink)) * GetItemCount(itemLink));
				soldItems = soldItems +1;
				
				ShowMerchantSellCursor(1)
				UseContainerItem(bag, slot)
			end
		end
	end
  
  if soldItems > 0 then
    PlaySoundFileAstronax("Sound\\Interface\\LootCoinSmall.wav");
    if sellPrice > 0 then
      print(addon_color..soldItems.." "..addon_highlight..l["stack(s)%s sold for %s."]:format(addon_color, format_money(sellPrice, true, true, true)..addon_color));
    end
  end
end

function AstronaX:AutoSetTracking()
  if GetClassName() == "HUNTER" and UnitIsEnemy("player","target") then
    for i = 1, GetNumTrackingTypes() do
      local name, _, active = GetTrackingInfo(i);
      if UnitCreatureType("target") and string.match(name, UnitCreatureType("target")) then
        if active then  -- geht iwie nicht mit active == false
        else
          SetTracking(i,true);
          print(addon_color..l["AutoTracking set to %s."]:format(addon_highlight..name..addon_color))
          break
        end
      end
    end
  end
end

function AstronaX:AutoTradeEmblems()
  for x=2,5 do
    if GetItemCount(selectionIds[x]) >= 10 then
      local emblemcountModulo = math.fmod(GetItemCount(selectionIds[x]),10)
      local tradeammount = GetItemCount(selectionIds[x]) - emblemcountModulo
      local loop = tradeammount / 10
      
      self:TradeEmblems(loop, x, 2)
      self:TradeEmblems(loop, x, 3)
      self:TradeEmblems(loop, x, 1)
    end
  end
end

function AstronaX:TradeEmblems(loop, x, i)
  if GetItemInfo(selectionIds[x+1]) == GetMerchantItemInfo(i) then
    for l=1,loop do
      BuyMerchantItem(i, 10);
    end
  end
end

function AstronaX:CheckInviteRequest(unit, inviting)
  if inviting == nil then inviting = false end
  if UnitIsAFK(player) then
    local time_in_afk
    if gone_afk_at ~= 0 then
      gone_afk_at = time()
    else
      time_in_afk = (time() - gone_afk_at)
    end
    local minutes = floor(mod(time_in_afk,3600)/60)

    SendChatMessage(l["AutoInvite declined, sorry been afk for %s min(s)."]:format(minutes),"WHISPER" ,COMMON ,unit);
    return
  elseif GetLFGQueueStats() then
    SendChatMessage(l["AutoInvite declined, already in DB queue."],"WHISPER" ,COMMON ,unit);
    return
  elseif (isInGroup() and not IsLeadOrAssist() ) then --checked ob ziel vorhanden ist und man inviten darf
    SendChatMessage(l["AutoInvite declined, i am no group leader and do not have invite permissions."],"WHISPER" ,COMMON ,unit);
    return
  elseif pending_inviter and pending_inviter == unit then
    print(addon_color..l["AutoInvite accepted."])
    if inviting == true and (not isInGroup(player) or IsLeadOrAssist() )  then
      -- wir laden ein weil jemand inviter gesetzt hat?
      InviteUnit(pending_inviter);
      pending_inviter = nil
    else
      -- wir wurden eingeladen, weil vorheriger whisper?    
      AcceptGroup();
      StaticPopup_Hide("PARTY_INVITE");
    end
    return
  end
end

function AstronaX:GetPercentageTextColor(value)
  local color = purple
  local text = "purple"
  if value ~= nil then
    if value > 80 then
      color = green
      text = "green"
    elseif value > 60 then
      color = yellow
      text = "yellow"
    elseif value > 40 then
      color = orange
      text = "orange"
    elseif value > 20 then
      color = red
      text = "red"
    end
  else
    color = yellow
    text = "yellow"
  end
  return color, text
end

function AstronaX:GetArmorStatus()
	local total_damage = 0	
	for i = 1, 18 do
		local current, maximum = GetInventoryItemDurability(i);
		if current ~= nil and maximum ~= nil and current ~= 100 then
			local tmp = ((1 - current / maximum)  * 100)
			if tmp > 0 then
				total_damage = total_damage + tmp
			end
		end		
	end
	
  local total_percentage = 100
	if total_damage > 0 then
		total_percentage = 100 - total_damage / 18 * 2 --nur jedes 2 item hat eine haltbarkeit
	end

	total_percentage = string.format('%.f', math.floor( (total_percentage)))
	return total_percentage
end

function AstronaX:GetAttachment(mailIndex, sender)
	local itemIndex = select(8, GetInboxHeaderInfo(mailIndex))
	local itemname, _, itemcount = GetInboxItem(mailIndex, itemIndex);
	if ( itemname and itemcount ) then
		if sender == nil then sender = "Unknown" end
		print(addon_highlight.." "..mailIndex..addon_color..". "..l["Mail from %s contains %sx %s."]:format(white..sender..addon_color,addon_highlight..itemcount, GetInboxItemLink(mailIndex, itemname)));
	end
	TakeInboxItem(mailIndex, itemIndex);
end

function AstronaX:GetDailyStatus(db_player)	-- returns true if Daily hc has been completed and false if it free
	if player == db_player or db_player == nil then
		if GetLFGDungeonRewards(262) then
			AstronaXDB[player]["dailyheroic"] = time()+GetQuestResetTime()
			return true
		end
	elseif AstronaXDB[db_player]["dailyheroic"] ~= nil then
    if ( AstronaXDB[db_player]["dailyheroic"] > time() ) then
      return true
    end
  end
  return false
end

function AstronaX:GetGroupStats()
  local total_mana_percentage = 0;
  local total_health_percentage = 0;
  local mana_class_count = 0;
  local total_class_count = 0;
  local grp_type = "party";

  if isInGroup() and GetGroupCount() > 1  then		
    if GetGroupCount() > 4 then
      grp_type = "raid";
    end
    for i=1,GetGroupCount() do
      if UnitManaMax(grp_type..i) ~= 100 and UnitManaMax(grp_type..i) > 100 then 
        if 
          GetClassName(grp_type..i) == "DRUID" or
          GetClassName(grp_type..i) == "MAGE" or
          GetClassName(grp_type..i) == "PALADIN" or
          GetClassName(grp_type..i) == "PRIEST" or
          GetClassName(grp_type..i) == "SHAMAN"
        then
          total_mana_percentage = total_mana_percentage + (UnitMana(grp_type..i) / UnitManaMax(grp_type..i));
          mana_class_count = mana_class_count + 1;
        end
      elseif UnitIsDeadOrGhost(grp_type..i) == nil and UnitHealth(grp_type..i) > 1 then --nil= nicht tot oder geist
        total_health_percentage = total_health_percentage + (UnitHealth(grp_type..i) / UnitHealthMax(grp_type..i));
        total_class_count = total_class_count + 1;
      end
    end
    
    -- addiere player selbst hinzu da nicht teil der gruppe
    if UnitManaMax("player") > 100 then 
      total_mana_percentage = total_mana_percentage + (UnitMana("player") / UnitManaMax("player"));
      mana_class_count = mana_class_count + 1;
    end
    if UnitHealth("player") > 1 then
      total_health_percentage = total_health_percentage + (UnitHealth("player") / UnitHealthMax("player"));
      total_class_count = total_class_count + 1;
    end
    
    if mana_class_count > 0 then
      total_mana_percentage = round(total_mana_percentage / mana_class_count);
    else 
      total_mana_percentage = 100;
    end
    if total_class_count > 0 then
      total_health_percentage = round(total_health_percentage / total_class_count );
    else
      total_health_percentage = 0;
    end
    
    local Mcolor = red;
    if total_mana_percentage > 70 then Mcolor = addon_color
    elseif total_mana_percentage > 35 then Mcolor = orange; end
    
    local Hcolor = red;
    if total_health_percentage > 70 then Hcolor = addon_color
    elseif total_health_percentage > 35 then Hcolor = orange; end
    
    if (total_health_percentage or total_health_percentage) ~= 100 then
      UIErrorsFrame:AddMessage(l["Group Mana"]..": "..total_mana_percentage.."%", 0.25, 0.88, 0.82, 53, 4);
      UIErrorsFrame:AddMessage(l["Group Health"]..": "..total_health_percentage.."%", 0.1, 1.0, 0.1, 53, 4);
      print("|cff22ff22"..l["Group Health"]..": "..Hcolor..total_health_percentage.."%");
      print("|cff44DDCC"..l["Group Mana"]..": "..Mcolor..total_mana_percentage.."%");
    end
  end
end

function AstronaX:GetItemLevel(target)
  if target == nil then
    target = player
  end
  local TotelItemLevel = 0
  local TotalItemCount = 0
  local MinItemLevel = nill

  for i=1,18 do
    if GetInventoryItemID(target, i) and (i < 18 or GetClassName(target) == "HUNTER" or GetClassName(target) == "WARRIOR" ) then
      local _, _, _, itemLevel = GetItemInfo(GetInventoryItemID(target, i))
      if itemLevel and i ~= 4 then
        TotelItemLevel = TotelItemLevel + itemLevel
        TotalItemCount = TotalItemCount + 1
      end
      if itemLevel then
        if MinItemLevel == nil or MinItemLevel > itemLevel then
          MinItemLevel = itemLevel
        end
      end
    end
  end
  local average = math.floor( TotelItemLevel / TotalItemCount )  
  return average, MinItemLevel
end

function AstronaX:GetLastChannelPostingAuthors(author, channel_name)
  if channel_name == "World" or channel_name == "world" then
    world_player_list[author] = time()
    
    local smallest_value = ""
    local smallest_key = ""
    for k,v in loop_table_sorted(world_player_list) do -- sorts by v = Value
      if smallest_key == "" or smallest_value > v then
        smallest_value = v
        smallest_key = k
      end
    end
    
    if GetArraySize(world_player_list) > 10 then
      world_player_list[smallest_key] = nil
    end
  end
end

function AstronaX:GetMail()
	if mailCount ~= GetInboxNumItems() then
		mailCount = GetInboxNumItems()
		if mailCount > 0 then
			local _, _, sender, subject, money, CODAmount, _, hasItem, _, _, _, _, isGM = GetInboxHeaderInfo(mailCount);
			
			if (hasItem or money > 0) and CODAmount == 0  and isGM ~= 1 then

				if money > 0 then
					local _, isInvoice = GetInboxText(mailCount);
					if isInvoice then
						local _, itemName, playerName, _, _, _, _ = GetInboxInvoiceInfo(mailCount);
						print(addon_highlight.." "..mailCount..addon_color..". "..l["Mail contains %s from %s for %s."]:format(format_money(money, true, true, true)..addon_color,addon_highlight..playerName..addon_color, white..itemName));
            
					else
            print(addon_highlight.." "..mailCount..addon_color..". "..l["Mail by %s regarding %s contains %s."]:format(addon_highlight..sender..addon_color, white..subject, format_money(money, true, true, true)..addon_color));
					end
					TakeInboxMoney(mailCount);
					PlaySoundFileAstronax("Sound\\Interface\\LootCoinSmall.wav");
				end
				
				if hasItem and sender then
          local sender = select(3, GetInboxHeaderInfo(mailCount))
					self:GetAttachment( mailCount, sender )
					PlaySoundFileAstronax("Sound\\Interface\\Pickup\\PutDownBag.wav");
				end	
			end
			--CloseMail()
		end
	end
end

function AstronaX:GetPlayerXPStatus(unit)
  if unit == nil then
    unit = "player"
  end
  
  if UnitName(unit) == player then
    if not(isInCombat()) then
      local xp_new = UnitXP(unit);
      local xp_max = UnitXPMax(unit);
      local xp_count = UnitXP(unit) - xp_current_status
      
      if xp_max > 0 and xp_count > 0 then
        local text = addon_color..l["ExperienceStatus: "]
        --text = text..red..round(xp_old/xp_max).."% "
        text = text..yellow.."+ "..purple..xp_count.." XP"..yellow.." ( |cffA330C9"..round(xp_count/xp_max).."%"..yellow..") "
        text = text.."|TInterface\\Icons\\spell_magic_managain:12|t"
        text = text.." = "..green..round(xp_new/xp_max).."%";
        print(text)
      end
      xp_current_status = UnitXP(unit)
    end
  end
end

function AstronaX:GetRaidstatusColor(raidname, player_ilvl, ilvl, size)
  local returnString = nil
  if raidname == nil then
    raidname = 0
  end
  
  if raidname > time() then
    returnString = color_redgrayed..size..yellow
  elseif player_ilvl >= ilvl then
    returnString = color_yellowgrayed..size..yellow
  elseif raidname == nil then
    returnString = color_greengrayed..size..yellow
  else
    returnString = green..size..yellow
  end
  return returnString
end

function AstronaX:GetRaidBlocks()
  local WeeklyResetTime = nil
	local now = time()
    for index=1,GetNumSavedInstances() do
        local instanceName, _, instanceReset, instanceDifficulty, locked, _, _, isRaid, maxPlayers, _ = GetSavedInstanceInfo(index)
        if locked and isRaid then
          AstronaXDB[player][instanceName..";"..maxPlayers..";"..instanceDifficulty] = (now+instanceReset)
          WeeklyResetTime = now+instanceReset
        end
    end
    if WeeklyResetTime then
      return WeeklyResetTime
    end
end

function AstronaX:GetReplenishmentReminder(spell, PowerTarget)
  if last_sound_played[spell] == nil then last_sound_played[spell] = GetTime() end
    
	if isInCombat() and isInGroup() then
		local PowerProzent = UnitPower("player") / UnitPowerMax("player");
    if ( PowerTarget > 1 ) then PowerTarget = (UnitPowerMax("player") - PowerTarget) / UnitPowerMax("player") end
    
    if (
      GetSpellLink(spell) ~= nil and
      PowerProzent <= PowerTarget and
      GetSpellCooldownSeconds(spell) == 0 and
      (GetTime()-last_sound_played[spell]) >= (3 * sound_played_counter)
    ) then
      sound_played_counter = sound_played_counter + 1
      last_sound_played[spell] = GetTime();
      
      PlaySoundFileAstronax("Sound\\Interface\\UI_BnetToast.wav");
      UIErrorsFrame:AddMessage(">>> "..l["Use %s now"]:format(GetSpellLink(spell)).." <<<", 1.0, 0.1, 1.0, 53, 3);
      print(">>> "..l["Use %s now"]:format(GetSpellLink(spell)).." <<<",100,0,100);
    end
	end   
end

function AstronaX:CheckIfSpellIsPresent(spell,target)
  local spell_found = false;
  if UnitLevel("player") == maxLevel and UnitName(target) and UnitExists(target) and UnitIsDeadOrGhost(target) == nil and UnitUsingVehicle("player") ~= 1 then
    for i=1,40 do
      if UnitBuff(target,i) ~= nil then
        if string.match(UnitBuff(target,i), spell) then
          spell_found = true
          last_sound_played[spell] = GetTime()
          return
        end
      end
    end
  end
  return spell_found
end

function AstronaX:GetSpellUponTarget(spell,target,soundpath)
  local spell_found = self:CheckIfSpellIsPresent(spell,target);
  if UnitLevel("player") == maxLevel and UnitName(target) and UnitExists(target) and UnitIsDeadOrGhost(target) == nil and UnitUsingVehicle("player") ~= 1 then
    if spell_found == false then
      self:AlertOnMissingBuff(spell,soundpath)
    end
  end
end

function AstronaX:AlertOnMissingBuff(spell,soundpath)
  if last_sound_played[spell] == nil then
    last_sound_played[spell] = GetTime()
  end
  if (GetTime()-last_sound_played[spell]) >= (sound_played_counter * 2) then
    sound_played_counter = sound_played_counter + 1
    last_sound_played[spell] = GetTime();

    if soundpath then
      PlaySoundFileAstronax(soundpath);
    end
    
    print(red..">>> "..purple..spell..red.." not activ <<<");
    UIErrorsFrame:AddMessage(">>> "..spell.." "..l["not"].." "..l["activ"].." <<<", 1.0, 0.0, 1.0, 53, 5);
  end
end


function AstronaX:GetUnitAuraUpdates()
	if isInCombat() and isInGroup() and GetClassName() == "PRIEST" then
    if self:CheckIfSpellIsPresent("Schattengestalt", "player") ~= false then
      self:GetSpellUponTarget("Vampirumarmung","player","Sound\\Effects\\DeathImpacts\\InWater\\mDeathImpactSmallWaterA.wav")
    end
    self:GetSpellUponTarget("Inneres Feuer","player","Sound\\Effects\\DeathImpacts\\InWater\\mDeathImpactSmallWaterA.wav")
  
  elseif isInCombat() and isInGroup() and GetClassName() == "MAGE" then
    self:GetSpellUponTarget("Rüstung","player","Sound\\Effects\\DeathImpacts\\InWater\\mDeathImpactSmallWaterA.wav")
    self:GetSpellUponTarget("Magie fokussieren","focus","Sound\\Interface\\LFG_Rewards.wav")
    
  elseif isInCombat() and isInGroup() and GetClassName() == "DEATHKNIGHT" then
    self:GetSpellUponTarget("Horn des Winters","player","Sound\\Effects\\DeathImpacts\\InWater\\mDeathImpactSmallWaterA.wav")
    
  elseif isInCombat() and isInGroup() and GetClassName() == "HUNTER" then
    self:GetSpellUponTarget("Aspekt","player","Sound\\Effects\\DeathImpacts\\InWater\\mDeathImpactSmallWaterA.wav")
    
  elseif isInCombat() and isInGroup() and GetClassName() == "ROGUE" then
    if select(1,GetWeaponEnchantInfo()) == nil or select(4,GetWeaponEnchantInfo()) == nil then
      self:AlertOnMissingBuff("Poison(s)","Sound\\Interface\\Sound\\Interface\\ReadyCheck.wav")
    end
    
  elseif isInCombat() and isInGroup() and GetClassName() == "SHAMAN" then
    if select(1,GetWeaponEnchantInfo()) == nil then
      self:AlertOnMissingBuff("WeaponBuff MainHand","Sound\\Interface\\Sound\\Interface\\ReadyCheck.wav")
    end
    if OffhandHasWeapon() == true and select(4,GetWeaponEnchantInfo()) == nil then
      self:AlertOnMissingBuff("WeaponBuff Offhand","Sound\\Interface\\Sound\\Interface\\ReadyCheck.wav")
    end
    self:GetSpellUponTarget("schild","player","Sound\\Effects\\DeathImpacts\\InWater\\mDeathImpactSmallWaterA.wav")
    self:GetSpellUponTarget("Erdschild","focus","Sound\\Interface\\LFG_Rewards.wav")
    
  elseif isInCombat() and isInGroup() and GetClassName() == "WARLOCK" then
    self:GetSpellUponTarget("rüstung","player","Sound\\Effects\\DeathImpacts\\InWater\\mDeathImpactSmallWaterA.wav")
    if select(1,GetWeaponEnchantInfo()) == nil then
      self:AlertOnMissingBuff("WeaponBuff","Sound\\Interface\\Sound\\Interface\\ReadyCheck.wav")
    end
    
  elseif isInCombat() and isInGroup() and GetClassName() == "WARRIOR" then
    if self:CheckIfSpellIsPresent("Segen der Macht", "player") == false then
      self:GetSpellUponTarget("ruf","player","Sound\\Effects\\DeathImpacts\\InWater\\mDeathImpactSmallWaterA.wav")
    end
  end
end

function AstronaX:GetWeeklyStatus(db_player)	-- returns true if weekly hc has been completed and false if it free
	if AstronaXDB[db_player]["weeklyraidquest"] ~= nil then
		if (AstronaXDB[db_player]["weeklyraidquest"]) > time() then
			return true
		end
	end
	return false
end

function AstronaX:AnnounceRaidSearch(author,color,raid, minIlvl)
  PlaySoundFileAstronax("Sound\\Interface\\MagicClick.wav")
  print(addon_color.."RaidWatch: "..addon_highlight..author..green.." is looking for "..color..raid..green)
end

function AstronaX:CheckRaidIDandRelevance(author, msgFound, ilvl_minimum, msgColor, raidPattern, raidName, msgInform)
  if string.match(msgFound, raidPattern) then  
    if 
      AstronaXDB[player]["ilvl_minimum"] < ilvl_minimum 
      and 
      (
        AstronaXDB[player][raidName] == nil
        or
        AstronaXDB[player][raidName] < time() 
      )
    then
      local difficultyMode = ""
      if string.match(msgFound, '%s*[Hh][Cc][Ss]?%s*') then
        difficultyMode = "+ HCs"
      end
      self:AnnounceRaidSearch(author, msgColor, msgInform..string.match(msgFound, '%s*[1-4][0-9]%s*')..difficultyMode, AstronaXDB[player]["ilvl_minimum"])
    end
  end
end

function AstronaX:InformOnRaidSearchRequests(msg, author, channel_name)
  if
    string.match(msg, '%s*[1-4][0-9]%s*')
    and not(string.match(msg, '%?'))
    and not(string.match(msg, '%='))
    and not(string.match(msg, '%:'))
    and not(string.match(msg, '%d%d%:%d%d'))
    and not(string.match(msg, '[Aa]nschlu[ßSs]+'))
    and not(string.match(msg, '[Oo]ffen'))
    and string.len(msg) > 20 -- nimmt an dass mindestens so viel text gesucht wird (lfm icc 1 tank /w me)
    and UnitLevel("player") == maxLevel 
    and AstronaXDB[player]["ilvl_minimum"] ~= nil 
    and author ~= player
  then
    self:CheckRaidIDandRelevance(author, msg, 300, orange, '[Ww]eekly', "weeklyraidquest", "Weekly")
    self:CheckRaidIDandRelevance(author, msg, 213, "|cffff6600", '[Oo][Bb][Ss][IiYy]%s*1[0-9]', "Das Obsidiansanktum;10;1", "Obsi")
    self:CheckRaidIDandRelevance(author, msg, 226, "|cffff6600", '[Oo][Bb][Ss][IiYy]%s*2[0-9]', "Das Obsidiansanktum;25;2", "Obsi")
    self:CheckRaidIDandRelevance(author, msg, 264, "|cff3366ff", '[Ii][Cc][Cc]%s*1[0-9]', "Eiskronenzitadelle;10;1", "ICC")
    self:CheckRaidIDandRelevance(author, msg, 277, "|cff3366ff", '[Ii][Cc][Cc]%s*2[0-9]', "Eiskronenzitadelle;25;2", "ICC")
    self:CheckRaidIDandRelevance(author, msg, 219, "|cff33cccc", '[Uu]lduar%s*1[0-9]', "Ulduar;10;1", "Ulduar")
    self:CheckRaidIDandRelevance(author, msg, 226, "|cff33cccc", '[Uu]lduar%s*2[0-9]', "Ulduar;25;2", "Ulduar")
    self:CheckRaidIDandRelevance(author, msg, 232, "|cffff6600", '[Oo][Nn][IiYy]%s*1[0-9]', "Onyxias Hort;10;1", "Ony")
    self:CheckRaidIDandRelevance(author, msg, 245, "|cffff6600", '[Oo][Nn][IiYy]%s*2[0-9]', "Onyxias Hort;25;2", "Ony")
    self:CheckRaidIDandRelevance(author, msg, 271, "|cffff5050", '[Rr][Uu][Bb][IiYy]%s*1[089]', "Das Rubinsanktum;10;1", "Rubi")
    self:CheckRaidIDandRelevance(author, msg, 284, "|cffff5050", '[Rr][Uu][Bb][IiYy]%s*[1-2][0-9]', "Das Rubinsanktum;25;2", "Rubi")
    self:CheckRaidIDandRelevance(author, msg, 232, "|cff993300", '[Pp][Dd][Kk]%s*1[0-9]', "Prüfung des Kreuzfahrers;10;1", "PdK")
    self:CheckRaidIDandRelevance(author, msg, 245, "|cff993300", '[Pp][Dd][Kk]%s*2[0-9]', "Prüfung des Kreuzfahrers;25;2", "PdK")
    self:CheckRaidIDandRelevance(author, msg, 245, "|cff993300", '[Pp][Dd][Oo][Kk]%s*1[0-9]', "Prüfung des Kreuzfahrers;10;3", "PdoK")
    self:CheckRaidIDandRelevance(author, msg, 258, "|cff993300", '[Pp][Dd][Oo][Kk]%s*2[0-9]', "Prüfung des Kreuzfahrers;25;4", "PdoK")
    self:CheckRaidIDandRelevance(author, msg, 251, "|cff99ccff", '[Aa][Kk]%s*1[0-9]', "Archavons Kammer;10;1", "AK")
    self:CheckRaidIDandRelevance(author, msg, 270, "|cff99ccff", '[Aa][Kk]%s*2[0-9]', "Archavons Kammer;25;2", "AK")
  end
end

function AstronaX:UpdateLootMethod()
  -- falls player target ein gegner ist
  if UnitIsEnemy("player","target") then
    --falls das target boss level hat
    if UnitLevel("target") == -1 and GetLootMethod() ~= "master" and GetGroupCount() > 10 then 
        if IsLead() then
          SetLootMethod("master", player);
          print(addon_color..l["Loot Method changed to %s."]:format(addon_highlight.."Pluendermeister"..addon_color))
        end
      --lootmethod
      --"roundrobin"    Round-robin, looting cycles evenly through group members. 
      --"group"    Group loot, round-robin for normal items, rolling for special ones. 
      --"needbeforegreed"    Need before greed, round-robin for normal items, selective rolling for special ones.
      --"master"    Master looter, designated player distributes loot.
      --"personalloot"  Personal loot, any loot acquired is placed directly in bags. 
    elseif UnitLevel("target") == -1 or UnitLevel("target") == nil then
        --print(addon_color.."Loot Methode nicht geaendert weil im Kampf")
    elseif isInCombat() then
      if GetLootMethod() ~= "group" and GetLootMethod() ~= "needbeforegreed"  then
        if IsLead() then
          SetLootMethod("needbeforegreed", 2);
          print(addon_color..l["Loot Method changed to %s."]:format(addon_highlight.."Need4Greed"..addon_color))
        end
        --threshold
        --0 - Poor
        --1 - Common
        --2 - Uncommon
        --3 - Rare
        --4 - Epic
        --5 - Legendary
        --6 - Artifact 
      end
    end
  end
end

function AstronaX:UpdateMoney()
  local current_money = GetMoney();
  local deposit = current_money - (AstronaXDB[player]["abmv"] * 100 * 100);
  local withdraw = (100 * 100 * AstronaXDB[player]["abmv"] ) - current_money;
  
  if deposit > 0 and AstronaXDB[player]["abm"] == 1 then
    print(addon_color..l["Deployed %s to our guildbank."]:format(format_money(deposit, true, true, true)..addon_color));
    DepositGuildBankMoney(deposit);
    PlaySoundFileAstronax("Sound\\Interface\\LootCoinSmall.wav");
  end
  
  if withdraw > 0 and AstronaXDB[player]["abml"] == 1 then
    if CanWithdrawGuildBankMoney() then
      if( withdraw <= GetGuildBankMoney() ) then
        print(addon_color..l["Took %s from our guildbank."]:format(format_money(withdraw, true, true, true)..addon_color));
        WithdrawGuildBankMoney(withdraw);
        PlaySoundFileAstronax("Sound\\Interface\\LootCoinSmall.wav");
      else
        print(red..l["Your withdraw limit does not allow to retrieve enough gold from the guildbank."]);
      end
    else
      print(red..l["No permissions to retrieve gold from the guildbank."]);
    end
  end
end

function AstronaX:UpdateWeekly()
	local questscompleted = {}
	GetQuestsCompleted(questscompleted)
	--print("check derzeitigen spieler")
	
	--[[ ID's of all raid weekly quests:
	24590, 24589, 24588, 24587, 24586, 24585
	24584, 24583, 24582, 24581, 24580, 24579
	]]--
  
  local tmp = self:GetRaidBlocks()
  if tmp and questscompleted ~= nil then
    if questscompleted[13183] or questscompleted[13181]  then
      AstronaXDB[player]["weeklypvpquest"] = tmp
    end
    for i=24579,24590 do
      if questscompleted[i] then
          AstronaXDB[player]["weeklyraidquest"] = tmp
          return true
      end
      --print(i.." wurde nicht abgeschlossen")
    end
  end
	--print("weekly bisher nicht abgeschlossen")
	return false
end

function AstronaX:UpdateTalents()
  for i = 1, GetNumTalentGroups() do
    specCache[i] = specCache[i] or {}
    local thisCache = specCache[i]
    -- Let the Blizzard code do all of the dirty work. This also ensures that it's consistent with whatever Blizzard says.
    TalentFrame_UpdateSpecInfoCache(thisCache, false, false, i)
    if thisCache.primaryTabIndex and thisCache.primaryTabIndex ~= 0 then
      thisCache.specName = thisCache[thisCache.primaryTabIndex].name
      thisCache.mainTabIcon = thisCache[thisCache.primaryTabIndex].icon
    else
      if thisCache.totalPointsSpent == 0 then
        thisCache.specName = "None"
      else
        thisCache.specName = "Hybrid"
      end
      thisCache.mainTabIcon = TALENT_HYBRID_ICON
    end
    thisCache.specGroupName = i
  end
  
  activeGroup = GetActiveTalentGroup()
  local curCache = specCache[activeGroup]
  
  local a = specCache[activeGroup][1].pointsSpent or 0
  local b = specCache[activeGroup][2].pointsSpent or 0
  local c = specCache[activeGroup][3].pointsSpent	or 0
  
  --print(curCache.specGroupName.." Talents with ("..a.."/"..b.."/"..c..") known as "..curCache.specName)
  player_talents_points = "("..red..a..yellow.."/"..orange..b..yellow.."/"..green..c..")"
  player_talents_image = curCache.mainTabIcon
  
  if curCache.mainTabIcon ~= nil then
    if curCache.specGroupName == 1 then
      AstronaXDB[player]["talentspec_primary"] = curCache.mainTabIcon;
    elseif curCache.specGroupName == 2 then
      AstronaXDB[player]["talentspec_secondary"] = curCache.mainTabIcon;
    end
    AstronaXDB[player]["talent_specname"] = curCache.specName
  end
end

function AstronaX:OnClick(button)
	if button == "LeftButton" then
    if IsShiftKeyDown() then
      self:ToggleTalents()
    elseif IsAltKeyDown()  then
      self:CreateRaidApplyGUI() 
    elseif IsControlKeyDown() then
      self:CreateRaidSearchGUI()
    else
      self:ToggleConfig()
    end
	end
end

function AstronaX:ToggleConfig()
  if not isApplicationOpen then
    LibStub("AceConfigDialog-3.0"):Open("AstronaX")
    isApplicationOpen = true
  else
    LibStub("AceConfigDialog-3.0"):Close("AstronaX")
    isApplicationOpen = false
  end
end


function AstronaX:ToggleTalents()
  if GetNumTalentGroups() < 2 then
    print(red..l["This character does not yet have dual specialization."])
    return
  else
    SetActiveTalentGroup(-GetActiveTalentGroup() + 3)
  end
end

function AstronaX:OnMenuRequest(level, value)
	if level == 1 then
		dewdrop:AddLine(
			'text', l["Trade Emblems"],
			'arg1', self,
			'func', "AutoTradeEmblems",
			'closeWhenClicked', true
		)
		dewdrop:AddLine(
			'text', l["ToggleTalents"],
			'arg1', self,
			'func', "ToggleTalents",
			'closeWhenClicked', true
		)
    dewdrop:AddLine()
    dewdrop:AddLine(
			'text', l["Apply"],
			'arg1', self,
			'func', "CreateRaidApplyGUI",
			'closeWhenClicked', false
    )
    if IsLeadOrAssist() then
      dewdrop:AddLine(
        'text', l["SetDBMTimer"],
        'arg1', self,
        'func', "SetDBMTimer",
        'closeWhenClicked', true
      )
    end
		dewdrop:AddLine(
			'text', l["Raid Member Search"],
			'arg1', self,
			'func', "CreateRaidSearchGUI",
			'closeWhenClicked', true
		)
    dewdrop:AddLine()
		dewdrop:AddLine(
			'text', l["Settings"],
			'arg1', self,
			'func', "ToggleConfig",
			'closeWhenClicked', true
		)
    dewdrop:AddLine()
  elseif value == "sink" then
    dewdrop:FeedAceOptionsTable(sink:GetSinkAce2OptionsDataTable().output, 1)
  end
end

function AstronaX:OnTextUpdate()
	local count_frost = count_frost or GetItemCount(selectionIds[1])
	local count_triumph = count_triumph or GetItemCount(selectionIds[2])
	local count_conquest = count_conquest or GetItemCount(selectionIds[3])
	local count_honor = count_honor or GetItemCount(selectionIds[4])
	local count_herosim = count_herosim or GetItemCount(selectionIds[5])
	local count_steinbewahrer = count_steinbewahrer or GetItemCount(selectionIds[6])
	local count_pvphonor = count_pvphonor or GetHonorCurrency()	
	local count_timer_1kw = GetWintergraspWaitTime()
  local Rep_name, Rep_standing, Rep_min, Rep_max, Rep_value = GetWatchedFactionInfo()

  
  local texture = ""
  if count_timer_1kw == nil then
    count_timer_1kw = "|TInterface\\Icons\\ability_parry:12|t ".."|cffff0000"..l["Battle"]
    
    if last_sound_played["1kw"] == nil then last_sound_played["1kw"] = GetTime() end
    if AstronaXDB[player]["tkww "] == 1 and not(GetZoneText() == "Wintergrasp" or GetZoneText() == "Tausendwintersee") and (GetTime()-last_sound_played["1kw"]) >= 20 then
      last_sound_played["1kw"] = GetTime();
      PlaySoundFileAstronax("Sound\\Spells\\PVPWarning"..UnitFactionGroup("player")..".wav");
      UIErrorsFrame:AddMessage(l["Battle"].." in 1k Winter", 1.0, 0.1, 0.1, 53, 4);
      print(red..l["Battle"]..addon_highlight.." in 1k Winter.")
    end
  else
    local thousend_winter = ""
    for i=1,40 do
      if (UnitBuff("player",i) == "Essenz von Tausendwinter") then thousend_winter = UnitFactionGroup("player") end
    end
    
    texture = "|TInterface\\Icons\\spell_frost_wizardmark:12|t "  
    if (GetCurrentMapContinent() == 4 or GetCurrentMapContinent() == -1) then
      if UnitFactionGroup("player") == "Horde" then
        if thousend_winter == "Horde" and ( GetCurrentMapContinent() == -1 or GetCurrentMapContinent() == 4)  then
          texture = "|TInterface\\Icons\\inv_bannerpvp_01:12|t" --1 = horde
        elseif not(GetCurrentMapContinent() == -1) then
          texture = "|TInterface\\Icons\\inv_bannerpvp_02:12|t" --2 = allianz
        end
      elseif UnitFactionGroup("player") == "Alliance" then
        if thousend_winter == "Alliance" and ( GetCurrentMapContinent() == -1 or GetCurrentMapContinent() == 4)  then
          texture = "|TInterface\\Icons\\inv_bannerpvp_02:12|t" --2 = allianz
        elseif not(GetCurrentMapContinent() == -1) then
          texture = "|TInterface\\Icons\\inv_bannerpvp_01:12|t" --1 = horde
        end
      end
    end
    
    local timeUnit = l["sec"]
    if count_timer_1kw > 60 then
      timeUnit = l["min"]
      count_timer_1kw = texture.." "..math.floor(count_timer_1kw / 60 +0.5).." "..timeUnit
    else
      count_timer_1kw = texture.." "..math.floor(count_timer_1kw).." "..timeUnit
    end
      
  end

  local ilvl_average, ilvl_minimum = self:GetItemLevel()
  AstronaXDB[player]["ilvl"] = ilvl_average
  AstronaXDB[player]["ilvl_minimum"] = ilvl_minimum
  
	if UnitLevel("player") == maxLevel and AstronaXDB[player] then
		AstronaXDB[player]["class"] = GetClassName()
		if GearScore_GetScore(UnitName("player"), "player") ~= nil then
			AstronaXDB[player]["gearscore"] = GearScore_GetScore(UnitName("player"), "player");
    else
      AstronaXDB[player]["gearscore"] = 0
		end
    
		AstronaXDB[player][selectionIds[1]] = count_frost;	
		AstronaXDB[player][selectionIds[2]] = count_triumph;	
		AstronaXDB[player][selectionIds[3]] = count_conquest;	
		AstronaXDB[player][selectionIds[4]] = count_honor;	
		AstronaXDB[player][selectionIds[5]] = count_herosim;	
		AstronaXDB[player][selectionIds[6]] = count_steinbewahrer;	
		AstronaXDB[player]["honor"] = count_pvphonor;	
		AstronaXDB[player]["money"] = GetMoney();	
		AstronaXDB[player]["armor"] = self:GetArmorStatus();
    AstronaXDB[player]["title"] = GetTitleName(GetCurrentTitle())
	end
	local LootColor = select(4, GetItemQualityColor(GetLootThreshold()) )
	local GearScoreColored = GetGearscoreColored(AstronaXDB[player]["gearscore"])

  local text = ""
  if AstronaXDB[player]["bar_rs"] == 1 then
    text = text.." |TInterface\\Icons\\trade_blacksmithing:12|t "..self:GetPercentageTextColor(tonumber(self:GetArmorStatus()))..self:GetArmorStatus()..yellow.." %"..spacertab
  end
  if AstronaXDB[player]["bar_ti"] == 1 then
    text = text.."|T"..player_talents_image..":12|t"
    if AstronaXDB[player]["bar_tp"] == 0 then
      local talentName = "NoSpec"
      for k, v in pairs(short_spec_names) do
        if k == FirstCharUpper(AstronaXDB[player]["class"]).." "..AstronaXDB[player]["talent_specname"] then
          talentName = v
        end
      end
      text = text.." "..talentName
    end
  end
  if AstronaXDB[player]["bar_tp"] == 1 then
    text = text..player_talents_points
  end
  if AstronaXDB[player]["bar_tp"] == 1 or AstronaXDB[player]["bar_ti"] == 1 then
    text = text..spacertab
  end
  if AstronaXDB[player]["bar_gs"] == 1 then
    text = text.."|TInterface\\Icons\\Ability_warrior_defensivestance:12|t |cff"..GearScoreColored.."|r"..spacertab
  end
  if AstronaXDB[player]["bar_fe"] == 1 then
    text = text.."|TInterface\\Icons\\Inv_misc_frostemblem_01:12|t |cff0099ff"..count_frost.."|r"..spacertab
  end
  if AstronaXDB[player]["bar_te"] == 1 then
    text = text.."|TInterface\\Icons\\Spell_holy_summonchampion:12|t |cff8800CC"..count_triumph.."|r"..spacertab
  end
  if AstronaXDB[player]["bar_he"] == 1 then
    text = text.."|TInterface\\Icons\\spell_holy_proclaimchampion:12|t |cff0099ff"..count_herosim.."|r"..spacertab
  end
  if AstronaXDB[player]["bar_1k"] == 1 then
    text = text.."|TInterface\\Icons\\inv_misc_platnumdisks:12|t |cffffffff"..count_steinbewahrer..spacertab
  end
  if AstronaXDB[player]["bar_timer_1kw"] == 1 then
    text = text..count_timer_1kw..spacertab
  end
  if AstronaXDB[player]["bar_ho"] == 1 then
    text = text.."|TInterface\\Icons\\Inv_bannerpvp_01:12|t |cffff0000"..math.floor(count_pvphonor /1000).." / 75 k|r"..spacertab
  end
  if AstronaXDB[player]["bar_og"] == 1 then
    local fulldisplay = false
    if AstronaXDB[player]["bar_gg"] == 0 then 
      fulldisplay = true
    end
    text = text..format_money(GetMoney(), true, fulldisplay, true).."|r"..spacertab
  end
  if AstronaXDB[player]["bar_gg"] == 1 and IsInGuild() then
    text = text.."|TInterface\\Icons\\inv_shirt_guildtabard_01:12|t "..format_money(GetGuildBankMoney(), false, false, true).."|r"..spacertab
  end
  if AstronaXDB[player]["bar_lm"] == 1 then
    text = text.."|TInterface\\Buttons\\UI-GroupLoot-Dice-Down:14|t "..LootColor..GetLootType().."|r"..spacertab --..": "..yellow..GetInstanceSize()
  end
  if AstronaXDB[player]["bar_rt"] == 1 and Rep_name then
    if string.len(Rep_name) > 9 then
      Rep_name = string.sub(Rep_name, 1, 9).."."
    end
    text = text.."|TInterface\\Icons\\achievement_reputation_argentchampion:12|t "..reputation_colors[Rep_standing]..Rep_name.." "..math.floor(( (Rep_value - Rep_min) / (Rep_max-Rep_min) ) * 100 + 0.5).."%".."|r"..spacertab
  end
  
  self:SetText(text)
  return text
end
  
function AstronaX:OnTooltipUpdate()
  if not(isInCombat(player)) then
    self:OnTextUpdate()
    self:GetRaidBlocks()
    
    local cat = Tablet:AddCategory()
    if FuBar == nil then
      cat = Tablet:AddCategory('columns', 1)
      cat:AddLine('text',self:OnTextUpdate())
    end

    local sorted_table = {}
    for k in pairs(AstronaXDB) do
      table.insert(sorted_table, k)
    end
    table.sort(sorted_table)
    -- table.sort(sorted_table, function(a,b)
      -- if AstronaXDB[a]["gearscore"] == nil or AstronaXDB[b]["gearscore"] == nil then
        -- return true
      -- end
      -- return AstronaXDB[a]["gearscore"] > AstronaXDB[b]["gearscore"]
    -- end)

    if AstronaXDB[player]["tooltip_chardetails"] == 1 then
      local total_money = 0
      for i in pairs(sorted_table) do
        local _, v = sorted_table[i], AstronaXDB[ sorted_table[i] ]
        
        if v["money"] ~= nil and v["money"] > 0 then
          total_money = total_money + v["money"]
        end
      end

      local headers = {}      
      headers['text'] = ""
      self:create_tooltip_col(headers, AstronaXDB[player]["tooltip_gearscore"], "|TInterface\\Icons\\Ability_warrior_defensivestance:16|t")
      self:create_tooltip_col(headers, AstronaXDB[player]["tooltip_repair"], "|TInterface\\Icons\\trade_blacksmithing:16|t")
      self:create_tooltip_col(headers, AstronaXDB[player]["tooltip_emblem_264"], "|TInterface\\Icons\\Inv_misc_frostemblem_01:16|t")
      self:create_tooltip_col(headers, AstronaXDB[player]["tooltip_emblem_232"], "|TInterface\\Icons\\Spell_holy_summonchampion:16|t")
      self:create_tooltip_col(headers, AstronaXDB[player]["tooltip_emblem_226"], "|TInterface\\Icons\\spell_holy_championsgrace:16|t")
      self:create_tooltip_col(headers, AstronaXDB[player]["tooltip_emblem_213"], "|TInterface\\Icons\\spell_holy_proclaimchampion_02:16|t")
      self:create_tooltip_col(headers, AstronaXDB[player]["tooltip_emblem_200"], "|TInterface\\Icons\\spell_holy_proclaimchampion:16|t")
      self:create_tooltip_col(headers, AstronaXDB[player]["tooltip_emblem_1kw"], "|TInterface\\Icons\\inv_misc_platnumdisks:16|t")
      self:create_tooltip_col(headers, AstronaXDB[player]["tooltip_honor"], "|TInterface\\Icons\\inv_bannerpvp_01:16|t")
      self:create_tooltip_col(headers, AstronaXDB[player]["tooltip_money"], "|TInterface\\Icons\\inv_misc_coin_01:16|t"..format_money(total_money, false, false, true))
      self:create_tooltip_col(headers, AstronaXDB[player]["tooltip_title"], l["Title"])

      cat = Tablet:AddCategory('columns', GetArraySize(headers)+1)
      cat:AddLine(headers)

      for i, db_player in pairs(sorted_table) do
        local _, v = sorted_table[i], AstronaXDB[ sorted_table[i] ]
          
        if ( 
          (v["talentspec_primary"] or v["talentspec_secondary"]) and 
          v["class"] and 
          v["gearscore"] and 
          v["armor"] and 
          v[selectionIds[1]] and 
          v[selectionIds[2]] and 
          v[selectionIds[3]] and 
          v[selectionIds[4]] and 
          v[selectionIds[5]] and 
          v[selectionIds[6]] and 
          v["honor"] and 
          v["money"] and 
          v["title"]
        ) then
          local color_stein = "|cffCCEEFF"			
          if v[selectionIds[6]] < 30 then color_stein = "|cff445566" end
          if v[selectionIds[6]] == 0 then color_stein = color_blacked end
          
          local color_honor = "|cffFF0000"			
          if v["honor"] < 10000 then color_honor = "|cff660000" end
          if v["honor"] <= 2000 then color_honor = color_blacked end
          local rounded_honor =  str_pad(string.format('%.1f', math.floor( (v["honor"] /1000 * 10^1) + 0.5) / (10^1)),2).." k"
          
          local color_200 = "|cffCCEEFF"			
          if v[selectionIds[5]] < 10 then color_200 = "|cff445566" end
          if v[selectionIds[5]] == 0 then color_200 = color_blacked end

          local color_213 = "|cffFF99EE"
          if v[selectionIds[4]] < 10 then color_213 = "|cff884477" end
          if v[selectionIds[4]] == 0 then color_213 = color_blacked end
          
          local color_226 = "|cffFFEA80"
          if v[selectionIds[3]] < 10 then color_226 = "|cff887540" end
          if v[selectionIds[3]] == 0 then color_226 = color_blacked end

          local color_232 = "|cff8800CC"
          if v[selectionIds[2]] < 10 then color_232 = "|cff440088" end
          if v[selectionIds[2]] == 0 then color_232 = color_blacked end
          
          local color_264 = "|cff0099ff"
          if v[selectionIds[1]] < 23 then color_264 = "|cff0044aa" end
          if v[selectionIds[1]] == 0 then color_264 = color_blacked end
          
          local talents_specs = ""
          if v["talentspec_primary"] then
            talents_specs = talents_specs.."|T"..v["talentspec_primary"]..":16|t "
          else
            talents_specs = talents_specs.."|T"..unknownSpecIcon..":16|t "
          end
          
          if v["talentspec_secondary"] then
            talents_specs = talents_specs.."|T"..v["talentspec_secondary"]..":16|t "
          else
            talents_specs = talents_specs.."|T"..unknownSpecIcon..":16|t "
          end
          
          local armor_text = self:GetPercentageTextColor(tonumber(v["armor"]))..v["armor"]..yellow.." %"
          
          local cols = {}      
          cols['text'] = talents_specs.." "..GetClassColor(v["class"])..db_player
          self:create_tooltip_col(cols, AstronaXDB[player]["tooltip_gearscore"], "|cff"..GetGearscoreColored(v["gearscore"]))
          self:create_tooltip_col(cols, AstronaXDB[player]["tooltip_repair"], armor_text)
          self:create_tooltip_col(cols, AstronaXDB[player]["tooltip_emblem_264"], color_264..v[selectionIds[1]])
          self:create_tooltip_col(cols, AstronaXDB[player]["tooltip_emblem_232"], color_232..v[selectionIds[2]])
          self:create_tooltip_col(cols, AstronaXDB[player]["tooltip_emblem_226"], color_226..v[selectionIds[3]])
          self:create_tooltip_col(cols, AstronaXDB[player]["tooltip_emblem_213"], color_213..v[selectionIds[4]])
          self:create_tooltip_col(cols, AstronaXDB[player]["tooltip_emblem_200"], color_200..v[selectionIds[5]])
          self:create_tooltip_col(cols, AstronaXDB[player]["tooltip_emblem_1kw"], color_stein..v[selectionIds[6]])
          self:create_tooltip_col(cols, AstronaXDB[player]["tooltip_honor"], color_honor..rounded_honor)
          self:create_tooltip_col(cols, AstronaXDB[player]["tooltip_money"], format_money(v["money"],false))
          self:create_tooltip_col(cols, AstronaXDB[player]["tooltip_title"], v["title"])

          cols['func'] = function() self:CreateRaidApplyGUI(v["class"], v["gearscore"], v["talent_specname"]); end
          cat:AddLine(cols)
        end
      end
    end
    if AstronaXDB[player]["tooltip_instancelocks"] == 1 then
      local headers = {}      
      headers['text'] = ""
      self:create_tooltip_col(headers, AstronaXDB[player]["tooltip_dailyweekly"], "|TInterface\\Icons\\Inv_misc_frostemblem_01:20|t|n2x / 5x")
      self:create_tooltip_col(headers, AstronaXDB[player]["tooltip_pvpweekly"], "|TInterface\\Icons\\achievement_win_wintergrasp:20|t|nPvP")
      self:create_tooltip_col(headers, AstronaXDB[player]["tooltip_ak"], "|TInterface\\Icons\\inv_essenceofwintergrasp:20|t|nAK")
      self:create_tooltip_col(headers, AstronaXDB[player]["tooltip_naxx"], "|TInterface\\Icons\\achievement_boss_kelthuzad_01:20|t|nNaxx")
      self:create_tooltip_col(headers, AstronaXDB[player]["tooltip_obsi"], "|TInterface\\Icons\\achievement_boss_sartharion_01:20|t|nObsi")
      self:create_tooltip_col(headers, AstronaXDB[player]["tooltip_ulduar"], "|TInterface\\Icons\\achievement_boss_yoggsaron_01:20|t|nUlduar")
      self:create_tooltip_col(headers, AstronaXDB[player]["tooltip_onyxia"], "|TInterface\\Icons\\achievement_boss_onyxia:20|t|nOnyxia")
      self:create_tooltip_col(headers, AstronaXDB[player]["tooltip_pdk"], "|TInterface\\Icons\\achievement_reputation_argentcrusader:20|t|nPDK")
      self:create_tooltip_col(headers, AstronaXDB[player]["tooltip_pdok"], "|TInterface\\Icons\\achievement_reputation_argentcrusader:20|t|nPDoK")
      self:create_tooltip_col(headers, AstronaXDB[player]["tooltip_icc"], "|TInterface\\Icons\\achievement_boss_lichking:20|t|nICC")
      self:create_tooltip_col(headers, AstronaXDB[player]["tooltip_rubi"], "|TInterface\\Icons\\inv_misc_rubysanctum2:20|t|nRubi")

      cat = Tablet:AddCategory('columns', GetArraySize(headers)+1)
      cat:AddLine(headers)

      for i, db_player in pairs(sorted_table) do
        local _, v = sorted_table[i], AstronaXDB[ sorted_table[i] ]
        if (
          (v["talentspec_primary"] or v["talentspec_secondary"]) and 
          v["class"] and 
          v["ilvl"] and 
          v["ilvl_minimum"]
        ) then
          local dailyheroic = green.."+"
          if self:GetDailyStatus(db_player) then
            dailyheroic = red.."-"
          end
          
          local weeklyraidquest = green.."+"
          if self:GetWeeklyStatus(db_player) then
            weeklyraidquest = red.."-"
          end
          
          local weeklypvpquest = green.."+"
          if v["weeklypvpquest"] ~= nil and v["weeklypvpquest"] > time() then
            weeklypvpquest = red.."-"
          end
          
          local talents_specs = ""
          if v["talentspec_primary"] then
            talents_specs = talents_specs.."|T"..v["talentspec_primary"]..":16|t "
          else
            talents_specs = talents_specs.."|T"..unknownSpecIcon..":16|t "
          end
          
          if v["talentspec_secondary"] then
            talents_specs = talents_specs.."|T"..v["talentspec_secondary"]..":16|t "
          else
            talents_specs = talents_specs.."|T"..unknownSpecIcon..":16|t "
          end
        
          local ak = self:GetRaidstatusColor(v["Archavons Kammer;10;1"], v["ilvl_minimum"], 251, 10)
          ak = ak.." / "
          ak = ak..self:GetRaidstatusColor(v["Archavons Kammer;25;2"], v["ilvl_minimum"], 264, 25)
          
          local naxx = self:GetRaidstatusColor(v["Naxxramas;10;1"], v["ilvl_minimum"], 200, 10)
          naxx = naxx.." / "
          naxx = naxx..self:GetRaidstatusColor(v["Naxxramas;25;2"], v["ilvl_minimum"], 213, 25)
          
          local obs = self:GetRaidstatusColor(v["Das Obsidiansanktum;10;1"], v["ilvl_minimum"], 200, 10)
          obs = obs.." / "
          obs = obs..self:GetRaidstatusColor(v["Das Obsidiansanktum;25;2"], v["ilvl_minimum"], 213, 25)
          
          local uld = self:GetRaidstatusColor(v["Ulduar;10;1"], v["ilvl_minimum"], 219, 10)
          uld = uld.." / "
          uld = uld..self:GetRaidstatusColor(v["Ulduar;25;2"], v["ilvl_minimum"], 226, 25)
          
          local ony = self:GetRaidstatusColor(v["Onyxias Hort;10;1"], v["ilvl_minimum"], 232, 10)
          ony = ony.." / "
          ony = ony..self:GetRaidstatusColor(v["Onyxias Hort;25;2"], v["ilvl_minimum"], 245, 25)
          
          local pdk = self:GetRaidstatusColor(v["Prüfung des Kreuzfahrers;10;1"], v["ilvl_minimum"], 232, 10)
          pdk = pdk.." / "
          pdk = pdk..self:GetRaidstatusColor(v["Prüfung des Kreuzfahrers;25;2"], v["ilvl_minimum"], 254, 25)
          
          local pdok = self:GetRaidstatusColor(v["Prüfung des Kreuzfahrers;10;3"], v["ilvl_minimum"], 245, 10)
          pdok = pdok.." / "
          pdok = pdok..self:GetRaidstatusColor(v["Prüfung des Kreuzfahrers;25;4"], v["ilvl_minimum"], 258, 25)
          
          local icc = self:GetRaidstatusColor(v["Eiskronenzitadelle;10;1"], v["ilvl_minimum"], 264, 10)
          icc = icc.." / "
          icc = icc..self:GetRaidstatusColor(v["Eiskronenzitadelle;25;2"], v["ilvl_minimum"], 277, 25)
          
          local halion = self:GetRaidstatusColor(v["Das Rubinsanktum;10;1"], v["ilvl_minimum"], 271, 10)
          halion = halion.." / "
          halion = halion..self:GetRaidstatusColor(v["Das Rubinsanktum;25;2"], v["ilvl_minimum"], 284, 25)
             
          local cols = {}
          cols['text'] = talents_specs..GetClassColor(v["class"])..db_player
          
          self:create_tooltip_col(cols, AstronaXDB[player]["tooltip_dailyweekly"], dailyheroic..yellow.." / "..weeklyraidquest)
          self:create_tooltip_col(cols, AstronaXDB[player]["tooltip_pvpweekly"], weeklypvpquest)
          self:create_tooltip_col(cols, AstronaXDB[player]["tooltip_ak"], ak)
          self:create_tooltip_col(cols, AstronaXDB[player]["tooltip_naxx"], naxx)
          self:create_tooltip_col(cols, AstronaXDB[player]["tooltip_obsi"], obs)
          self:create_tooltip_col(cols, AstronaXDB[player]["tooltip_ulduar"], uld)
          self:create_tooltip_col(cols, AstronaXDB[player]["tooltip_onyxia"], ony)
          self:create_tooltip_col(cols, AstronaXDB[player]["tooltip_pdk"], pdk)
          self:create_tooltip_col(cols, AstronaXDB[player]["tooltip_pdok"], pdok)
          self:create_tooltip_col(cols, AstronaXDB[player]["tooltip_icc"], icc)
          self:create_tooltip_col(cols, AstronaXDB[player]["tooltip_rubi"], halion)

          cols['func'] = function() self:CreateRaidApplyGUI(v["class"], v["gearscore"], v["talent_specname"]); end
          cat:AddLine(cols)
        end
      end
    end

    cat = Tablet:AddCategory('columns', 3)
    cat:AddLine(
    'text', l["Color Coding"],
    'text2', color_redgrayed..l["Instance has ID"]..yellow.." / "..color_greengrayed..l["Instance unvisited"]..yellow.." / "..color_yellowgrayed..l["No better Gear available"]
    )

    
    cat = Tablet:AddCategory('columns', 3)
    cat:AddLine(
    'text', "Left Mouse Click",
    'justify', "LEFT",
    'text2', l["Settings"],
    'func', function()
      self:ToggleConfig()
    end)

    cat:AddLine(
    'text', "ALT + Left Mouse Click",
    'justify', "LEFT",
    'text2', l["Apply"],
    'func', function()
      self:CreateRaidApplyGUI() 
    end)

    cat:AddLine(
    'text', "SHIFT + Left Mouse Click",
    'justify', "LEFT",
    'text2', l["ToggleTalents"],
    'func', function()
      self:ToggleTalents()
    end)

    cat:AddLine(
    'text', "CTRL + Left Mouse Click",
    'justify', "LEFT",
    'text2', "Raid Search GUI",
    'func', function()
      self:CreateRaidSearchGUI()
     end)
   
    cat:AddLine(
    'text', "Left Mouse Click on Character",
    'justify', "LEFT",
    'text2', l["Opens Whisper target input to apply for a raid/group"]
  )
  else
    cat = Tablet:AddCategory('columns', 1)
    cat:AddLine(
    'text', "Disabled during combat",
    'justify', "LEFT"
    )
  end
end

function AstronaX:create_tooltip_col(cols, tooltip_setting, tooltip_val)
  if tooltip_setting == 1 then
    cols['text'..(GetArraySize(cols)+1)] = tooltip_val
  end 
end

function AstronaX:CreateRaidApplyGUI( class, gearscore, talent_specname )
  if class == nil then class = AstronaXDB[player]["class"] end
  if gearscore == nil then gearscore = AstronaXDB[player]["gearscore"] end
  if talent_specname == nil then talent_specname = AstronaXDB[player]["talent_specname"] end
  
  if isApplicationOpen == false and class ~= nil then
    isApplicationOpen = true
    
    class = FirstCharUpper(class)
    gearscore = string.format('%.1f', math.floor( (gearscore /1000 * 10^1) + 0.5) / (10^1)).."k"
    for k, v in pairs(short_spec_names) do
      if k == class.." "..talent_specname then
        talent_specname = v
      end
    end
    
    local AceGUI = LibStub("AceGUI-3.0")
    local frame = AceGUI:Create("Frame")
    frame:SetTitle(l["Whisper Spec + GS"])
    frame.statustext:GetParent():Hide()
    frame:SetCallback("OnClose",
      function()
        isApplicationOpen = false
        AceGUI:Release(frame)
      end)
    frame:SetLayout("Flow")
    frame:SetWidth(145)
    frame:SetHeight(250)
    
    local dropdown_need = AceGUI:Create("Dropdown")
    dropdown_need:SetLabel(l["Select need:"])
    dropdown_need:SetWidth(100)
    dropdown_need:SetList({
      ["need PvE"] = "PvE",
      ["need PvP"] = "PvP",
      ["No Need"] = "NoNeed",
      [""] = ""
    })
    frame:AddChild(dropdown_need)
    dropdown_need:SetValue("need PvE")
    
    local dropdown_names = AceGUI:Create("Dropdown")
    dropdown_names:SetLabel(l["Whisper Target:"])
    dropdown_names:SetWidth(100)
    dropdown_names:SetList({})
    frame:AddChild(dropdown_names)
    
    local biggest_value = ""
    local biggest_key = ""
    for k,v in loop_table_sorted(world_player_list) do -- sorts by v = Value
      if biggest_key == "" or biggest_value < v then
        biggest_value = v
        biggest_key = k
      end
      dropdown_names:AddItem(k, k)
    end
    if biggest_key == "" then 
      biggest_key = player
    end
    dropdown_names:AddItem(player, player)
    dropdown_names:SetValue(biggest_key)


    local editbox = AceGUI:Create("EditBox")
    editbox:SetLabel(l["Comment:"])
    editbox:SetWidth(100)
    editbox:DisableButton(true)
    frame:AddChild(editbox)

    local button = AceGUI:Create("Button")
    button:SetText(l["Apply"])
    button:SetWidth(100)
    button:SetCallback("OnClick", 
      function()
        local comment = editbox:GetText()
        local need = dropdown_need:GetValue()
        local target = dropdown_names:GetValue()
        local msg = l["%s %s with %sgs"]:format(talent_specname, class, gearscore)
        
        if target ~= nil and target ~= "" then
          if need ~= nil and need ~= "" then
            msg = msg.." "..need
          end
          if comment ~= nil and comment ~= "" then
            msg = msg.." "..comment
          end
          SendChatMessage(msg, "WHISPER" ,COMMON ,target); 
          isApplicationOpen = false
          AceGUI:Release(frame)
        end
      end)
    frame:AddChild(button)
  end
end

function AstronaX:SetDBMTimer()
  if isApplicationOpen == false then
    isApplicationOpen = true
    
    local AceGUI = LibStub("AceGUI-3.0")
    local frame = AceGUI:Create("Frame")
    frame:SetTitle(l["SetDBMTimer"])
    frame.statustext:GetParent():Hide()
    frame:SetCallback("OnClose",
      function()
        isApplicationOpen = false
        AceGUI:Release(frame)
      end)
    frame:SetLayout("Flow")
    frame:SetWidth(280)
    frame:SetHeight(145)

    local slider_time = AceGUI:Create("Slider")
    slider_time:SetLabel("sec")
    slider_time:SetSliderValues(0, 60, 5)
    slider_time:SetValue(0)
    slider_time:SetWidth(300)
    slider_time:SetValue(15)
    
    local button_pause = AceGUI:Create("Button")
    button_pause:SetText(l["Pause"])
    button_pause:SetWidth(120)
    button_pause:SetCallback("OnClick", 
      function()
        RunSlashCmd("/dbm break "..slider_time:GetValue())
      end)

    local button_pull = AceGUI:Create("Button")
    button_pull:SetText(l["Pull"])
    button_pull:SetWidth(120)
    button_pull:SetCallback("OnClick", 
      function()
        RunSlashCmd("/dbm pull "..slider_time:GetValue())
      end)

    local button_readycheck = AceGUI:Create("Button")
    button_readycheck:SetText(l["Readycheck"])
    button_readycheck:SetWidth(120)
    button_readycheck:SetCallback("OnClick", 
      function()
        RunSlashCmd("/readycheck")
      end)

    frame:AddChild(slider_time)
    frame:AddChild(button_pause)
    frame:AddChild(button_pull)
    frame:AddChild(button_readycheck)
  end
end

function AstronaX:CreateRaidSearchGUI() 
  if isApplicationOpen == false then
    isApplicationOpen = true
    
    local AceGUI = LibStub("AceGUI-3.0")
    local scrollframe = AceGUI:Create("ScrollFrame")
    local frame = AceGUI:Create("Frame")
    frame:SetTitle(l["Raid Member Search"])
    frame.statustext:GetParent():Hide()
    frame:SetLayout("Flow")
    frame:SetWidth(260)
    frame:SetHeight(375)
    frame:SetCallback("OnClose",
      function()
        isApplicationOpen = false
        AceGUI:Release(frame)
      end)
    local editbox = AceGUI:Create("MultiLineEditBox")
    editbox:SetLabel(l["Requirements and Requests:"])
    editbox:SetText("/w me GS+Spec")
    editbox:SetNumLines(1)  -- Set the number of lines to be displayed in the editbox.
    editbox:SetMaxLetters(256)  -- Set the maximum number of letters that can be entered (0 for unlimited).
    editbox:DisableButton(true) -- Disable the "Okay" Button
    
    local slider_tanks_max = 5
    local slider_heals_max = 5
    local slider_dds_max = 19
    local slider_meles_max = 19
    local slider_ranges_max = 19
     
    local slider_tanks = AceGUI:Create("Slider")
    slider_tanks:SetLabel("Tanks")
    slider_tanks:SetSliderValues(0, slider_tanks_max, 1)
    slider_tanks:SetValue(0)
    
    local slider_heals = AceGUI:Create("Slider")
    slider_heals:SetLabel("Heals")
    slider_heals:SetSliderValues(0, slider_heals_max, 1)
    slider_heals:SetValue(0)
    
    local slider_meles = AceGUI:Create("Slider")
    slider_meles:SetLabel("Meles")
    slider_meles:SetSliderValues(0, slider_meles_max, 1)
    slider_meles:SetValue(0)
    
    local slider_ranges = AceGUI:Create("Slider")
    slider_ranges:SetLabel("Ranges")
    slider_ranges:SetSliderValues(0, slider_ranges_max, 1)
    slider_ranges:SetValue(0)
    
    local dropdown_raid = AceGUI:Create("Dropdown")
    dropdown_raid:SetLabel("Raid:")
    dropdown_raid:SetWidth(125)
    dropdown_raid:SetList({
      ["AK10"] = "AK10",
      ["AK25"] = "AK25",
      ["Weekly"] = "Weekly",
      ["Naxxramas10"] = "Naxxramas10",
      ["Naxxramas25"] = "Naxxramas25",
      ["Obsi10"] = "Obsi10",
      ["Obsi25"] = "Obsi25",
      ["Ulduar10"] = "Ulduar10",
      ["Ulduar25"] = "Ulduar25",
      ["Onyxia10"] = "Onyxia10",
      ["Onyxia25"] = "Onyxia25",
      ["PDK10"] = "PDK10",
      ["PDK25"] = "PDK25",
      ["PdoK10"] = "PdoK10",
      ["PdoK25"] = "PdoK25",
      ["ICC10"] = "ICC10",
      ["ICC25"] = "ICC25",
      ["Rubi10"] = "Rubi10",
      ["Rubi25"] = "Rubi25"
    })
    dropdown_raid:SetCallback("OnValueChanged", function() 
      if string.sub( dropdown_raid:GetValue(),string.len(dropdown_raid:GetValue())-1,string.len(dropdown_raid:GetValue()) ) == "25" then
        slider_tanks:SetValue(2)
        slider_heals:SetValue(5)
        slider_meles:SetValue(8)
        slider_ranges:SetValue(10)
    else
        slider_tanks:SetValue(2)
        slider_heals:SetValue(2)
        slider_meles:SetValue(3)
        slider_ranges:SetValue(3)
      end
    end)
    dropdown_raid:SetValue("AK10")
    slider_tanks:SetValue(2)
    slider_heals:SetValue(2)
    slider_meles:SetValue(3)
    slider_ranges:SetValue(3)
    -------------------------------------------------------------------------------------------------------------------
    local checkbox_tank_dk = AceGUI:Create("CheckBox")
    checkbox_tank_dk:SetLabel("Deathknight Blut")
    checkbox_tank_dk:SetImage("Interface\\Icons\\Spell_deathknight_bloodpresence.blp")
    checkbox_tank_dk:SetCallback("OnValueChanged", function() if checkbox_tank_dk:GetValue() and slider_tanks:GetValue() == 0 then slider_tanks:SetValue(1); end end) 
    
    local checkbox_tank_druid = AceGUI:Create("CheckBox")
    checkbox_tank_druid:SetLabel("Druid Wilder Kampf")
    checkbox_tank_druid:SetImage("Interface\\Icons\\Ability_Racial_BearForm.blp")
    checkbox_tank_druid:SetCallback("OnValueChanged", function() if checkbox_tank_druid:GetValue() and slider_tanks:GetValue() == 0 then slider_tanks:SetValue(1); end end) 
    
    local checkbox_tank_paladin = AceGUI:Create("CheckBox")
    checkbox_tank_paladin:SetLabel("Paladin Schutz")
    checkbox_tank_paladin:SetImage("Interface\\Icons\\spell_holy_devotionaura.blp")
    checkbox_tank_paladin:SetCallback("OnValueChanged", function() if checkbox_tank_paladin:GetValue() and slider_tanks:GetValue() == 0 then slider_tanks:SetValue(1); end end) 
      
    local checkbox_tank_warrior = AceGUI:Create("CheckBox")
    checkbox_tank_warrior:SetLabel("Warrior Schutz")
    checkbox_tank_warrior:SetImage("Interface\\Icons\\ability_warrior_defensivestance.blp") 
    checkbox_tank_warrior:SetCallback("OnValueChanged", function() if checkbox_tank_warrior:GetValue() and slider_tanks:GetValue() == 0 then slider_tanks:SetValue(1); end end) 
    ------------------------------------------------------------------------------------------
    local checkbox_heal_druid = AceGUI:Create("CheckBox")
    checkbox_heal_druid:SetLabel(short_spec_names["Druid Wiederherst."])
    checkbox_heal_druid:SetImage(spec_icons["Druid Wiederherst."])
    checkbox_heal_druid:SetCallback("OnValueChanged", function() if checkbox_heal_druid:GetValue() and slider_heals:GetValue() == 0 then slider_heals:SetValue(1); end end) 
    
    local checkbox_heal_paladin = AceGUI:Create("CheckBox")
    checkbox_heal_paladin:SetLabel(short_spec_names["Paladin Heilig"])
    checkbox_heal_paladin:SetImage(spec_icons["Paladin Heilig"])
    checkbox_heal_paladin:SetCallback("OnValueChanged", function() if checkbox_heal_paladin:GetValue() and slider_heals:GetValue() == 0 then slider_heals:SetValue(1); end end)
    
    local checkbox_heal_diszipriest = AceGUI:Create("CheckBox")
    checkbox_heal_diszipriest:SetLabel(short_spec_names["Priest Disziplin"])
    checkbox_heal_diszipriest:SetImage(spec_icons["Priest Disziplin"])
    checkbox_heal_diszipriest:SetCallback("OnValueChanged", function() if checkbox_heal_diszipriest:GetValue() and slider_heals:GetValue() == 0 then slider_heals:SetValue(1); end end)
    
    local checkbox_heal_holypriest = AceGUI:Create("CheckBox")
    checkbox_heal_holypriest:SetLabel(short_spec_names["Priest Heilig"])
    checkbox_heal_holypriest:SetImage(spec_icons["Priest Heilig"])
    checkbox_heal_holypriest:SetCallback("OnValueChanged", function() if checkbox_heal_holypriest:GetValue() and slider_heals:GetValue() == 0 then slider_heals:SetValue(1); end end)
    
    local checkbox_heal_shaman = AceGUI:Create("CheckBox")
    checkbox_heal_shaman:SetLabel(short_spec_names["Shaman Wiederherst."])
    checkbox_heal_shaman:SetImage(spec_icons["Shaman Wiederherst."])
    checkbox_heal_shaman:SetCallback("OnValueChanged", function() if checkbox_heal_shaman:GetValue() and slider_heals:GetValue() == 0 then slider_heals:SetValue(1); end end)
    ------------------------------------------------------------------------------------------
    local checkbox_mele_druid = AceGUI:Create("CheckBox")
    checkbox_mele_druid:SetLabel(short_spec_names["Druid Wilder Kampf"])
    checkbox_mele_druid:SetImage(spec_icons["Druid Wilder Kampf"])
    checkbox_mele_druid:SetCallback("OnValueChanged", function() if checkbox_mele_druid:GetValue() and slider_meles:GetValue() == 0 then slider_meles:SetValue(1); end end)
    
    local checkbox_mele_mrogue = AceGUI:Create("CheckBox")
    checkbox_mele_mrogue:SetLabel(short_spec_names["Rogue Meucheln"])
    checkbox_mele_mrogue:SetImage(spec_icons["Rogue Meucheln"])
    checkbox_mele_mrogue:SetCallback("OnValueChanged", function() if checkbox_mele_mrogue:GetValue() and slider_meles:GetValue() == 0 then slider_meles:SetValue(1); end end)
    
    local checkbox_mele_crogue = AceGUI:Create("CheckBox")
    checkbox_mele_crogue:SetLabel(short_spec_names["Rogue Kampf"])
    checkbox_mele_crogue:SetImage(spec_icons["Rogue Kampf"])
    checkbox_mele_crogue:SetCallback("OnValueChanged", function() if checkbox_mele_crogue:GetValue() and slider_meles:GetValue() == 0 then slider_meles:SetValue(1); end end)
    
    local checkbox_mele_awarrior = AceGUI:Create("CheckBox")
    checkbox_mele_awarrior:SetLabel(short_spec_names["Warrior Waffen"])
    checkbox_mele_awarrior:SetImage(spec_icons["Warrior Waffen"])
    checkbox_mele_awarrior:SetCallback("OnValueChanged", function() if checkbox_mele_awarrior:GetValue() and slider_meles:GetValue() == 0 then slider_meles:SetValue(1); end end)
    
    local checkbox_mele_fwarrior = AceGUI:Create("CheckBox")
    checkbox_mele_fwarrior:SetLabel(short_spec_names["Warrior Furor"])
    checkbox_mele_fwarrior:SetImage(spec_icons["Warrior Furor"])
    checkbox_mele_fwarrior:SetCallback("OnValueChanged", function() if checkbox_mele_fwarrior:GetValue() and slider_meles:GetValue() == 0 then slider_meles:SetValue(1); end end)
    
    local checkbox_mele_paladin = AceGUI:Create("CheckBox")
    checkbox_mele_paladin:SetLabel(short_spec_names["Paladin Vergeltung"])
    checkbox_mele_paladin:SetImage(spec_icons["Paladin Vergeltung"])
    checkbox_mele_paladin:SetCallback("OnValueChanged", function() if checkbox_mele_paladin:GetValue() and slider_meles:GetValue() == 0 then slider_meles:SetValue(1); end end)
    
    local checkbox_mele_shaman = AceGUI:Create("CheckBox")
    checkbox_mele_shaman:SetLabel(short_spec_names["Shaman Verstärk."])
    checkbox_mele_shaman:SetImage(spec_icons["Shaman Verstärk."])
    checkbox_mele_shaman:SetCallback("OnValueChanged", function() if checkbox_mele_shaman:GetValue() and slider_meles:GetValue() == 0 then slider_meles:SetValue(1); end end)
    
    local checkbox_mele_bdk = AceGUI:Create("CheckBox")
    checkbox_mele_bdk:SetLabel(short_spec_names["Deathknight Blut"])
    checkbox_mele_bdk:SetImage(spec_icons["Deathknight Blut"])
    checkbox_mele_bdk:SetCallback("OnValueChanged", function() if checkbox_mele_bdk:GetValue() and slider_meles:GetValue() == 0 then slider_meles:SetValue(1); end end)
    
    local checkbox_mele_fdk = AceGUI:Create("CheckBox")
    checkbox_mele_fdk:SetLabel(short_spec_names["Deathknight Frost"])
    checkbox_mele_fdk:SetImage(spec_icons["Deathknight Frost"])
    checkbox_mele_fdk:SetCallback("OnValueChanged", function() if checkbox_mele_fdk:GetValue() and slider_meles:GetValue() == 0 then slider_meles:SetValue(1); end end)

    local checkbox_mele_udk = AceGUI:Create("CheckBox")
    checkbox_mele_udk:SetLabel(short_spec_names["Deathknight Unheilig"])
    checkbox_mele_udk:SetImage(spec_icons["Deathknight Unheilig"])    
    checkbox_mele_udk:SetCallback("OnValueChanged", function() if checkbox_mele_udk:GetValue() and slider_meles:GetValue() == 0 then slider_meles:SetValue(1); end end) 
    ------------------------------------------------------------------------------------------
    local checkbox_range_druid = AceGUI:Create("CheckBox")
    checkbox_range_druid:SetLabel(short_spec_names["Druid Gleichgewicht"])
    checkbox_range_druid:SetImage(spec_icons["Druid Gleichgewicht"])
    checkbox_range_druid:SetCallback("OnValueChanged", function() if checkbox_range_druid:GetValue() and slider_ranges:GetValue() == 0 then slider_ranges:SetValue(1); end end)
    
    local checkbox_range_fmage = AceGUI:Create("CheckBox")
    checkbox_range_fmage:SetLabel(short_spec_names["Mage Feuer"])
    checkbox_range_fmage:SetImage(spec_icons["Mage Feuer"])
    checkbox_range_fmage:SetCallback("OnValueChanged", function() if checkbox_range_fmage:GetValue() and slider_ranges:GetValue() == 0 then slider_ranges:SetValue(1); end end)
    
    local checkbox_range_amage = AceGUI:Create("CheckBox")
    checkbox_range_amage:SetLabel(short_spec_names["Mage Arkan"])
    checkbox_range_amage:SetImage(spec_icons["Mage Arkan"])
    checkbox_range_amage:SetCallback("OnValueChanged", function() if checkbox_range_amage:GetValue() and slider_ranges:GetValue() == 0 then slider_ranges:SetValue(1); end end)
    
    local checkbox_range_cmage = AceGUI:Create("CheckBox")
    checkbox_range_cmage:SetLabel(short_spec_names["Mage Frost"])
    checkbox_range_cmage:SetImage(spec_icons["Mage Frost"])
    checkbox_range_cmage:SetCallback("OnValueChanged", function() if checkbox_range_cmage:GetValue() and slider_ranges:GetValue() == 0 then slider_ranges:SetValue(1); end end)
    
    local checkbox_range_dwarlock = AceGUI:Create("CheckBox")
    checkbox_range_dwarlock:SetLabel(short_spec_names["Warlock Dämonologie"])
    checkbox_range_dwarlock:SetImage(spec_icons["Warlock Dämonologie"])
    checkbox_range_dwarlock:SetCallback("OnValueChanged", function() if checkbox_range_dwarlock:GetValue() and slider_ranges:GetValue() == 0 then slider_ranges:SetValue(1); end end)
    
    local checkbox_range_awarlock = AceGUI:Create("CheckBox")
    checkbox_range_awarlock:SetLabel(short_spec_names["Warlock Gebrechen"])
    checkbox_range_awarlock:SetImage(spec_icons["Warlock Gebrechen"])
    checkbox_range_awarlock:SetCallback("OnValueChanged", function() if checkbox_range_awarlock:GetValue() and slider_ranges:GetValue() == 0 then slider_ranges:SetValue(1); end end)
    
    local checkbox_range_xwarlock = AceGUI:Create("CheckBox")
    checkbox_range_xwarlock:SetLabel(short_spec_names["Warlock Zerstörung"])
    checkbox_range_xwarlock:SetImage(spec_icons["Warlock Zerstörung"])
    checkbox_range_xwarlock:SetCallback("OnValueChanged", function() if checkbox_range_xwarlock:GetValue() and slider_ranges:GetValue() == 0 then slider_ranges:SetValue(1); end end)
    
    local checkbox_range_shunter = AceGUI:Create("CheckBox")
    checkbox_range_shunter:SetLabel(short_spec_names["Hunter Überleben"])
    checkbox_range_shunter:SetImage(spec_icons["Hunter Überleben"])
    checkbox_range_shunter:SetCallback("OnValueChanged", function() if checkbox_range_shunter:GetValue() and slider_ranges:GetValue() == 0 then slider_ranges:SetValue(1); end end)
    
    local checkbox_range_bhunter = AceGUI:Create("CheckBox")
    checkbox_range_bhunter:SetLabel(short_spec_names["Hunter Tierherrschaft"])
    checkbox_range_bhunter:SetImage(spec_icons["Hunter Tierherrschaft"])
    checkbox_range_bhunter:SetCallback("OnValueChanged", function() if checkbox_range_bhunter:GetValue() and slider_ranges:GetValue() == 0 then slider_ranges:SetValue(1); end end)
    
    local checkbox_range_mhunter = AceGUI:Create("CheckBox")
    checkbox_range_mhunter:SetLabel(short_spec_names["Hunter Treffsicherheit"])
    checkbox_range_mhunter:SetImage(spec_icons["Hunter Treffsicherheit"])
    checkbox_range_mhunter:SetCallback("OnValueChanged", function() if checkbox_range_mhunter:GetValue() and slider_ranges:GetValue() == 0 then slider_ranges:SetValue(1); end end)

    local checkbox_range_eshaman = AceGUI:Create("CheckBox")
    checkbox_range_eshaman:SetLabel(short_spec_names["Shaman Elementar"])
    checkbox_range_eshaman:SetImage(spec_icons["Shaman Elementar"])
    checkbox_range_eshaman:SetCallback("OnValueChanged", function() if checkbox_range_eshaman:GetValue() and slider_ranges:GetValue() == 0 then slider_ranges:SetValue(1); end end)
    
    local checkbox_range_spriest = AceGUI:Create("CheckBox")
    checkbox_range_spriest:SetLabel(short_spec_names["Priest Schatten"])
    checkbox_range_spriest:SetImage(spec_icons["Priest Schatten"])
    checkbox_range_spriest:SetCallback("OnValueChanged", function() if checkbox_range_spriest:GetValue() and slider_ranges:GetValue() == 0 then slider_ranges:SetValue(1); end end)
    
    --SetValue(flag) - Set the state of the checkbox
    --GetValue() - Get the state of the checkbox
    --ToggleChecked() - Toggle the value
    --OnValueChanged(value) - Fires when the state of the checkbox changes.
    --OnEnter() - Fires when the cursor enters the widget.
    --OnLeave() - Fires when the cursor leaves the widget. 
    
    local button = AceGUI:Create("Button")
    button:SetText(l["Search"])
    button:SetWidth(100)
    button:SetCallback("OnClick", 
      function()
        local raid = dropdown_raid:GetValue()
        local tt = slider_tanks:GetValue()
        local hh = slider_heals:GetValue()
        local mdd = slider_meles:GetValue()
        local rdd = slider_ranges:GetValue()
        
        if raid == "Weekly" then 
          for index=1, GetNumQuestLogEntries() do
            --local questheader = select(4,GetQuestLogTitle(index))
            --local questtitle = select(1,GetQuestLogTitle(index))
            local questID = select(9,GetQuestLogTitle(index))
            
            for q=24579,24590 do
              if questID == q then
                raid = raid.." "..GetQuestLink(index)
              end
            end
          end
        end
        
        local msg_tt = ""
        if tt and tonumber(tt) > 0 then
          msg_tt = " "..tt.." Tank "
          if tonumber(tt) > 1 then
            msg_tt = " "..tt.." Tanks "
          end
          
          if checkbox_tank_dk:GetValue() or
            checkbox_tank_druid:GetValue() or 
            checkbox_tank_paladin:GetValue() or 
            checkbox_tank_warrior:GetValue()
          then
            msg_tt = msg_tt.."( "
            if checkbox_tank_dk:GetValue() then msg_tt = msg_tt..short_spec_names["Deathknight Blut"].." " end
            if checkbox_tank_druid:GetValue() then msg_tt = msg_tt..short_spec_names["Druid Wilder Kampf"].." " end
            if checkbox_tank_paladin:GetValue() then msg_tt = msg_tt..short_spec_names["Paladin Schutz"].." " end
            if checkbox_tank_warrior:GetValue() then msg_tt = msg_tt..short_spec_names["Warrior Schutz"].." " end
            msg_tt = msg_tt..")"
          end
        end
        
        local msg_hh = ""
        if hh and tonumber(hh) > 0 then
          msg_hh = " "..hh.." Heal "
          if tonumber(hh) > 1 then
            msg_hh = " "..hh.." Heals "
          end
          
          if
            checkbox_heal_diszipriest:GetValue() or
            checkbox_heal_druid:GetValue() or 
            checkbox_heal_holypriest:GetValue() or 
            checkbox_heal_paladin:GetValue() or 
            checkbox_heal_shaman:GetValue() 
          then
            msg_hh = msg_hh.."( "
            if checkbox_heal_diszipriest:GetValue() then msg_hh = msg_hh..short_spec_names["Priest Disziplin"].." " end
            if checkbox_heal_holypriest:GetValue() then msg_hh = msg_hh..short_spec_names["Priest Heilig"].." " end
            if checkbox_heal_druid:GetValue() then msg_hh = msg_hh..short_spec_names["Druid Wiederherst."].." " end
            if checkbox_heal_paladin:GetValue() then msg_hh = msg_hh..short_spec_names["Paladin Heilig"].." " end
            if checkbox_heal_shaman:GetValue() then msg_hh = msg_hh..short_spec_names["Shaman Wiederherst."].." " end            
            msg_hh = msg_hh..")"
          end
        end
        
        local msg_mdd = ""
        if mdd and tonumber(mdd) > 0 then
          msg_mdd = " "..mdd.." Mele "
          if tonumber(mdd) > 1 then
            msg_mdd = " "..mdd.." Meles "
          end
          
          if
            checkbox_mele_awarrior:GetValue() or
            checkbox_mele_bdk:GetValue() or
            checkbox_mele_crogue:GetValue() or
            checkbox_mele_druid:GetValue() or
            checkbox_mele_fdk:GetValue() or
            checkbox_mele_fwarrior:GetValue() or
            checkbox_mele_mrogue:GetValue() or
            checkbox_mele_paladin:GetValue() or
            checkbox_mele_shaman:GetValue() or
            checkbox_mele_udk:GetValue()
          then
            msg_mdd = msg_mdd.."( "
            if checkbox_mele_awarrior:GetValue() then msg_mdd = msg_mdd..short_spec_names["Warrior Waffen"].." " end
            if checkbox_mele_bdk:GetValue() then msg_mdd = msg_mdd..short_spec_names["Deathknight Blut"].." " end
            if checkbox_mele_crogue:GetValue() then msg_mdd = msg_mdd..short_spec_names["Rogue Kampf"].." " end
            if checkbox_mele_druid:GetValue() then msg_mdd = msg_mdd..short_spec_names["Druid Wilder Kampf"].." " end
            if checkbox_mele_fdk:GetValue() then msg_mdd = msg_mdd..short_spec_names["Deathknight Frost"].." " end
            if checkbox_mele_fwarrior:GetValue() then msg_mdd = msg_mdd..short_spec_names["Warrior Furor"].." " end
            if checkbox_mele_mrogue:GetValue() then msg_mdd = msg_mdd..short_spec_names["Rogue Meucheln"].." " end
            if checkbox_mele_paladin:GetValue() then msg_mdd = msg_mdd..short_spec_names["Paladin Vergeltung"].." " end
            if checkbox_mele_shaman:GetValue() then msg_mdd = msg_mdd..short_spec_names["Shaman Verstärk."].." " end
            if checkbox_mele_udk:GetValue() then msg_mdd = msg_mdd..short_spec_names["Deathknight Unheilig"].." " end
            msg_mdd = msg_mdd..")"
          end
        end
        
        local msg_rdd = ""
        if rdd and tonumber(rdd) > 0 then
          msg_rdd = " "..rdd.." Range "
          if tonumber(rdd) > 1 then
            msg_rdd = " "..rdd.." Ranges "
          end
          
          if
            checkbox_range_amage:GetValue() or
            checkbox_range_awarlock:GetValue() or
            checkbox_range_bhunter:GetValue() or
            checkbox_range_cmage:GetValue() or
            checkbox_range_druid:GetValue() or
            checkbox_range_dwarlock:GetValue() or
            checkbox_range_eshaman:GetValue() or
            checkbox_range_fmage:GetValue() or
            checkbox_range_mhunter:GetValue() or
            checkbox_range_shunter:GetValue() or
            checkbox_range_spriest:GetValue() or
            checkbox_range_xwarlock:GetValue()
          then
            msg_rdd = msg_rdd.."( "
            if checkbox_range_amage:GetValue() then msg_rdd = msg_rdd..short_spec_names["Mage Arkan"].." " end
            if checkbox_range_awarlock:GetValue() then msg_rdd = msg_rdd..short_spec_names["Warlock Gebrechen"].." " end
            if checkbox_range_bhunter:GetValue() then msg_rdd = msg_rdd..short_spec_names["Hunter Tierherrschaft"].." " end
            if checkbox_range_cmage:GetValue() then msg_rdd = msg_rdd..short_spec_names["Mage Frost"].." " end
            if checkbox_range_druid:GetValue() then msg_rdd = msg_rdd..short_spec_names["Druid Gleichgewicht"].." " end
            if checkbox_range_dwarlock:GetValue() then msg_rdd = msg_rdd..short_spec_names["Warlock Dämonologie"].." " end
            if checkbox_range_eshaman:GetValue() then msg_rdd = msg_rdd..short_spec_names["Shaman Elementar"].." " end
            if checkbox_range_fmage:GetValue() then msg_rdd = msg_rdd..short_spec_names["Mage Feuer"].." " end
            if checkbox_range_mhunter:GetValue() then msg_rdd = msg_rdd..short_spec_names["Hunter Treffsicherheit"].." " end
            if checkbox_range_shunter:GetValue() then msg_rdd = msg_rdd..short_spec_names["Hunter Überleben"].." " end
            if checkbox_range_spriest:GetValue() then msg_rdd = msg_rdd..short_spec_names["Priest Schatten"].." " end
            if checkbox_range_xwarlock:GetValue() then msg_rdd = msg_rdd..short_spec_names["Warlock Zerstörung"].." " end
            msg_rdd = msg_rdd..")"
          end
        end
        
        local comment = editbox:GetText()
        if comment == nil then
          comment = ""
        end
        
        if msg_tt ~= "" or msg_hh ~= "" or msg_mdd ~= "" or msg_rdd ~= "" then
          local msg = l["For %s we are looking for %s%s%s%s %s"]:format(raid, msg_tt, msg_hh, msg_mdd, msg_rdd, comment)
          local chanList = { GetChannelList() }
          
          for i=1, #chanList, 2 do
            if chanList[i+1] == "World" or chanList[i+1] == "world" then
              SendChatMessage(msg, "CHANNEL" ,COMMON ,chanList[i]); 
              --SendChatMessage(msg, "WHISPER" ,COMMON , player); 
            end
          end
        else
          print(red.."Nothing to search")
        end
      end)
    
    frame:AddChild(dropdown_raid)
    frame:AddChild(button)
    frame:AddChild(editbox)
    
    scrollframe:AddChild(slider_tanks)
    scrollframe:AddChild(slider_heals)
    scrollframe:AddChild(slider_meles)
    scrollframe:AddChild(slider_ranges)
    
    local heading_tanks = AceGUI:Create("InteractiveLabel")
    heading_tanks:SetText("Tanks")
    local heading_heals = AceGUI:Create("InteractiveLabel")
    heading_heals:SetText("Heals")
    local heading_meles = AceGUI:Create("InteractiveLabel")
    heading_meles:SetText("Meles")
    local heading_ranges = AceGUI:Create("InteractiveLabel")
    heading_ranges:SetText("Ranges")
    
    scrollframe:AddChild(heading_tanks)
    scrollframe:AddChild(checkbox_tank_druid)
    scrollframe:AddChild(checkbox_tank_dk)
    scrollframe:AddChild(checkbox_tank_paladin)
    scrollframe:AddChild(checkbox_tank_warrior)

    scrollframe:AddChild(heading_heals)
    scrollframe:AddChild(checkbox_heal_druid)
    scrollframe:AddChild(checkbox_heal_diszipriest)
    scrollframe:AddChild(checkbox_heal_holypriest)
    scrollframe:AddChild(checkbox_heal_paladin)
    scrollframe:AddChild(checkbox_heal_shaman)
    
    scrollframe:AddChild(heading_meles)
    scrollframe:AddChild(checkbox_mele_druid)
    scrollframe:AddChild(checkbox_mele_bdk)
    scrollframe:AddChild(checkbox_mele_fdk)
    scrollframe:AddChild(checkbox_mele_udk)
    scrollframe:AddChild(checkbox_mele_paladin)
    scrollframe:AddChild(checkbox_mele_mrogue)
    scrollframe:AddChild(checkbox_mele_shaman)
    scrollframe:AddChild(checkbox_mele_crogue)
    scrollframe:AddChild(checkbox_mele_awarrior)
    scrollframe:AddChild(checkbox_mele_fwarrior)
    
    scrollframe:AddChild(heading_ranges)
    scrollframe:AddChild(checkbox_range_druid)
    scrollframe:AddChild(checkbox_range_shunter)
    scrollframe:AddChild(checkbox_range_mhunter)
    scrollframe:AddChild(checkbox_range_bhunter)
    scrollframe:AddChild(checkbox_range_fmage)
    scrollframe:AddChild(checkbox_range_amage)
    scrollframe:AddChild(checkbox_range_cmage)
    scrollframe:AddChild(checkbox_range_spriest)
    scrollframe:AddChild(checkbox_range_eshaman)
    scrollframe:AddChild(checkbox_range_dwarlock)
    scrollframe:AddChild(checkbox_range_awarlock)
    scrollframe:AddChild(checkbox_range_xwarlock)
    
    scrollcontainer = AceGUI:Create("SimpleGroup") -- "InlineGroup" is also good
    scrollcontainer:SetFullWidth(true)
    scrollcontainer:SetFullHeight(true) -- probably?
    scrollcontainer:SetLayout("Fill") -- important!
    scrollcontainer:AddChild(scrollframe)
    frame:AddChild(scrollcontainer)
  end
end

--------------------------------------------
-- alt click item trading
local bag, slot
local orig1 = ContainerFrameItemButton_OnModifiedClick
ContainerFrameItemButton_OnModifiedClick = function(...)
	local self, button;
	if (select(4, GetBuildInfo()) >= 30000) then self, button = ... else button = ... end
	if button == "LeftButton" and IsAltKeyDown() and not CursorHasItem() then
		bag, slot = this:GetParent():GetID(), this:GetID()
		if TradeFrame:IsVisible() then
			for i=1,6 do
				if not GetTradePlayerItemLink(i) then
					PickupContainerItem(bag, slot)
					ClickTradeButton(i)
					bag, slot = nil, nil
					return
				end
			end
		elseif not CursorHasItem() and UnitExists("target") and UnitIsFriend("player", "target") and UnitIsPlayer("target") and CheckInteractDistance("target", 2) then
			target_unit = UnitName("target")
			InitiateTrade("target")
			return
		end
	end
	orig1(...)
end

local function posthook(...)
  if target_unit and not CursorHasItem() and UnitName("target") == target_unit then
    PickupContainerItem(bag, slot)
    ClickTradeButton(1)
  end
  target_unit, bag, slot = nil, nil, nil

	return ...
end

local orig2 = TradeFrame:GetScript("OnShow")
TradeFrame:SetScript("OnShow", function(...)
	if orig2 then return posthook(orig2(...))
	else posthook() end
end)
--------------------------------------------