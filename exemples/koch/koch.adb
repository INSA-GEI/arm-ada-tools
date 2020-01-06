with Insa;
with Insa.Graphics;
with Insa.Graphics.UI;
with Insa.Keys;
with Tortue;
--with Ada.Text_IO;

use Insa;
use Tortue;
--use Ada.Text_IO;
use Insa.Keys;
use Insa.Graphics;
use Insa.Graphics.UI;

procedure Koch is

	myProgressBar: ProgressBar;
	potValue: POTENTIOMETER_VALUE;
	Depth: Positive;
	Key_A_State: KEY_STATE := Key_Released;
	
	procedure Courbe_Koch(Finesse : in Positive; Lg : in Float) is
	begin
	  
		if Finesse = 1                 -- cas trivial
		then Avancer(Lg);
		else                           -- cas general
			Courbe_Koch(Finesse-1, Lg/3.0);
			Tourner_Gauche(60.0);                

			Courbe_Koch(Finesse-1, Lg/3.0);
			Tourner_Droite(120.0);

			Courbe_Koch(Finesse-1, Lg/3.0);
			Tourner_Gauche(60.0);

			Courbe_Koch(Finesse-1, Lg/3.0);
		end if;
	end Courbe_Koch;

	procedure Flocon_Koch(Finesse : in Positive; Lg : in Float := 120.0) is
	begin
		Choix_Couleur(Insa.Graphics.Black);
		
		for Cote in 1..3 loop
			Courbe_Koch(Finesse, Lg);
			Tourner_Droite(120.0);      --dans le sens des aiguilles d'une montre
		end loop;
	end Flocon_Koch;

begin
	SetTextColor(Black);
	DrawString ((TEXT_X'LAST -7)/2, 4, "Finesse");
	DrawString ((TEXT_X'LAST -16)/2, 14, "Press A for draw");
	
	CreateProgressBar(myProgressBar, 50, 100, PIXEL_X'Last-100, 26);
	ProgressBarSetMaximum(myProgressBar,10);
	
	while (Key_A_State = Key_Released) loop
		Key_A_State := GetKeyState(Key_A);
		potValue:=GetPotentiometerValue(Potentiometer_Left);
		Depth := Positive((potValue*10/256)+1);
		--Depth := 2;
		ProgressBarChangeValue(myProgressBar, Depth);
		
		SetTextColor(Black);
		DrawString ((TEXT_X'LAST -2)/2, 9, Positive'Image(Depth) &"  ");
		
		-- delay 10.0; -- delay de 50 millisecondes
		Insa.SysDelay(50);
	end loop;
	
	while Key_A_State = Key_Pressed loop
		Key_A_State := GetKeyState(Key_A);
	end loop;
		
	Ouvrir_Page;

	Lever_plume;
	Absolue(80, 70);            --on se positionne en X=200, Y=200
	Tourner_Gauche(90.0);             --la tortue regarde vers la droite

	Baisser_Plume;

	Flocon_Koch(Depth,150.0);

	--Put_Line("Fini");

end Koch;
