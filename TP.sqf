 /*
 =============================== INFORMATION ===========================

  
 -- TP.sqf - This script teleports a player to the position of their Squad Leader (on foot or in a vehicle)
  
 -- By Fat_Lurch (fat.lurch@gmail.com) for ARMA 3
 -- Created: 2018-03-17
 -- Last Edit: 2018-03-20
 -- Parameters: None    
 -- Returns: Nothing

 -- Usage:
 
1. Place this script into a folder named "scripts" in the root directory of your mission
2. Add this code to the init line of an object that you want a player to be able to teleport from:

if (isServer) then 
{ 
	[this, ["Teleport to Squad Leader", "scripts\TP.sqf",[],10,true,false,"","true",2]] remoteExec ["addAction", 0, true]; 
};


 ================================== START ==============================
 */

 //============================= CONSTANTS =============================
 
_caller = _this select 1;		//i.e. the unit that initiated the action

_leader = leader group _caller;		//the leader of the group the unit is in

_squadVeh = vehicle leader group _caller;		//the vehicle the leader is in. If the leader isn't in a vehicle, this will return the leader himself

 //============================= MAIN CODE =============================
 
if (_caller == _leader) exitWith 
{
	hint "You're the leader of your squad. Teleport cancelled"};

if (_squadVeh != _leader) then
{
	//Leader is in vehicle, perform checks to see if a seat is available
	
	_seatAvailable = false;		//by default, assume no seat is available until proven otherwise. At the end of looking for seats, if there's still no seat available, tell the user
	
	if (_squadVeh emptyPositions "Driver" > 0 && vehicle _caller == _caller) then
	{
		_caller moveInDriver _squadVeh;
		_seatAvailable = true;
	};
	
	if (_squadVeh emptyPositions "Gunner" > 0 && vehicle _caller == _caller) then
	{
		_caller moveInGunner _squadVeh;
		_seatAvailable = true;
	};
	
	if (_squadVeh emptyPositions "Cargo" > 0 && vehicle _caller == _caller) then
	{
		_caller moveInCargo _squadVeh;
		_caller assignAsCargo _squadVeh;
		_seatAvailable = true;
	};
	
	if (_squadVeh emptyPositions "Commander" > 0 && vehicle _caller == _caller) then
	{
		_caller moveInCommander _squadVeh;
		_seatAvailable = true;
	};
	
	if (!_seatAvailable) then
	{
		hint "No seats are available in your squad's vehicle";
		sleep 5;
		hint "";	//Clear the hint - the standard 30 seconds is too long...
	};
}	
else
{
	//Leader is on foot. TP right behind them
	
	_caller allowDamage false;	//Give the unit a moment of invulnerability in case they TP into a wall, etc.
	
	_caller setPos(_leader getPos [1,(getDir _leader) + 180]);	//"should" get a position 1 meter directly behind the leader. Ref: alt syntax on getPos command
	
	_caller setDir (getDir _leader);	//Face the same was as the leader so you can see him and get some SA
	
	sleep 1;
	
	_caller allowDamage true;
};