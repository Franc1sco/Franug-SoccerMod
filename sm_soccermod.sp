
#include <sourcemod>
#include <cstrike>
#include <sdktools>
#include <sdkhooks>

#define VERSION "v1.1"

new Handle:sm_soccermod_enable;

public Plugin:myinfo =
{
	name = "SM SoccerMod",
	author = "Franc1sco Steam: franug",
	description = "Mod of Soccer for CS:S",
	version = VERSION,
	url = "http://servers-cfg.foroactivo.com/"
}

public OnPluginStart()
{
	CreateConVar("sm_SoccerMod", VERSION, "Version", FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY|FCVAR_DONTRECORD);

	sm_soccermod_enable = CreateConVar("sm_soccermod_enable", "1", "Enables/disables all features of the plugin.", FCVAR_NONE, true, 0.0, true, 1.0);

	HookEvent("round_start", Ronda_Empieza);

	HookEvent("player_spawn", Event_PlayerSpawn);


}

public OnMapStart()
{
  if (GetConVarInt(sm_soccermod_enable) == 1)
  {
        AddFileToDownloadsTable("materials/models/player/soccermod/termi/2010/home2/skin_foot_a2.vmt");
        AddFileToDownloadsTable("materials/models/player/soccermod/termi/2010/home2/skin_foot_a2.vtf");
        AddFileToDownloadsTable("models/player/soccermod/termi/2010/home2/ct_urban.dx80.vtx");
        AddFileToDownloadsTable("models/player/soccermod/termi/2010/home2/ct_urban.dx90.vtx");
        AddFileToDownloadsTable("models/player/soccermod/termi/2010/home2/ct_urban.mdl");
        AddFileToDownloadsTable("models/player/soccermod/termi/2010/home2/ct_urban.phy");
        AddFileToDownloadsTable("models/player/soccermod/termi/2010/home2/ct_urban.sw.vtx");
        AddFileToDownloadsTable("models/player/soccermod/termi/2010/home2/ct_urban.vvd");
        AddFileToDownloadsTable("models/player/soccermod/termi/2010/home2/ct_urban.xbox.vtx");
        AddFileToDownloadsTable("materials/models/player/soccermod/termi/2010/away2/skin_foot_a2.vmt");
        AddFileToDownloadsTable("materials/models/player/soccermod/termi/2010/away2/skin_foot_a2.vtf");
        AddFileToDownloadsTable("models/player/soccermod/termi/2010/away2/ct_urban.dx80.vtx");
        AddFileToDownloadsTable("models/player/soccermod/termi/2010/away2/ct_urban.dx90.vtx");
        AddFileToDownloadsTable("models/player/soccermod/termi/2010/away2/ct_urban.mdl");
        AddFileToDownloadsTable("models/player/soccermod/termi/2010/away2/ct_urban.phy");
        AddFileToDownloadsTable("models/player/soccermod/termi/2010/away2/ct_urban.sw.vtx");
        AddFileToDownloadsTable("models/player/soccermod/termi/2010/away2/ct_urban.vvd");
        AddFileToDownloadsTable("models/player/soccermod/termi/2010/away2/ct_urban.xbox.vtx");

	//PrecacheModel("models/player/soccermod/termi/2010/away2/ct_urban.mdl");
	//PrecacheModel("models/player/soccermod/termi/2010/home2/ct_urban.mdl");
  }
  PrecacheModel("models/player/soccermod/termi/2010/home2/ct_urban.mdl");
  PrecacheModel("models/player/soccermod/termi/2010/away2/ct_urban.mdl");
}

public OnClientPutInServer(client)
{
    SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamage);
}

public Event_PlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
  if (GetConVarInt(sm_soccermod_enable) == 1)
  {
	new userid = GetEventInt(event, "userid");
	new client = GetClientOfUserId(userid);

        if (GetClientTeam(client) == CS_TEAM_T)
        {
           SetEntityModel(client,"models/player/soccermod/termi/2010/home2/ct_urban.mdl");
           SetEntityHealth(client, 250);
        }
        else if (GetClientTeam(client) == CS_TEAM_CT)
        {
           SetEntityModel(client,"models/player/soccermod/termi/2010/away2/ct_urban.mdl");
           SetEntityHealth(client, 250);
        }
  }
}

public Action:Ronda_Empieza(Handle:event,const String:name[],bool:dontBroadcast)
{
  if (GetConVarInt(sm_soccermod_enable) == 1)
  {
        ServerCommand("phys_pushscale 900");
        ServerCommand("phys_timescale 1");
        ServerCommand("sv_turbophysics 0");
  }
}

public Action:OnTakeDamage(client, &attacker, &inflictor, &Float:damage, &damagetype)
{
  if (GetConVarInt(sm_soccermod_enable) == 1)
  {
      if (damagetype & DMG_FALL || damagetype & DMG_BULLET || damagetype & DMG_SLASH)
      {
            return Plugin_Handled;
      }
      else if (damagetype & DMG_CRUSH)
      {
            damage = 0.0;
            return Plugin_Changed;
      }
  }
  return Plugin_Continue;
}