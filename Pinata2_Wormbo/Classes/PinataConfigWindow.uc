//=============================================================================
// PinataConfigWindow.
//=============================================================================
class PinataConfigWindow expands UWindowFramedWindow;

function BeginPlay() {
	Super.BeginPlay();
	WindowTitle = "Configure Pinãta 2 - Wormbo";
	ClientClass = class'PinataClientWindow';
	bSizable = false;
}

function Created() {
	Super.Created();
	SetSize(310, 195);
	WinLeft = (Root.WinWidth - WinWidth) / 2;
	WinTop = (Root.WinHeight - WinHeight) / 2;
}
