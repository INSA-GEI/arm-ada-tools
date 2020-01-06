-- tetris.time package

with Insa;
with Insa.Graphics;
with Insa.Graphics.Advanced;
with Insa.Graphics.Images;
with Insa.Timer;

with sprites;

use Insa;
use Insa.Graphics;
use Insa.Graphics.Advanced;
use Insa.Graphics.Images;
use Insa.Timer;

use sprites;

package body Game is

   type TetrisFormType is array (1..4, 1..7, 1..4, 1..4) of Byte;
   
   TetrisForm: constant TetrisFormType :=
     (
      (
       
       -- Forms for 0 degree
       (
	(
	 (0, 1, 0, 0),
	 (0, 1, 0, 0),
	 (0, 1, 0, 0),
	 (0, 1, 0, 0)
	)
       ),
       (
	(
	 (0, 0, 0, 0),
	 (0, 1, 1, 0),
	 (0, 1, 1, 0),
	 (0, 0, 0, 0)
	)
       ),
       (
	(
	 (0, 0, 0, 0),
	 (0, 1, 0, 0),
	 (0, 1, 0, 0),
	 (0, 1, 1, 0)
	)
       ),
       (
	(
	 (0, 0, 0, 0),
	 (0, 0, 1, 0),
	 (0, 0, 1, 0),
	 (0, 1, 1, 0)
	)
       ),
       (
	(
	 (0, 0, 0, 0),
	 (0, 0, 1, 0),
	 (0, 1, 1, 0),
	 (0, 1, 0, 0)
	)
       ),
       (
	(
	 (0, 0, 0, 0),
	 (0, 1, 0, 0),
	 (0, 1, 1, 0),
	 (0, 0, 1, 0)
	)
       ),
       (
	(
	 (0, 0, 0, 0),
	 (1, 1, 1, 0),
	 (0, 1, 0, 0),
	 (0, 0, 0, 0)
	)
       )
      ),
      (
       -- Forms for 90 degrees
       (
	(
	 (0, 0, 0, 0),
	 (0, 0, 0, 0),
	 (1, 1, 1, 1),
	 (0, 0, 0, 0)
	)
       ),
       (
	(
	 (0, 0, 0, 0),
	 (0, 1, 1, 0),
	 (0, 1, 1, 0),
	 (0, 0, 0, 0)
	)
       ),
       (
	(
	 (0, 0, 0, 0),
	 (0, 0, 0, 1),
	 (0, 1, 1, 1),
	 (0, 0, 0, 0)
	)
       ),
       (
	(
	 (0, 0, 0, 0),
	 (0, 1, 1, 1),
	 (0, 0, 0, 1),
	 (0, 0, 0, 0)
	)
       ),
       (
	(
	 (0, 0, 0, 0),
	 (0, 1, 1, 0),
	 (0, 0, 1, 1),
	 (0, 0, 0, 0)
	)
       ),
       (
	(
	 (0, 0, 0, 0),
	 (0, 0, 1, 1),
	 (0, 1, 1, 0),
	 (0, 0, 0, 0)
	)
       ),
       (
	(
	 (0, 0, 0, 0),
	 (0, 1, 0, 0),
	 (0, 1, 1, 0),
	 (0, 1, 0, 0)
	)
       )
      ),
      (
       (
	(
	 (0, 1, 0, 0),
	 (0, 1, 0, 0),
	 (0, 1, 0, 0),
	 (0, 1, 0, 0)
	)
       ),
       (
	(
	 (0, 0, 0, 0),
	 (0, 1, 1, 0),
	 (0, 1, 1, 0),
	 (0, 0, 0, 0)
	)
       ),
       (
	(
	 (0, 0, 0, 0),
	 (0, 1, 1, 0),
	 (0, 0, 1, 0),
	 (0, 0, 1, 0)
	)
       ),
       (
	(
	 (0, 0, 0, 0),
	 (0, 1, 1, 0),
	 (0, 1, 0, 0),
	 (0, 1, 0, 0)
	)
       ),
       (
	(
	 (0, 0, 0, 0),
	 (0, 0, 1, 0),
	 (0, 1, 1, 0),
	 (0, 1, 0, 0)
	)
       ),
       (
	(
	 (0, 0, 0, 0),
	 (0, 1, 0, 0),
	 (0, 1, 1, 0),
	 (0, 0, 1, 0)
	)
       ),
       (
	(
	 (0, 0, 0, 0),
	 (0, 1, 0, 0),
	 (1, 1, 1, 0),
	 (0, 0, 0, 0)
	)
       )
      ),
      (
       (
	(
	 (0, 0, 0, 0),
	 (0, 0, 0, 0),
	 (1, 1, 1, 1),
	 (0, 0, 0, 0)
	)
       ),
       (
	(
	 (0, 0, 0, 0),
	 (0, 1, 1, 0),
	 (0, 1, 1, 0),
	 (0, 0, 0, 0)
	)
       ),
       (
	(
	 (0, 0, 0, 0),
	 (1, 1, 1, 0),
	 (1, 0, 0, 0),
	 (0, 0, 0, 0)
	)
       ),
       (
	(
	 (0, 0, 0, 0),
	 (1, 0, 0, 0),
	 (1, 1, 1, 0),
	 (0, 0, 0, 0)
	)
       ),
       (
	(
	 (0, 0, 0, 0),
	 (1, 1, 0, 0),
	 (0, 1, 1, 0),
	 (0, 0, 0, 0)
	)
       ),
       (
	(
	 (0, 0, 0, 0),
	 (0, 1, 1, 0),
	 (1, 1, 0, 0),
	 (0, 0, 0, 0)
	)
       ),
       (
	(
	 (0, 0, 0, 0),
	 (0, 0, 1, 0),
	 (0, 1, 1, 0),
	 (0, 0, 1, 0)
	)
       )
      )
     );
   
   Tuile_Bleu: constant Integer :=1;
   Tuile_Verte: constant Integer :=2;
   Tuile_Jaune: constant Integer :=3;
   Tuile_Cyan: constant Integer :=4;
   Tuile_Violet: constant Integer :=5;
   Tuile_Rouge: constant Integer :=6;
   Tuile_Orange: constant Integer :=7;
   Tuile_Gris: constant Integer :=8;
   
   Mur_H: constant Integer :=9;
   Mur_V: constant Integer :=10;
   
   Coin_1: constant Integer :=11;
   Coin_2: constant Integer :=12;
   Coin_3: constant Integer :=13;
   Coin_4: constant Integer :=14;
     
   BgrColor: COLOR := LightGrey;
   BgrScore: COLOR := LightGrey;
   Transparentcolor: Color := 252;
   
   Sprites: array (1..20) of IMAGE;
   
   procedure EventTimer is
   begin 
      TimeEvent := True;
      Drawstring(27,11,"truc");
   end EventTimer;
   
   procedure SettimerCallback is
   begin
      Timer.SetEventCallback(EventTimer'access);
   end SettimerCallback;
   
   procedure UnpackSprites is
   begin
      Sprites(1):=Unpackimage(Bloc_Bleu);
      Sprites(2):=Unpackimage(Bloc_Vert);
      Sprites(3):=Unpackimage(Bloc_Jaune);
      Sprites(4):=Unpackimage(Bloc_Cyan);
      Sprites(5):=Unpackimage(Bloc_Violet);
      Sprites(6):=Unpackimage(Bloc_Rouge);
      Sprites(7):=Unpackimage(Bloc_Orange);
      Sprites(8):=Unpackimage(Bloc_Gris);
      
      Sprites(9):=Unpackimage(Mur_Horizontal);
      Sprites(10):=Unpackimage(Mur_Vertical);
      
      Sprites(11):=Unpackimage(Mur_Coin_1);
      Sprites(12):=Unpackimage(Mur_Coin_2);
      Sprites(13):=Unpackimage(Mur_Coin_3);
      Sprites(14):=Unpackimage(Mur_Coin_4);
   end UnpackSprites;
   
   procedure Initialize is

      procedure Affichefond is
      begin
	 UnpackimagetoSRAM(Fond_3,0);
	 SetLayer(Layer_2);
      
	 DrawimagefromSRAM(0, 0, 320, 240, 0);
      end Affichefond;
      
   begin
      -- decompresse les sprites 
      Unpacksprites;
      
      -- Prepare Screen
      SetScrollMode(Scroll_Mode_Layer1);
      SetLayerDisplayMode(Display_Mode_Transparency);
      SetLayer(Layer_2);
      
      ClearScreen(BgrColor);

      SetLayer(Layer_1);
      SetLayerTransparency(Transparency_100,Transparency_100);
      SetTransparentColorforBTE(Transparentcolor);
      ClearScreen (Transparentcolor);
      
      Affichefond;
      
      SetLayer(Layer_1);
      Settextcolor(LightGrey);
      Setbackcolor(TransparentColor);
      
      -- Dessin du puit
      for I in Integer range 1..18 loop
         Drawimage(6, I*Sprites(Mur_V).Height, Sprites(Mur_V));
	 Drawimage(12+12*12, I*Sprites(Mur_V).Height, Sprites(Mur_V));
      end loop;
      
      for I in Integer range 1..12 loop
	 Drawimage(I*Sprites(Mur_H).Width, 6, Sprites(Mur_H)); 
	 Drawimage(I*Sprites(Mur_H).Width, 19*12, Sprites(Mur_H)); 
      end loop;
      
      Drawimage(6,19*12,Sprites(Coin_4));
      Drawimage(13*12,19*12,Sprites(Coin_3));
      Drawimage(6,6,Sprites(Coin_1));
      Drawimage(13*12,6,Sprites(Coin_2));
      
      -- Dessin de la zone de score
      for I in Integer range 1..4 loop
         Drawimage((12*16)+6, (16)+I*Sprites(Mur_V).Height, Sprites(Mur_V));
	 Drawimage((12*16)+12*9, (16)+I*Sprites(Mur_V).Height, Sprites(Mur_V));
      end loop;
      
      for I in Integer range 1..8 loop
	 Drawimage((12*16)+I*Sprites(Mur_H).Width, (16)+6, Sprites(Mur_H)); 
	 Drawimage((12*16)+I*Sprites(Mur_H).Width, (12*2)+(4*12)+4, Sprites(Mur_H)); 
      end loop;
      
      Drawimage((12*16)+6,16+6,Sprites(Coin_1));        -- Coin  Sup Gauche
      Drawimage((12*16)+12*9,16+6,Sprites(Coin_2));  -- Coin  Sup Droit
      Drawimage((12*16)+6,6*12+4,Sprites(Coin_4));       -- Coin  Inf Gauche
      Drawimage((12*16)+12*9,6*12+4,Sprites(Coin_3)); -- Coin  Inf Droit
      Drawstring(27,1, "Score");
      
      -- Dessin de la zone d'attaque
      for I in Integer range 1..2 loop
         Drawimage((12*16)+6, (9*12)-12+I*Sprites(Mur_V).Height, Sprites(Mur_V));
	 Drawimage((12*16)+12*9, (9*12)-12+I*Sprites(Mur_V).Height, Sprites(Mur_V));
      end loop;
      
      for I in Integer range 1..8 loop
	 Drawimage((12*16)+I*Sprites(Mur_H).Width, (9*12)-6, Sprites(Mur_H)); 
	 Drawimage((12*16)+I*Sprites(Mur_H).Width, (9*12)+(3*12)-12, Sprites(Mur_H)); 
      end loop;
      
      Drawimage((12*16)+6,(9*12)-6,Sprites(Coin_1));        -- Coin  Sup Gauche
      Drawimage((12*16)+12*9,(9*12)-6,Sprites(Coin_2));  -- Coin  Sup Droit
      Drawimage((12*16)+6,(8*12)+(3*12),Sprites(Coin_4));       -- Coin  Inf Gauche
      Drawimage((12*16)+12*9,(8*12)+(3*12),Sprites(Coin_3)); -- Coin  Inf Droit
      Drawstring(27,6, "Attack");
      
      -- Dessin de la zone "next"
      for I in Integer range 1..4 loop
         Drawimage((12*16)+6, (13*12)+4+I*Sprites(Mur_V).Height, Sprites(Mur_V));
	 Drawimage((12*16)+12*9, (13*12)+4+I*Sprites(Mur_V).Height, Sprites(Mur_V));
      end loop;
      
      for I in Integer range 1..8 loop
	 Drawimage((12*16)+I*Sprites(Mur_H).Width, (13*12)+10, Sprites(Mur_H)); 
	 Drawimage((12*16)+I*Sprites(Mur_H).Width, (13*12)+(5*12)+4, Sprites(Mur_H)); 
      end loop;
      
      Drawimage((12*16)+6,(13*12)+10,Sprites(Coin_1));        -- Coin  Sup Gauche
      Drawimage((12*16)+12*9,(13*12)+10,Sprites(Coin_2));  -- Coin  Sup Droit
      Drawimage((12*16)+6,(13*12)+(5*12)+4,Sprites(Coin_4));       -- Coin  Inf Gauche
      Drawimage((12*16)+12*9,(13*12)+(5*12)+4,Sprites(Coin_3)); -- Coin  Inf Droit
      Drawstring(27,10, "Next");
      
      SetLayer(Layer_1);
      Drawimage(20,20,Sprites(1));
      Drawimage(20,20+Sprites(1).Width,Sprites(2));
      Drawimage(20,20+2*Sprites(1).Width,Sprites(3));
      Drawimage(20,20+3*Sprites(1).Width,Sprites(4));
      Drawimage(20,20+4*Sprites(1).Width,Sprites(5));
      Drawimage(20,20+5*Sprites(1).Width,Sprites(6));
      Drawimage(20,20+6*Sprites(1).Width,Sprites(7));
      Drawimage(20,20+7*Sprites(1).Width,Sprites(8));
      
   end Initialize;
   
   procedure Writescore(Score: Natural; Level: Natural) is
   begin
      Settextcolor(White);
      Setbackcolor(TransparentColor);
      
      Drawstring ( 27,2,"Lvl: " & Integer'Image(Level));
      Drawstring (27,3,Integer'Image(Score));
   end Writescore;
   
end Game;
