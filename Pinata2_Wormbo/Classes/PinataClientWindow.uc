//=============================================================================
// PinataClientWindow.
//=============================================================================
class PinataClientWindow expands UWindowDialogClientWindow config;

// UI elements
var UWindowComboControl ComboList_WeaponDropStyle;

var UWindowCheckBox Checkbox_DropHealth, Checkbox_DropRelics;
var UWindowCheckBox Checkbox_DropJumpBoots, Checkbox_DropUDamage;
var UWindowCheckBox Checkbox_DropImpactHammer, Checkbox_DropChainsaw, Checkbox_DropRedeemer;

var UWindowHSliderControl Slide_ItemLifeSpan, Slide_RelicLifeSpan;
var UWindowLabelControl Label_ItemLifeSpan, Label_RelicLifeSpan;

var UWindowLabelControl Label_Version;

var UWindowSmallButton CloseButton;
var UWindowSmallCloseButton CancelButton;

// Pinãta config file variables
var() config bool noWeapons;
var() config bool noPowerups;

var() config bool dropWeapons;
var() config bool dropAmmo;

var() config bool dropHealth;
var() config bool dropRelics;
var() config bool dropJumpBoots;
var() config bool dropUDamage;

var() config bool dropImpactHammer;
var() config bool dropChainsaw;
var() config bool dropRedeemer;

var() config int itemLifeSpan;
var() config int relicLifeSpan;

function Created() {
	Super.Created();
	
	ComboList_WeaponDropStyle = UWindowComboControl(CreateControl(class'UWindowComboControl', 10, 8, 290, 1 ) );
	ComboList_WeaponDropStyle.SetText("Weapon Drop Method: ");
	ComboList_WeaponDropStyle.SetFont(F_Normal);
	ComboList_WeaponDropStyle.SetEditable(FALSE);
	ComboList_WeaponDropStyle.EditBoxWidth = 180;
	ComboList_WeaponDropStyle.AddItem("Drop All Weapons", "1");
	ComboList_WeaponDropStyle.AddItem("Drop All Weapons And Ammo", "2");
	ComboList_WeaponDropStyle.AddItem("Drop Current Weapon Only", "3");
	ComboList_WeaponDropStyle.AddItem("Drop Current Weapons And Ammo", "4");
	
	if(dropWeapons && !dropAmmo) {
		ComboList_WeaponDropStyle.SetValue ("Drop All Weapons","1");
	} else if(dropWeapons && dropAmmo) {
		ComboList_WeaponDropStyle.SetValue ("Drop All Weapons And Ammo","2");
	} else if(!dropWeapons && !dropAmmo) {
		ComboList_WeaponDropStyle.SetValue ("Drop Current Weapon Only","3");
	} else { // !dropWeapons && dropAmmo -> Implied
		ComboList_WeaponDropStyle.SetValue ("Drop Current Weapons And Ammo","4");
	}
	
	// Checkboxes - Non-Weapons
	Checkbox_DropHealth = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 40, 130, 1));
	Checkbox_DropHealth.SetText("Drop Random Health");
	Checkbox_DropHealth.bChecked = dropHealth;
	
	Checkbox_DropRelics = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 55, 130, 1));
	Checkbox_DropRelics.SetText("Drop Relics");
	Checkbox_DropRelics.bChecked = dropRelics;
	
	Checkbox_DropJumpBoots = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 70, 130, 1));
	Checkbox_DropJumpBoots.SetText("Drop Jump Boots");
	Checkbox_DropJumpBoots.bChecked = dropJumpBoots;
	
	Checkbox_DropUDamage = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10, 85, 130, 1));
	Checkbox_DropUDamage.SetText("Drop U-Damage");
	Checkbox_DropUDamage.bChecked = dropUDamage;
	
	// Checkboxes - Weapons
	Checkbox_DropImpactHammer = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10+130+30, 40, 130, 1));
	Checkbox_DropImpactHammer.SetText("Drop Impact Hammer");
	Checkbox_DropImpactHammer.bChecked = dropImpactHammer;
	
	Checkbox_DropChainsaw = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10+130+30, 55, 130, 1));
	Checkbox_DropChainsaw.SetText("Drop Chainsaw");
	Checkbox_DropChainsaw.bChecked = dropChainsaw;
	
	Checkbox_DropRedeemer = UWindowCheckBox(CreateControl(class'UWindowCheckBox', 10+130+30, 70, 130, 1));
	Checkbox_DropRedeemer.SetText("Drop Redeemer");
	Checkbox_DropRedeemer.bChecked = dropRedeemer;
	
	Slide_ItemLifeSpan = UWindowHSliderControl(CreateControl(class'UWindowHSliderControl', 10, 85+30, 250, 1));
	Slide_ItemLifeSpan.SetRange(0, 60*5, 5);
	Slide_ItemLifeSpan.SliderWidth=175;
	Slide_ItemLifeSpan.SetText("Item Life-Span: ");
	Slide_ItemLifeSpan.SetHelpText("0 for no despawn");
	Slide_ItemLifeSpan.SetValue(itemLifeSpan);
	
	Label_ItemLifeSpan = UWindowLabelControl(CreateControl(class'UWindowLabelControl', 265, 85+30, 40, 1));
	
	Slide_RelicLifeSpan = UWindowHSliderControl(CreateControl(class'UWindowHSliderControl', 10, 85+30+15, 250, 1));
	Slide_RelicLifeSpan.SetRange(0, 60*5, 5);
	Slide_RelicLifeSpan.SliderWidth=175;
	Slide_RelicLifeSpan.SetText("Relic Life-Span: ");
	Slide_RelicLifeSpan.SetHelpText("0 for no despawn");
	Slide_RelicLifeSpan.SetValue(relicLifeSpan);
	
	Label_RelicLifeSpan = UWindowLabelControl(CreateControl(class'UWindowLabelControl', 265, 85+30+15, 40, 1));
	
	Label_Version = UWindowLabelControl(CreateControl(class'UWindowLabelControl', 10, 155, 180, 1));
	Label_Version.SetText("Pinãta 2.0 - Wormbo");
	
	// Buttons
	CloseButton = UWindowSmallButton(CreateWindow(class'UWindowSmallButton', 190, 140+15, 48, 16));
	CloseButton.SetText("Save");
	CloseButton.NotifyWindow = Self; 
	
	CancelButton = UWindowSmallCloseButton(CreateWindow(class'UWindowSmallCloseButton', 250, 140+15, 48, 16));
	CancelButton.SetText("Cancel");
	
	Update();
}

function Update() {
	if(Label_ItemLifeSpan != None) {
		if(Int(Slide_ItemLifeSpan.GetValue()) > 0) {
			Label_ItemLifeSpan.SetText(Int(Slide_ItemLifeSpan.GetValue())$" sec");
		} else {
			Label_ItemLifeSpan.SetText("Infinite");
		}
	}
	
	if(Label_RelicLifeSpan != None) {
		if(Int(Slide_RelicLifeSpan.GetValue()) > 0) {
			Label_RelicLifeSpan.SetText(Int(Slide_RelicLifeSpan.GetValue())$" sec");
		} else {
			Label_RelicLifeSpan.SetText("Infinite");
		}
	}
}

function Notify( UWindowDialogControl C, byte E ) {
	local int mode;
	Super.Notify( C, E );
	
	switch(E) {
		case DE_Change:
			switch(C) {
				case ComboList_WeaponDropStyle:
					mode = int(ComboList_WeaponDropStyle.GetValue2());
					
					dropWeapons = false;
					dropAmmo = false;
					
					if(mode==1) {
						dropWeapons = true;
					} else if(mode==2) {
						dropWeapons = true;
						dropAmmo = true;
					} else if(mode==4) {
						dropAmmo = true;
					}
					
					class'Pinata'.static.StaticSaveConfig();
					break;
					
				case Checkbox_DropHealth:
					if(Checkbox_DropHealth.bChecked)
						dropHealth = true;
					else
						dropHealth = false;
					class'Pinata'.static.StaticSaveConfig();
					break;
					
				case Checkbox_DropRelics:
					if(Checkbox_DropRelics.bChecked)
						dropRelics = true;
					else
						dropRelics = false;
					class'Pinata'.static.StaticSaveConfig();
					break;
					
				case Checkbox_DropJumpBoots:
					if(Checkbox_DropJumpBoots.bChecked)
						dropJumpBoots = true;
					else
						dropJumpBoots = false;
					class'Pinata'.static.StaticSaveConfig();
					break;
					
				case Checkbox_DropUDamage:
					if(Checkbox_DropUDamage.bChecked)
						dropUDamage = true;
					else
						dropUDamage = false;
					class'Pinata'.static.StaticSaveConfig();
					break;
					
				case Checkbox_DropImpactHammer:
					if (Checkbox_DropImpactHammer.bChecked)
						dropImpactHammer = true;
					else
						dropImpactHammer = false;
					class'Pinata'.static.StaticSaveConfig();
					break;
					
				case Checkbox_DropChainsaw:
					if (Checkbox_DropChainsaw.bChecked)
						dropChainsaw = true;
					else
						dropChainsaw = false;
					class'Pinata'.static.StaticSaveConfig();
					break;
					
				case Checkbox_DropRedeemer:
					if (Checkbox_DropRedeemer.bChecked)
						dropRedeemer = true;
					else
						dropRedeemer = false;
					class'Pinata'.static.StaticSaveConfig();
					break;
					
				case Slide_ItemLifeSpan:
					itemLifeSpan = Int(Slide_ItemLifeSpan.GetValue());
					class'Pinata'.static.StaticSaveConfig();
					break;
				case Slide_RelicLifeSpan:
					relicLifeSpan = Int(Slide_RelicLifeSpan.GetValue());
					class'Pinata'.static.StaticSaveConfig();
					break;
			}
		case DE_Click:
			switch(C) {
				case CloseButton:
					SaveConfig();
					ParentWindow.Close();
					break;
			}
	}
	Update();
}

defaultproperties {
	dropHealth=True;
	dropRelics=False;
	dropJumpBoots=False;
	dropUDamage=False;
	dropWeapons=True;
	dropAmmo=False;
	dropImpactHammer=False;
	dropChainsaw=False;
	dropRedeemer=False;
	itemLifeSpan=180;
	relicLifeSpan=30;
}
