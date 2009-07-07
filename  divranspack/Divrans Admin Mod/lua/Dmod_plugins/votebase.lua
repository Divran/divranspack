-------------------------------------------------------------------------------------------------------------------------
-- Vote Base
-------------------------------------------------------------------------------------------------------------------------
local DmodPlugin = {}
DmodPlugin.Name = "Vote Base" -- The name of the plugin
DmodPlugin.Description = "" -- The description shown in the Menu
DmodPlugin.ShowInMenu = false -- Do you want this plugin to be shown in the menu at all?
DmodPlugin.Type = "" -- Where in the Menu will it show?
DmodPlugin.Creator = "Divran" -- Who created it?
DmodPlugin.RequiredRank = "admin" -- The rank required to use this command. Can be "guest", "admin", "super admin", or "owner".
if SERVER then Dmod_AddPlugin(DmodPlugin) else Dmod_ClientAddPlugin(DmodPlugin) end

if CLIENT then

	local VoteTable = { }
	Voting = false
	local Time = 0
	local Secs = 0

	local function Dmod_StartVote( um )
		VoteNum = um:ReadLong()
		table.Empty(VoteTable)
		Time = 0
		Secs = 0
		for i=1, VoteNum do
			local M = um:ReadString()
			table.insert( VoteTable, M )	
		end
		
		Voting = true
		Time = CurTime() + 60
		Dmod_VoteWindow()
	end
	usermessage.Hook( "Dmod_ClientStartVote", Dmod_StartVote )
	
	function Dmod_VoteCountDown()
		if (Voting) then
			Secs = math.Round(Time-CurTime())
			if (Secs <= 0) then
				Voting = false
			end
		end
	end
	hook.Add( "Think", "Dmod_VoteCountDown", DMod_VoteCountDown )
	function Dmod_GetSecs( Lbl )
		Lbl:SetText( Secs )
	end
	
	function Dmod_VoteWindow()
		local VoteMenu = vgui.Create( "DFrame" )
		VoteMenu:SetPos( 50, ScrH() / 2 - 150 )
		VoteMenu:SetSize( 300, VoteNum * 50 )
		VoteMenu:SetTitle( "[D] Vote Menu" )
		VoteMenu:SetVisible( true )
		VoteMenu:SetDraggable( true )
		VoteMenu:ShowCloseButton( true )
		VoteMenu:MakePopup()
		
		local Text1 = vgui.Create( "DLabel", VoteMenu )
		Text1:SetText( "Place your vote. Duration: " )
		Text1:SetTextColor(Color(0,0,0,255))
		Text1:SizeToContents()
		Text1:SetPos( 5, 25 )
		
		local Text2 = vgui.Create( "DLabel", VoteMenu )
		Dmod_GetSecs( Text2 )
		Text2:SetPos( Text1:GetWide()+5, 25 )
		Text2:SetTextColor(Color(0,0,0,255))
		Text2:SizeToContents()
		
		local Text3 = vgui.Create( "DLabel", VoteMenu )
		Text3:SetText( VoteTable[1] )
		Text3:SetTextColor(Color(0,0,0,255))
		Text3:SizeToContents()
		Text3:SetPos( 15, 45 )
		table.remove( VoteTable, 1 )
	
		for i,l in pairs(VoteTable) do
			local Btn = vgui.Create( "DButton", VoteMenu )
			Btn:SetText( l )
			Btn:SizeToContents()
			Btn:SetSize(Btn:GetWide()+20,Btn:GetTall()+5)
			Btn:SetPos( 20, i*20+40 )
			function Btn:DoClick( )
				RunConsoleCommand( "Dmod_Cast_Vote", i )
			end
		end
	end

end


	local VoteCountTable = { }
	function Dmod_GatherVotes( ply, Com, Nrr )
		if (Voting) then
		local Nr = tonumber(Nrr)
			VoteCountTable[Nr] = VoteCountTable[Nr] + 1
			Dmod_Message( true, ply, ply:Nick() .. " cast his/her vote.", "normal" )	
		end
		if (!Voting and Nr == 0) then
			local L = VoteCountTable[1]
			for i=1, table.Count( VoteCountTable ) do
				if (VoteCountTable[i] > L) then L = VoteCountTable[i] end
			end
			Dmod_Message( true, ply, "The vote is over! " .. L .. " had the most votes.", "normal" )	
		end
	end
	concommand.Add( "Dmod_Cast_Vote", Dmod_GatherVotes )
	
