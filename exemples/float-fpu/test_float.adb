with Insa;
with Insa.Graphics;
with Insa.Keys;
with Ada.Text_IO;

procedure Test_Float is

   type REAL is digits 5;
   
   Key_A_State: Insa.Keys.KEY_STATE := Insa.Keys.Key_Released;
   x,y,z: REAL := 0.0;
   
begin

   -- Configure la couleur du texte: noir sur fond blanc
   Insa.Graphics.SetTextColor(Insa.Graphics.Black);
   Insa.Graphics.SetBackColor(Insa.Graphics.White);
   
   x := 1.0;
   y := 2.0;
   z := x+y;
   
   -- Ecrit sur l'ecran
   Insa.Graphics.DrawString(5,3,"X = " & REAL'Image(x));
   Insa.Graphics.DrawString(5,4,"Y = " & REAL'Image(y));
   Insa.Graphics.DrawString(5,6,"Z = X+Y =" & REAL'Image(z));
   
   Ada.Text_IO.Put_Line("X = " & REAL'Image(x));
   Ada.Text_IO.Put_Line("Y = " & REAL'Image(y));
   Ada.Text_IO.Put_Line("Z = " & REAL'Image(z));
   
end Test_Float;
