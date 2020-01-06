with Insa , Insa.Graphics  ;
use  Insa , Insa.Graphics  ;

package body Ecran is
      
   procedure EffacerEcran is
   begin
      ClearScreen(Navy);
   end EffacerEcran;
   
   procedure EcrireEcran (C : in Integer;L : in Integer;S : in String) is
   begin
      Insa.Graphics.SetTextColor(White);
      Insa.Graphics.SetBackColor(Navy); 
      Insa.Graphics.DrawString(C,L,S);
   end EcrireEcran;
   
end Ecran;
