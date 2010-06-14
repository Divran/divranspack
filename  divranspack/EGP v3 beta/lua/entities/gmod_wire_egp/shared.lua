ENT.Type           = "anim"
ENT.Base           = "base_wire_entity"

ENT.PrintName      = "Wire EGP"
ENT.Author         = "Divran & Goluch"
ENT.Contact        = "Goluch or Divran @ Wiremod"
ENT.Purpose        = "Bring Graphic Processing to E2"
ENT.Instructions   = "WireLink To E2"

ENT.Spawnable      = false
ENT.AdminSpawnable = false

include("lib/EGPlib.lua")
if (SERVER) then AddCSLuaFile("lib/EGPlib.lua") end