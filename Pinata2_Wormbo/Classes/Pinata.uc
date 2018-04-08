//=============================================================================
// Pinãta 2 - Wormbo
// Author: |404|shiftre (Original Creator) & Azias (2.0+ Maintainer)
// Version: 2.0 - Wormbo
//=============================================================================
class Pinata expands Mutator;

#exec OBJ LOAD FILE=".\Relics.u"
#exec OBJ LOAD FILE=".\EIBotpackUpgrade.u"
#exec OBJ LOAD FILE=".\EnhancedItems.u"
#exec OBJ LOAD FILE=".\EnhancedRelics.u"

var bool dropWeapons;
var bool dropAmmo;
var bool dropHealth;
var bool dropRelics;
var bool dropJumpBoots;
var bool dropUDamage;
var bool dropImpactHammer;
var bool dropChainsaw;
var bool dropRedeemer;

var int itemLifeSpan;
var int relicLifeSpan;

var bool bInitialized;

function PostBeginPlay() {
	if(bInitialized) {
		return;
	}
	
	dropWeapons = class'PinataClientWindow'.Default.dropWeapons;
	dropAmmo = class'PinataClientWindow'.Default.dropAmmo;
	dropHealth = class'PinataClientWindow'.Default.dropHealth;
	dropRelics = class'PinataClientWindow'.Default.dropRelics;
	dropJumpBoots = class'PinataClientWindow'.Default.dropJumpBoots;
	dropUDamage = class'PinataClientWindow'.Default.dropUDamage;
	dropImpactHammer = class'PinataClientWindow'.Default.dropImpactHammer;
	dropChainsaw = class'PinataClientWindow'.Default.dropChainsaw;
	dropRedeemer = class'PinataClientWindow'.Default.dropRedeemer;
	
	itemLifeSpan = class'PinataClientWindow'.Default.itemLifeSpan;
	relicLifeSpan = class'PinataClientWindow'.Default.relicLifeSpan;
	
	bInitialized = TRUE;
}

function ScoreKill(Pawn Killer, Pawn Other) {
	local actor dropped;
	local float speed;
	local float temp;
	local int charge;
	local int finalcount;
	local int timecharge;
	local bool firstpass;
	local vector X,Y,Z;
	
	// Local list of droppable inv types
	local inventory inv;
	local weapon weap;
	local udamage udam;
	local ut_jumpboots jboots;
	local EI_JumpBoots eiJboots;
	
	firstpass = true;
	
	//Cycle through inventory, dropping weapons, pickups and armor
	for(inv=Other.Inventory; inv!=None; inv=inv.Inventory) {
		weap = Weapon(inv);
		
		if(weap != None) {
			// If "Drop Current Weapon Only" or "Drop Current Weapons And Ammo" is selected, toss it out, if possible.
			if(!dropWeapons) {
				if(firstpass) {
					//This prevents redeemer from being dropped owner kills himself with it
					if(WarheadLauncher(Other.Weapon)!=none && Other.Weapon.AmmoType.AmmoAmount == 0) {
						Other.Inventory.Destroy();
						continue;
					} else if(ImpactHammer(Other.Weapon)==None && ChainSaw(Other.Weapon)==None && Other.Weapon.bCanThrow) {
						Other.TossWeapon();
					}
					
					if(EI_Redeemer(Other.Weapon)!=none && Other.Weapon.AmmoType.AmmoAmount == 0) {
						Other.Inventory.Destroy();
						continue;
					} else if(EI_Hammer(Other.Weapon)==None && EI_ChainSaw(Other.Weapon)==None && Other.Weapon.bCanThrow) {
						Other.TossWeapon();
					}
					firstpass = false;
				}
				continue;
			}
			
			// EnhancedItems seems to mess things up too...
			//BroadcastMessage("Dropped: "@weap.class);
			
			// If "Drop All Weapons" or "Drop All Weapons And Ammo" is selected.
			// Get ammo count for this weapon
			charge = weap.AmmoType.AmmoAmount;
			
			// Do not drop if the Redeemer is empty
			if(WarheadLauncher(weap)!=none && charge == 0) {
				continue;
			}
			if(EI_Redeemer(weap)!=none && charge == 0) {
				continue;
			}
			
			// Do not drop if impact hammer or chainsaw
			if(ImpactHammer(weap)!= None || ChainSaw(weap)!=none || !weap.bCanThrow) {
				continue;
			}
			if(EI_Hammer(weap)!= None || EI_ChainSaw(weap)!=none) {
				continue;
			}
			
			// Spawn this item & set attributes
			dropped = Spawn(weap.Class,,,Other.Location);
			weap = Weapon(dropped);
			
			if(charge ==0) {
				weap.PickupAmmoCount = 1;
			} else {
				weap.PickupAmmoCount = charge;
			}
			
			if(weap != None) {
				weap.RespawnTime = 0.0;
				weap.LifeSpan = itemLifeSpan;
				weap.BecomePickup();
				weap.bTossedOut = true;
				weap.bWeaponStay = false;
				weap.GotoState('PickUp', 'Dropped');
			}
		} else if(dropJumpBoots && UT_jumpboots(inv) != None) {
			jboots = UT_jumpboots(inv);
			if (jboots != None) {
				//Since jboots have a timelimit & charge limit, record both
				timecharge = jboots.TimeCharge;
				charge = jboots.Charge;
				dropped = Spawn(jboots.Class,,,Other.Location);
				jboots = UT_jumpboots(dropped);
				jboots.TimeCharge = timecharge;
				jboots.Charge = charge;
				
				if (jboots != None) {
					jboots.RespawnTime = 0.0;
					jboots.LifeSpan = itemLifeSpan;
					jboots.BecomePickup();
				}
			}
		} else if(dropJumpBoots && EI_JumpBoots(inv) != None) {
			eiJboots = EI_JumpBoots(inv);
			if (eiJboots != None) {
				timecharge = eiJboots.TimeCharge;
				charge = eiJboots.Charge;
				dropped = Spawn(eiJboots.Class,,,Other.Location);
				eiJboots = EI_JumpBoots(dropped);
				eiJboots.TimeCharge = timecharge;
				eiJboots.Charge = charge;
				
				if (eiJboots != None) {
					eiJboots.RespawnTime = 0.0;
					eiJboots.LifeSpan = itemLifeSpan;
					eiJboots.BecomePickup();
				}
			}
		} else if(dropUDamage && UDamage(inv) != None) {
			BroadcastMessage("Dropping UDamage...");
			udam = UDamage(inv);
			if (udam != None) {
				//don't make much sense, but works
				if (udam.TimerRate-udam.TimerCounter < 5) {
					charge = 50;
				} else {
					charge =((udam.TimerRate-udam.TimerCounter)*10);
				}
				
				dropped = Spawn(udam.Class,,,Other.Location);
				udam = UDamage(dropped);
				udam.Charge = charge;
				if (udam != None) {
					udam.RespawnTime = 0.0;
					udam.LifeSpan = itemLifeSpan;
					udam.BecomePickup();
				}
			}
		} else if(dropRelics && (RelicInventory(inv) != None || ERelicInventory(inv) != None)) {
			dropped = Spawn(inv.class,,,Other.Location);
			inv = Inventory(dropped);
			
			if(inv != None) {
				inv.RespawnTime = 0.0;
				inv.LifeSpan = relicLifeSpan;
				inv.BecomePickup();
			}
		} else {
			if(Ammo(inv) == None) {
				// Unsupported Items
				//BroadcastMessage("Dropped: "@inv.Class);
				charge = inv.Charge;
				dropped = Spawn(inv.Class,,,Other.Location);
				inv = Inventory(dropped);
				inv.Charge = charge;
				
				if(inv != None) {
					inv.RespawnTime = 0.0;
					inv.LifeSpan = itemLifeSpan;
					inv.BecomePickup();
				}
			}
		}
		
		//Now set the speed of the dropped item based off victim's speed
		setVelocity (Other, dropped);
		
		//Destroy Item from victim's inventory
		Other.Inventory.Destroy();
	}
	
	if(dropHealth) {
		dropRandomHealth(Other);
	}
	
	// Call next mutator down the line.
	if(NextMutator != None) {
		NextMutator.ScoreKill(Killer, Other);
	}
}

function dropRandomHealth (Pawn Other) {
	local int   lottery;
	local int   i;
	local actor dropped;
	local float speed;
	
	lottery = Rand(100);
	
	if(lottery<=25){
		// Nothing...
	} else if(lottery<=55) {
		for (i=0; i<2; i++) {
			dropped = Spawn(class'HealthVial',,,Other.Location);
			setVelocity (Other, dropped);
			Inventory(dropped).LifeSpan = itemLifeSpan;
			Inventory(dropped).RespawnTime = 0.0;
			Inventory(dropped).BecomePickup();
		}
	} else if(lottery<=70) {
		dropped = Spawn(class'MedBox',,,Other.Location);
		setVelocity (Other, dropped);
		Inventory(dropped).LifeSpan = itemLifeSpan;
		Inventory(dropped).RespawnTime = 0.0;
		Inventory(dropped).BecomePickup();
	} else if(lottery<=85) {
		for (i=0; i<5; i++) {
			dropped = Spawn(class'HealthVial',,,Other.Location);
			setVelocity (Other, dropped);
			Inventory(dropped).LifeSpan = itemLifeSpan;
			Inventory(dropped).RespawnTime = 0.0;
			Inventory(dropped).BecomePickup();
		}
	} else if(lottery<=98) {
		for (i=0; i<1; i++) {
			dropped = Spawn(class'MedBox',,,Other.Location);
			setVelocity (Other, dropped);
			Inventory(dropped).LifeSpan = itemLifeSpan;
			Inventory(dropped).RespawnTime = 0.0;
			Inventory(dropped).BecomePickup();
		}
	} else if(lottery<=100) {
		dropped = Spawn(class'HealthPack',,,Other.Location);
		setVelocity (Other, dropped);
		Inventory(dropped).LifeSpan = itemLifeSpan;
		Inventory(dropped).RespawnTime = 0.0;
		Inventory(dropped).BecomePickup();
	}
}

//Set's the velocity of an actor dropped by pawn Other
function setVelocity (Pawn Other, Actor dropped) {
	local float speed;
	
	//Now set the speed of the dropped item based off victim's speed
	speed = VSize(Other.Velocity);
	if(dropped != None) {
		dropped.RemoteRole = ROLE_DumbProxy;
		dropped.SetPhysics(PHYS_Falling);
		dropped.bCollideWorld = true;
		
		if(speed != 0) {
			dropped.Velocity = Normal(Other.Velocity/speed + 0.5 * VRand()) * (speed + 280);
		} else {
			dropped.Velocity.X = 0;
			dropped.Velocity.Y = 0;
			dropped.Velocity.Z = 0;
		}
	}
}
