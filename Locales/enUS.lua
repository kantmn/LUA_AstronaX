local l = AceLibrary("AceLocale-2.2"):new("AstronaX")

l:RegisterTranslations("enUS", function() return {
   ["tooltip_chardetails"] = "Toggles the display of the first category showing the character details inside tooltip",
   ["tooltip_instancelocks"] = "Toggles the display of the second category showing the instance lockdowns inside the tooltip",
   ["tooltip_gearscore"] = "Toggles the display of Gearscore Values in Tooltip",
   ["tooltip_repair"] = "Toggles the display of Repairstatus in Tooltip",
   ["tooltip_emblem_264"] = "Toggles the display of Frost Emblems in Tooltip",
   ["tooltip_emblem_232"] = "Toggles the display of Triumph Emblems in Tooltip",
   ["tooltip_emblem_226"] = "Toggles the display of Conquest Emblems in Tooltip",
   ["tooltip_emblem_213"] = "Toggles the display of Valor Emblems in Tooltip",
   ["tooltip_emblem_200"] = "Toggles the display of Heroism Emblems in Tooltip",
   ["tooltip_emblem_1kw"] = "Toggles the display of 1kw Values in Tooltip",
   ["tooltip_honor"] = "Toggles the display of Honor Values in Tooltip",
   ["tooltip_arena"] = "Toggles the display of Arena Values in Tooltip",
   ["tooltip_money"] = "Toggles the display of Gold Values in Tooltip",
   ["tooltip_title"] = "Toggles the display of Title in Tooltip",
   ["tooltip_dailyweekly"] = "Toggles the display of Daily Heroics and Weekly Quest status in tooltip",
   ["tooltip_pvpweekly"] = "Toggles the display of Weekly PVP for Wintergrasp",
   ["tooltip_ak"] = "Toggles the display of Wintergrasp Raid IDs",
   ["tooltip_naxx"] = "Toggles the display of Naxxramas Raid IDs",
   ["tooltip_obsi"] = "Toggles the display of Obis Raid IDs",
   ["tooltip_ulduar"] = "Toggles the display of Ulduar Raid IDs",
   ["tooltip_onyxia"] = "Toggles the display of Onyxia Lair Raid IDs",
   ["tooltip_pdk"] = "Toggles the display of PDC Raid IDs",
   ["tooltip_pdok"] = "Toggles the display of PDoC Raid IDs",
   ["tooltip_icc"] = "Toggles the display of ICC IDs",
   ["tooltip_rubi"] = "Toggles the display of Rubi Raid IDs",
   ["tooltip_help"] = "Toggles the display of this value on the tooltip.",
   ["Settings"] = "Settings",
   ["Currency Frame"] = "Emblem and Currency Frame",
   ["Apply"] = "Apply",
   ["Color Coding"] = "Color Coding",
   ["ToggleTalents"] = "Switch Talenttree",
   ["freeforall"] = "Free for all",
   ["roundrobin"] = "Round Robin",
   ["group"] = "As Group",
   ["needbeforegreed"] = "Need before Greed",
   ["master"] = "Master Looter",
   ["Personal"] = "Personal",
   ["This is the first start up of AstronaX. Thank you for installing."] = "This is the first start up of AstronaX. Thank you for installing.",
   ["This is the first use of AstronaX on this character. Database has been initialized."] = "This is the first use of AstronaX on this character. Database has been initialized.",
   ["Please use %s or %s to display the help, you can enable or disable features as you like."] = "Please use %s or %s to display the help, you can enable or disable features as you like.",
   ["You can also use our GUI to change settings, just go to ESC -> Interface -> Addons -> AstronaX."] = "You can also use our GUI to change settings, just go to ESC -> Interface -> Addons -> AstronaX.",
   ["sec"] = "sec",
   ["min"] = "min",
   ["hour"] = "hour",
   ["not"] = "not",
   ["activ"] = "activ",
   ["inactiv"] = "inactiv",
   ["activated"] = "activated",
   ["deactivated"] = "deactivated",
   ["enabled"] = "enabled",
   ["disabled"] = "disabled",
   ["personally"] = "personally",
   ["by guildbank"] = "by our guildbank",
   ["needed"] = "needed",
   ["greeded"] = "greeded",
   ["dizzed"] = "dizzed",
   ["Roll for"] = "Roll for",
   ["Priorities"] = "Priorities",
   ["Title"] = "Title",
   ["Battle"] = "Battle",
   ["Prefered mount"] = "Prefered mount",
   ["ExperienceStatus: "] = "ExperienceStatus: ",
   ["will manually select"] = "",
   ["Displaying available commands:"] = "Displaying available commands:",
   ["Displaying features with out commands:"] = "Displaying features with out commands:",
   ["bar_help"] = "Toggles the display of this value on the FuBar.",
   ["aifk_help"] = "If someone addresses you with the chosen keyword, you automatically invite that character.",
   ["arol_help"] = "If an item falls that is worse than all of your equipped items, the highest possible die roll is automatically rolled on it, it is automatically disabled in the raid. For unbound items, demand is selected.",
   ["abm_help"] = "You always keep the selected amount on your character, the excess gold is being put in the bank.",
   ["abml_help"] = "You always keep the selected amount on your character, the missing gold will be withdrawn from the bank.",
   ["abmv_help"] = "The desired amount of gold that should always be present on your character.",
   ["aifa_help"] = "If you send others a whispered message containing 'inv' or your gear score (e.g. 4.2k) the invite of the whispered one is automatically accepted.",
   ["aiff_help"] = "Invitations from friends are automatically accepted if you are not already in a group or the Dungeon Browser",
   ["aifg_help"] = "Invitations from guild members are automatically accepted unless you are already in a group or the Dungeon Browser",
   ["aro_help"] = "If your group is not in combat, you will automatically accept resurrections.",
   ["alam_help"] = "At the mailbox, all messages containing items or gold are automatically removed, should the mailbox come to a standstill, click with SHIFT-left-click on the next message.",
   ["are_help"] = "Your equipment will be automatically repaired when you visit an appropriate vendor.",
   ["tis_help"] = "Tracks interupting spells and annouces your own interuptions to say channel.",
   ["aslm_help"] = "The looting method in the raid is automatically set to looter master from a size of 25 men, provided a boss is the target.",
   ["aste_help"] = "When selecting a target, the hunter automatically takes the correct search aspect",
   ["cldr_help"] = "If you select Disenchant when looting, the query is automatically confirmed.",
   ["clgr_help"] = "If you select greed when looting, the query is automatically confirmed.",
   ["iobr_help"] = "Inform about received resurrection in the raid if the raid is still in combat, also report when the resurrection is accepted.",
   ["staui_help"] = "Sell gray trash and unwanted items, the list of items is currently fixed, and includes roles of .... as well as other stuff from instances that you would otherwise sell anyway. When selling, the list of items is listed to check what has been sold.",
   ["tyr_help"] = "Thank your reviver with a whisper message, the message is randomly selected from a list of 10 replies.",
   ["tgham_help"] = "When you come out of combat, the top center of the screen shows how much Mana and Health the group has left on average.",
   ["tlmc_help"] = "It will inform when the looting method changes via sound and text.",
   ["tmrc_help"] = "Observe Mana Recovery Cooldowns",
   ["txp_help"] = "Follow the experience progress",    
   ["twcrs_help"] = "Displays the raid searching requests in a seperate line, and makes it easier to find them.",    
   ["tkww_help"] = "Gives a visual and audio feedback wenn the battle in wintergrasp is ongoing.",
   ["sals_help"] = "Activates Blizzards loot spam message when in group or 10 player raids, but disables it in 25 player raids",
   ["farclip"] = "Set the farclip which is applied when raid group is left.",
   ["farclip_toggle"] = "Toggles the automatic Distance Reduction in Raids.",
   ["farclip_help"] = "Performance optimization for boss fights.",
   ["farclip_toggle_help"] = "Performance optimization for boss fights.",
   ["addon_color"] = "Basecolor of this Addon messages",
   ["addon_highlight"] = "Highlight color of this Addon messages",
   ["bar_timer_1kw_help"] = "Timer for the next Wintergrasp battle",
   ["bar_rs"] = "Display the repair status",
   ["bar_ti"] = "Displays your Specialization Icon",
   ["bar_tp"] = "Displays your Talentpoints",
   ["bar_gs"] = "Gearscore",
   ["bar_fe"] = "Frost Emblems",
   ["bar_te"] = "Triumph Emblems",
   ["bar_he"] = "Heroism Emblems",
   ["bar_og"] = "Own Gold",
   ["bar_gg"] = "Guildbank Gold",
   ["bar_lm"] = "Lootmethod",
   ["bar_ho"] = "Honor",
   ["bar_ho"] = "Arena Points",
   ["bar_1k"] = "Stone Keeper's Shard",
   ["bar_rt"] = "Displays reputation progress on watched fraction",
   ["sals"] = "Activates automatic loop spam messages when in groups < 25 players",
   ["aifk"] = "Automatical Invite from Keyword",
   ["arol"] = "Automatical Roll on loot",
   ["abm"] = "Automatical Balance Money when too high",
   ["abml"] = "Automatical Balance Money when too low",
   ["abmv"] = "Gold ammount",
   ["aifa"] = "Automatical Invites from applications",
   ["aiff"] = "Automatical Invites from Friends",
   ["aifg"] = "Automatical Invites from Guilds",
   ["aro"] = "Automatical revive when outfight",
   ["alam"] = "Automatical loot all mails",
   ["are"] = "Automatical repair equipment",
   ["aslm"] = "Automatical select loot method based on group size",
   ["aste"] = "Automatical set hunter tracking",
   ["cldr"] = "Confirm loot disenchant rolls",
   ["clgr"] = "Cnfirm loot greed rools",
   ["iobr"] = "Inform on battle rezzes in raid ",
   ["tkww"] = "Warns you visually and via sound when Wintergrasp battle is ongoing",
   ["tis"] = "Tracks interupting spells",
   ["staui"] = "Sell trash and unwanted items",
   ["tyr"] = "Thank your reviver with a whisper",
   ["tgham"] = "Track group health and mana when going out of combat",
   ["tlmc"] = "Track loot method changes",
   ["tmrc"] = "Track mana replenishment cooldowns",
   ["txp"] = "Track experience progress", 
   ["twcrs"] = "Track world channel for raids where you have no instance ID", 
   ["was"] = "was",
   ["was %s and was set to %s."] = "was %s and was set to %s.",
   ["How to use function %s?"] = "How to use function %s?",
   ["Current status is %s and keyword is %s."] = "Current status is %s and keyword is %s.",
   ["Current status is %s and goldlimit set to %s."] = "Current status is %s and goldlimit set to %s.",
   ["Paramter invalid, use 0 or 1 to change state, or higher number to set Goldlimit."] = "Paramter invalid, use 0 or 1 to change state, or higher number to set Goldlimit.",
   ["Current status is %s."] = "Current status is %s.",
   ["This will disable the function."] = "This will disable the function.",
   ["This will enable the function."] = "This will enable the function.",
   ["keyword"] = "keyword",
   ["goldlimit"] = "gold ammount",
   ["This will set the invite code to %s."] = "This will set the invite code to %s.",
   ["The function %s is now %s."] = "The function %s is now %s.",
   ["The text for %s is too short, use 3 or more chars."] = "The text for %s is too short, use 3 or more chars.",
   ["This will set gold ammount to keep on your character."] = "This will set gold ammount to keep on your character.",
   ["is now %s and goldlimit was set to %s."] = "is now %s and goldlimit was set to %s.",
   ["spell_Anregen"] = "Innervate",
   ["spell_Hervorrufung"] = "Evocation",
   ["spell_GoettlicheBitte"] = "Divine Plea",
   ["spell_Schattengeist"] = "Shadowfiend",
   ["spell_TotemderManaflut"] = "Mana Tide Totem",
   ["Chat Partner %s is a possible inviter, AutoInvite will accept invites."] = "Chat Partner %s is a possible inviter, AutoInvite will accept invites.",
   ["Repaircosts about %s have been payed %s."] = "Repaircosts about %s have been payed %s.",
   ["%s's battle Rezz accepted"] = "%s's battle Rezz accepted",
   ["%s's battle Rezz received, accepting soon"] = "%s's battle Rezz received, accepting soon",
   ["Currently in combat against >> %s << with %s% remaining."] = "Currently in combat against >> %s << with %s% remaining.",
   ["Selling Junk and unwanted items"] = "Selling Junk and unwanted items.",
   ["stack(s)%s sold for %s."] = "stack(s)%s sold for %s.",
   ["AutoTracking set to %s."] = "AutoTracking set to %s.",
   ["AutoInvite declined, sorry been afk for %s min(s)."] = "AutoInvite declined, sorry been afk for %s min(s).",
   ["AutoInvite declined, already in DB queue."] = "AutoInvite declined, already in DB queue.",
   ["AutoInvite declined, i am no group leader and do not have invite permissions."] = "AutoInvite declined, i am no group leader and do not have invite permissions.",
   ["AutoInvite accepted."] = "AutoInvite accepted.",
   ["Mail from %s contains %sx %s."] = "Mail from %s contains %sx %s.",
   ["Mail contains %s from %s for %s."] = "Mail contains %s from %s for %s.",
   ["Mail by %s regarding %s contains %s."] = "Mail by %s regarding %s contains %s.",
   ["Group Mana"] = "Group Mana",
   ["Group Health"] = "Group Health",
   ["Use %s now"] = "Use %s now",
   ["Loot Method changed to %s."] = "Loot Method changed to %s.",
   ["This character does not yet have dual specialization."] = "This character does not yet have dual specialization.",
   ["Deployed %s to our guildbank."] = "Deployed %s to our guildbank.",
   ["Took %s from our guildbank."] = "Took %s from our guildbank.",
   ["No permissions to retrieve gold from the guildbank."] = "No permissions to retrieve gold from the guildbank.",
   ["Your withdraw limit does not allow to retrieve enough gold from the guildbank."] = "Your withdraw limit does not allow to retrieve enough gold from the guildbank.",
   ["You neither have enough gold in your poket nor offers your guildbank enough to pay your repair costs."] = "You neither have enough gold in your poket nor offers your guildbank enough to pay your repair costs.",
   ["Whisper Spec + GS"] = "Whisper Spec + GS",
   ["Opens Whisper target input to apply for a raid/group"] = "Apply for Raid with selected character",
   ["%s %s with %sgs"] = "%s %s with %sgs",
   ["Select need:"] = "Select need:",
   ["Whisper Target:"] = "Whisper Target:",
   ["Comment:"] = "Comment:",
   ["Instance has ID"] = "Instance has ID",
   ["Instance unvisited"] = "Stance not yet visited",
   ["No better Gear available"] = "No better Gear available",
   ["For %s we are looking for %s%s%s%s %s"] = "For %s looking for %s%s%s%s %s",
   ["Requirements and Requests:"] = "Requirements and Comments",
   ["Raid Member Search"] = "Raid member search",
   ["Search"] = "Search",
   ["Trade Emblems"] = "Trade Emblems",
   ["%s used %s to interupt %s by %s"] = "%s used %s to interupt %s by %s",
   ["SetDBMTimer"] = "Set DBM timer",
   ["Ok"] = "Okay",
   ["Pause"] = "Pause",
   ["Pull"] = "Pull",
   ["Readycheck"] = "Readycheck",
} end)