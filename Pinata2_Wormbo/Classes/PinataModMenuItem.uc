//=============================================================================
// PinataModMenuItem.
//=============================================================================
class PinataModMenuItem expands UMenuModMenuItem;

function Execute() {
	MenuItem.Owner.Root.CreateWindow(class'PinataConfigWindow',10,10,150,100);
}

defaultproperties {
	MenuCaption="&Pin�ta 2 Wormbo Options"
	MenuHelp="Configure the Pin�ta 2 Wormbo mutator"
}
