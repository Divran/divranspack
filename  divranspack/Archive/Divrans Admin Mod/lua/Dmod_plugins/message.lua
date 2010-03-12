-------------------------------------------------------------------------------------------------------------------------
-- Message
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.Name = "Message" -- The name of the plugin
DmodPlugin.Description = "Code used for displaying messages in the chat." -- The description shown in the Menu
DmodPlugin.ShowInMenu = false -- Do you want this plugin to be shown in the menu at all?
DmodPlugin.Type = "" -- Where in the Menu will it show?
DmodPlugin.Creator = "Divran" -- Who created it?
if SERVER then Dmod_AddPlugin(DmodPlugin) else Dmod_ClientAddPlugin(DmodPlugin) end

local function Dmod_AddText( um )
-- User Messages:
local C = um:ReadString()
local F = um:ReadBool()
local Txt = um:ReadString()
-- Variables:
local Clr = Color(255,255,255,255)
local Front = ""

if (C == "warning") then Clr = Color(80,80,200,255) end
if (C == "normal") then Clr = Color(80,200,80,255) end
if (C == "punish") then Clr = Color(200,80,80,255) end
if (F == true) then Front = "[D] " end
if (F == false) then Front = "[D] (Silent) " end

	chat.AddText( Clr, Front, Color(255,255,255,255), Txt )
end
usermessage.Hook( "Dmod_AddText", Dmod_AddText )