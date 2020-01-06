with Insa, Insa.Graphics, Insa.Graphics.Images;
use Insa, Insa.Graphics, Insa.Graphics.Images;

with Ressources;
use Ressources;

procedure Images is
   Sprites: array(1..20) of IMAGE;
   
   Pacman_Gauche_Index:      constant INTEGER := 1;
   Pacman_Gauche_2_Index:    constant INTEGER := 2;
   Pacman_Droit_Index:       constant INTEGER := 3;
   Pacman_Droit_2_Index:     constant INTEGER := 4;
   Pacman_Haut_Index:        constant INTEGER := 5;
   Pacman_Haut_2_Index:      constant INTEGER := 6;
   Pacman_Bas_Index:         constant INTEGER := 7;
   Pacman_Bas_2_Index:       constant INTEGER := 8;
   Fantome_Jaune_Index:      constant INTEGER := 9;
   Fantome_Rose_Index:       constant INTEGER := 10;
   Fantome_Bleu_Index:       constant INTEGER := 11;
   Fantome_Rouge_Index:      constant INTEGER := 12;
   Fantome_Vulnerable_Index: constant INTEGER := 13;
   PacGum_Index:             constant INTEGER := 14;
   Melon_Index:              constant INTEGER := 15;
   Orange_Index:             constant INTEGER := 16;
   Cerise_Index:             constant INTEGER := 17;
   Fraise_Index:             constant INTEGER := 18;
   Pomme_Index:              constant INTEGER := 19;
   Truc_Index:               constant INTEGER := 20;
   
   procedure ChargeSprites is
   begin
      Sprites(Cerise_Index):=UnpackImage(Cerise);
      
      Sprites(Fantome_Bleu_Index):=UnpackImage(Fantome_Bleu);
      Sprites(Fantome_Jaune_Index):=UnpackImage(Fantome_Jaune);
      Sprites(Fantome_Rose_Index):=UnpackImage(Fantome_Rose);
      Sprites(Fantome_Rouge_Index):=UnpackImage(Fantome_Rouge);
      Sprites(Fantome_Vulnerable_Index):=UnpackImage(Fantome_Vuln);
      Sprites(Fraise_Index):=UnpackImage(Fraise);
      Sprites(Melon_Index):=UnpackImage(Melon);
      Sprites(Orange_Index):=UnpackImage(Orange);
      Sprites(Pacgum_Index):=UnpackImage(Pac_Gum);
      
      Sprites(Pacman_Gauche_Index):=UnpackImage(Pacman_Gauche);
      Sprites(Pacman_Gauche_2_Index):=UnpackImage(Pacman_Gauche_2);
      Sprites(Pacman_Droit_Index):=UnpackImage(Pacman_Droit);
      Sprites(Pacman_Droit_2_Index):=UnpackImage(Pacman_Droit_2);
      Sprites(Pacman_Haut_Index):=UnpackImage(Pacman_Haut);
      Sprites(Pacman_Haut_2_Index):=UnpackImage(Pacman_Haut_2);
      Sprites(Pacman_Bas_Index):=UnpackImage(Pacman_Bas);
      Sprites(Pacman_Bas_2_Index):=UnpackImage(Pacman_Bas_2);
      Sprites(Pomme_Index):=UnpackImage(Pomme);
      Sprites(Truc_Index):=UnpackImage(Truc);
   end ChargeSprites;
   
   Pos_X: Pixel_X;
   
begin
   SetTextColor(White);
   SetBackColor(Black);

   ClearScreen(Black);
   
   -- decompression des sprites
   ChargeSprites;
   
   --  DrawImage((Cerise_Index*16)-16, 16, Sprites(Cerise_Index));
   
   --  DrawImage((Fantome_Bleu_Index*16)-16, 16, Sprites(Fantome_Bleu_Index));
   --  DrawImage((Fantome_Jaune_Index*16)-16, 16, Sprites(Fantome_Jaune_Index));
   --  DrawImage((Fantome_Rose_Index*16)-16, 16, Sprites(Fantome_Rose_Index));
   --  DrawImage((Fantome_Rouge_Index*16)-16, 16, Sprites(Fantome_Rouge_Index));
   --  DrawImage((Fantome_Vulnerable_Index*16)-16, 16, Sprites(Fantome_Vulnerable_Index));
   --  DrawImage((Fraise_Index*16)-16, 16, Sprites(Fraise_Index));
   --  DrawImage((Melon_Index*16)-16, 16, Sprites(Melon_Index));
   --  DrawImage((Orange_Index*16)-16, 16, Sprites(Orange_Index));
   --  DrawImage((Pacgum_Index*16)-16, 16, Sprites(Pacgum_Index));
   
   for Index in 1..20 loop
      DrawImage((Index*16)-16, 16, Sprites(Index));
   end loop;
   
   Pos_X:=Pixel_X'Last-Sprites(Pacman_Gauche_Index).Width;
   SetTextColor(Black);
   
   loop
      DrawImage(Pos_X, 176,Sprites(Pacman_Gauche_Index));
      DrawImage(Pos_X-32, 176,Sprites(Fantome_Vulnerable_Index));
      Insa.SysDelay(150);
      
      DrawFillRectangle(Pos_X,176, Pos_X+16, 176+16);
      DrawFillRectangle(Pos_X-32,176, Pos_X+16-32, 176+16);
      
      DrawImage(Pos_X-16, 176,Sprites(Pacman_Gauche_2_Index));
      if (Pos_X-16-32>=0) then
	 DrawImage(Pos_X-32-16, 176,Sprites(Fantome_Vulnerable_Index));
      end if;
      
      Insa.SysDelay(150);
      
      DrawFillRectangle(Pos_X-16,176, Pos_X+16-16, 176+16);
      if (Pos_X-16-32>=0) then
	 DrawFillRectangle(Pos_X-16-32,176, Pos_X+16-16-32, 176+16);
      end if;	 
      
      if Pos_X<32+16 then
	 Pos_X := Pixel_X'Last-Sprites(Pacman_Gauche_Index).Width;
      else
	 Pos_X:= Pos_X -32;
      end if;
      
   end loop;
   
end Images;
