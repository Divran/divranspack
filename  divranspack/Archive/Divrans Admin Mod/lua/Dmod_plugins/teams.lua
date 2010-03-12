-------------------------------------------------------------------------------------------------------------------------
-- Teams
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.Name = "Teams" -- The name of the plugin
DmodPlugin.Description = "The code for setting up teams and ranks" -- The description shown in the Menu
DmodPlugin.ShowInMenu = false -- Do you want this plugin to be shown in the menu at all?
DmodPlugin.Creator = "Divran" -- Who created it?
DmodPlugin.RequiredRank = "" -- The rank required to use this command. Can be "Guest", "Respected", "Admin", "Super Admin", or "Owner".
if SERVER then Dmod_AddPlugin(DmodPlugin) else Dmod_ClientAddPlugin(DmodPlugin) end

if SERVER then
	DoIt = false
	local GamemodesAllowed = {	"sandbox", -- Add any more gamemodes here
								"spacebuild2",
								"sb3",
								"spacebuild3" }

	function Dmod_CheckGamemode()
		for _,G in pairs( GamemodesAllowed ) do
			if (string.lower(GAMEMODE.Name) == G ) then
				DoIt = true
			end
		end
	end
	timer.Simple( 0.0001, Dmod_CheckGamemode )
	
	function Dmod_CreateNonExistantFiles()
		if (!file.IsDir("dmod")) then
			file.CreateDir("dmod")
			print("[D] The Dmod folder didn't exist. Created new folder.")
		end
				
		if (!file.Exists("dmod/respected.txt")) then
			file.Write("dmod/respected.txt","Put the SteamID of people you want to make Respected here:")
			print("[D] respected.txt didn't exist. Created new file.")
		end
		if (!file.Exists("dmod/admin.txt")) then
			file.Write("dmod/admin.txt","Put the SteamID of people you want to make Admins here:")
			print("[D] admin.txt didn't exist. Created new file.")
		end
		if (!file.Exists("dmod/superadmin.txt")) then
			file.Write("dmod/superadmin.txt","Put the SteamID of people you want to make Super Admins here:")
			print("[D] superadmin.txt didn't exist. Created new file.")
		end
		if (!file.Exists("dmod/owner.txt")) then
			file.Write("dmod/owner.txt","Put the SteamID of people you want to make Owners of the server here:")
			print("[D] owner.txt didn't exist. Created new file.")
		end
		if (!file.Exists("dmod/readme.txt")) then
			file.Write("dmod/readme.txt",[[To make someone respected/admin/superadmin manually, all you have to do is
copy their SteamID and paste it in the correct file.]])
			print("[D] readme.txt didn't exist. Created new file.")
		end
	end
	Dmod_CreateNonExistantFiles()
	
		Owners = ""
		SuperAdmins = ""
		Admins = ""
		Respected = ""
	
	
		function Dmod_CheckForAdmin( )
			Owners = file.Read( "dmod/owner.txt" )
			SuperAdmins = file.Read( "dmod/superadmin.txt" )
			Admins = file.Read( "dmod/admin.txt" )
			Respected = file.Read( "dmod/respected.txt" )
		end
		hook.Add( "PlayerInitialSpawn", "Dmod_CheckForAdmin", Dmod_CheckForAdmin )
	

		-- Player Spawn
		function Dmod_TeamColors( ply )
				local Own = false
				local SAdm = false
				local Adm = false
				local Resp = false
				ply.Owner = false
		
			local PlyID = ply:SteamID()
			timer.Simple( 0.2, function()
				if (string.find( Owners, PlyID )) then
					Own = true
				elseif (string.find( SuperAdmins, PlyID )) then
					SAdm = true
				elseif (string.find( Admins, PlyID )) then
					Adm = true
				elseif (string.find( Respected, PlyID )) then
					Resp = true
				end
				
				if (DoIt) then
					if (Own) then
						ply:SetTeam(1)
						ply.Owner = true
						ply:SetUserGroup("superadmin")
					elseif (SAdm) then
						ply:SetTeam(2)
						ply:SetUserGroup("superadmin")
					elseif (Adm) then
						ply:SetTeam(3)
						ply:SetUserGroup("admin")
					elseif (Resp) then
						ply:SetTeam(4)
						ply:SetUserGroup("respected")
					else 
						ply:SetTeam(5)
						ply:SetUserGroup("guest")
					end
				else
					if (Own) then
						ply.Owner = true
						ply:SetUserGroup("superadmin")
					elseif (SAdm) then
						ply:SetUserGroup("superadmin")
					elseif (Adm) then
						ply:SetUserGroup("admin")
					elseif (Resp) then
						ply:SetUserGroup("respected")
					else 
						ply:SetUserGroup("guest")
					end
				end
			end)
		end
		hook.Add( "PlayerSpawn", "Dmod_TeamColors", Dmod_TeamColors )
end
	
	-- Change color and Name in Scoreboard here, if you want.
team.SetUp(1, "Owner", Color( 50, 50, 50, 255 )) -- Black (Well, almost)
team.SetUp(2, "Super Admin", Color( 255, 200, 0, 255 )) -- Gold
team.SetUp(3, "Admin", Color(200, 80, 80, 255 )	) -- Dark Red
team.SetUp(4, "Respected", Color( 100, 200, 100, 255 )) -- Dark Green
team.SetUp(5, "Guest", Color( 100, 100, 255, 255 )) -- Dark Blue