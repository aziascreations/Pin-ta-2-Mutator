//=============================================================================
// PinataModMenuItem.
//=============================================================================
class PinataModMenuItem expands UMenuModMenuItem;

function Execute() {
	MenuItem.Owner.Root.CreateWindow(class'PinataConfigWindow',10,10,150,100);
}

defaultproperties {
	MenuCaption="&Pinãta 2 Wormbo Options"
	MenuHelp="Configure the Pinãta 2 Wormbo mutator"
}
