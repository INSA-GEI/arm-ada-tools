with Insa;
with Insa.Graphics;
with Insa.Graphics.Advanced;
with Insa.Graphics.Images;
with Insa.Keys;
with Insa.Timer;
with Insa.Random_Number;

use Insa;
use Insa.Graphics.Advanced;
use Insa.Graphics.Images;
use Insa.Keys;

with Game;
use Game;

procedure Tetris is
   
   Score :Natural;
   Level: Natural;
   
begin
   
   TimeEvent:= False;
   Score:=0;
   Level:=0;
   
   Initialize;
   Writescore(Score,Level);
   
   SettimerCallback;
   Timer.Starttimer;
   
   loop 
      
      if Timeevent = True then
	 Timeevent := False;
	 Score := Score+1;
	 Writescore(Score,Level);
      end if;
   end loop;
   
end Tetris;
