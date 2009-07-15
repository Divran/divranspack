-------------------------------------------------------------------------------------------------------------------------
-- Rank
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.ChatCommand = "rank" -- The chat command you need to use this plugin
DmodPlugin.Name = "Rank" -- The name of the plugin
DmodPlugin.Description = "Allows you to change the rank of someone. To demote someone, use !rank Guest first." -- The description shown in the Menu
DmodPlugin.ShowInMenu = false -- Do you want this plugin to be shown in the menu at all?
DmodPlugin.Type = "administration" -- Where in the Menu will it show?
DmodPlugin.Creator = "Divran" -- Who created it?
DmodPlugin.RequiredRank = "Super Admin" -- The rank required to use this command. Can be "Guest", "Respected", "Admin", "Super Admin", or "Owner".
if SERVER then Dmod_AddPlugin(DmodPlugin) else Dmod_ClientAddPlugin(DmodPlugin) end


local function Dmod_Plugin( ply, Args )
if (Dmod_CheckRequiredRank(ply, DmodPlugin.RequiredRank)) then
	if (Args[2]) then
		if (Args[3]) then
			if (Dmod_FindPlayer(Args[2])) then
				local T = Dmod_FindPlayer(Args[2])
				local Rank = string.lower(Args[3])
				Dmod_AddUser( ply, T, Rank )
			else
				Dmod_Message(false, ply, "No player named '"..Args[2].."' found.","warning")
			end
		else
			Dmod_Message( false, ply, "You must enter a rank name!", "warning" )
		end
	else
		Dmod_Message( false, ply, "You must enter a name!","warning")
	end
end
end
hook.Add( DmodPlugin.Name, DmodPlugin.Name, Dmod_Plugin )

-------------------------------------------------------------------------------------------------------------------------
-- Rank Control
-------------------------------------------------------------------------------------------------------------------------

function Dmod_AddUser( ply, T, Rank )
	if (Rank == "owner" or Rank == "superadmin" or Rank == "admin" or Rank == "respected" or Rank == "guest") then
	local ID = T:SteamID()
	local Pos = T:GetPos() + Vector(0,0,5)
	local Ang = T:GetAimVector()
		if (Rank == "owner") then
			if (T:IsUserGroup("owner")) then
				Dmod_Message( false, ply, T:Nick() .. " is already an owner!", "warning" )
				return
			end
			local Txt = file.Read("dmod/owner.txt")
			file.Write("dmod/owner.txt",Txt .. [[ 
]] .. ID)
		Dmod_Message( true, ply, ply:Nick() .. " set " .. T:Nick() .. "'s rank to 'Owner'", "normal")
		Dmod_CheckForAdmin()
		T:Spawn()
		T:SetPos(Pos)
		T:SetAngles(Ang)
		elseif (Rank == "superadmin") then
			if (T:IsUserGroup("superadmin")) then
				Dmod_Message( false, ply, T:Nick() .. " is already a Super Admin!", "warning" )
				return
			end
			local Txt = file.Read("dmod/superadmin.txt")
			file.Write("dmod/superadmin.txt",Txt .. [[ 
]] .. ID)
		Dmod_Message( true, ply, ply:Nick() .. " set " .. T:Nick() .. "'s rank to 'Super Admin'", "normal")
		Dmod_CheckForAdmin()
		T:Spawn()
		T:SetPos(Pos)
		T:SetAngles(Ang)
		elseif (Rank == "admin") then
			if (T:IsUserGroup("Admin")) then
				Dmod_Message( false, ply, T:Nick() .. " is already an Admin!", "warning" )
				return
			end
			local Txt = file.Read("dmod/admin.txt")
			file.Write("dmod/admin.txt",Txt .. [[ 
]] .. ID)
		Dmod_Message( true, ply, ply:Nick() .. " set " .. T:Nick() .. "'s rank to 'Admin'", "normal")
		Dmod_CheckForAdmin()
		T:Spawn()
		T:SetPos(Pos)
		T:SetAngles(Ang)
		elseif (Rank == "respected") then
			if (T:IsUserGroup("Respected")) then
				Dmod_Message( false, ply, T:Nick() .. " is already Respected!", "warning" )
				return
			end
			local Txt = file.Read("dmod/respected.txt")
			file.Write("dmod/respected.txt",Txt .. [[ 
]] .. ID)
		Dmod_Message( true, ply, ply:Nick() .. " set " .. T:Nick() .. "'s rank to 'Respected'", "normal")
		Dmod_CheckForAdmin()
		T:Spawn()
		T:SetPos(Pos)
		T:SetAngles(Ang)
		elseif (Rank == "guest") then
			if (T:IsUserGroup("Guest")) then
				Dmod_Message( false, ply, T:Nick() .. " is already a Guest!", "warning" )
				return
			end
			local File = ""
			if (T:IsUserGroup("respected")) then File = "respected.txt" end
			if (T:IsUserGroup("admin")) then File = "admin.txt" end
			if (T:IsUserGroup("superadmin")) then File = "superadmin.txt" end
			if (T:IsUserGroup("owner")) then File = "owner.txt" end
			local Txt = file.Read("dmod/"..File)
			local Txt2 = string.Replace( Txt, ID, " " )
			file.Write("dmod/"..File,Txt2 )
			Dmod_Message( true, ply, ply:Nick() .. " set " .. T:Nick() .. "'s rank to 'Guest'", "normal")
			Dmod_CheckForAdmin()
			T:Spawn()
			T:SetPos(Pos)
			T:SnapEyeAngles(Ang)
		end
	else
		Dmod_Message( false, ply, "Invalid rank name. Should be 'Guest', 'Respected', 'Admin', 'SuperAdmin', or 'Owner'.", "warning" )
	end
end