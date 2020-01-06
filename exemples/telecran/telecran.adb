with Insa;
with Insa.Graphics;
with Insa.Keys;
with Insa.Sensors;

with Ada.Text_IO;

use Insa;
use Insa.Graphics;
use Insa.Keys;
use Insa.Sensors;
  
procedure Telecran is
   
   Last_X: PIXEL_X;
   Last_Y: PIXEL_Y;
   
   Val_X, Last_Val_X, Val_Y, Last_Val_Y: POTENTIOMETER_VALUE;
   Potentiometer_X:	constant POTENTIOMETER_ID := Potentiometer_Left;
   Potentiometer_Y:	constant POTENTIOMETER_ID := Potentiometer_Right;
   
   X_Change, Y_Change: Boolean;
   
   function Convert_X ( Val: POTENTIOMETER_VALUE) return PIXEL_X is
   begin
      return PIXEL_X(Val)*PIXEL_X'Last/PIXEL_X(POTENTIOMETER_VALUE'Last);
   end Convert_X;
   
   function Convert_Y ( Val: POTENTIOMETER_VALUE) return PIXEL_Y is
   begin
      return Integer(Val)*PIXEL_Y'Last/Integer(POTENTIOMETER_VALUE'Last);
   end Convert_Y;
begin

   -- Configure la couleur du texte: noir sur fond blanc
   SetTextColor(Black);
   SetBackColor(White);
   
   -- Configure la couleur du trait
   SetPenColor(DarkGrey);
		    
   -- Ecrit sur le terminal (liaison USB)
   Ada.Text_IO.Put("Start telecran");
   
   Last_Val_X:= GetPotentiometerValue(Potentiometer_X);
   Last_Val_Y:= GetPotentiometerValue(Potentiometer_Y);
   
   Last_X:=Convert_X(Last_Val_X);
   Last_Y:=Convert_Y(Last_Val_Y);
   
   X_Change:=False;
   Y_Change:=False;
   
   loop
      Val_X:= GetPotentiometerValue(Potentiometer_X);
      Val_Y:= GetPotentiometerValue(Potentiometer_Y);
      
      if abs(Last_Val_X-Val_X)>3 then
	 X_Change:=True;
      end if;
      
      if abs(Last_Val_Y-Val_Y)>3 then
	 Y_Change:=True;
      end if;
      
      if X_Change=True or Y_Change=True then
	 DrawLine(Last_X,Last_Y,Convert_X(Val_X), Convert_Y(Val_Y));
	 Last_X:=Convert_X(Val_X);
	 Last_Y:=Convert_Y(Val_Y);
      end if;
      
   end loop;

end Telecran;
