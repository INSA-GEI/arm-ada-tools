with Insa;
with Insa.Graphics;
with Ada.Text_IO;

procedure Hello is

begin

	-- Configure la couleur du texte: noir sur fond blanc
	Insa.Graphics.SetTextColor(Insa.Graphics.Black);
	Insa.Graphics.SetBackColor(Insa.Graphics.White);
	
	-- Ecrit sur l'ecran
	Insa.Graphics.DrawString(10,5,"Hello display !");
		
	-- Ecrit sur le terminal (liaison USB)
	Ada.Text_IO.Put("Hello terminal !");
   raise Constraint_Error;
   
end Hello;
