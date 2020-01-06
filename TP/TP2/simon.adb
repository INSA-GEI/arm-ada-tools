with Insa, Insa.Graphics, Insa.Graphics.UI, Insa.Keys,Insa.Timer ,Insa.Random_Number; 
use Insa, Insa.Graphics, Insa.Graphics.UI, Insa.Keys, Insa.Timer ,Insa.Random_Number; 

with Insa.Graphics.Advanced;
use Insa.Graphics.Advanced;

with Insa.Graphics.Images;
use Insa.Graphics.Images;

with Insa.Audio.Synthesizer;
use Insa.Audio.Synthesizer;

with Ressources;
use Ressources;

package body Simon is
   
   TaillePave : constant Integer := 40 ;
   type T_Coord is record
      X : Integer ;
      Y : Integer ;
   end record;
   
   CouleurFond     : constant COLOR := White   ;
   CouleurHaut     : constant COLOR := Blue  ;
   CouleurBas      : constant COLOR := Green  ;
   CouleurDroite   : constant COLOR := Red    ;
   CouleurGauche   : constant COLOR := Yellow ;
   
   PositionCentre  : constant T_Coord := (PIXEL_X'Last/2,PIXEL_Y'Last/2) ;
   PositionHaut    : constant T_Coord := (PositionCentre.X + TaillePave,PositionCentre.Y) ;
   PositionBas     : constant T_Coord := (PositionCentre.X - TaillePave,PositionCentre.Y) ;
   PositionDroite  : constant T_Coord := (PositionCentre.X,PositionCentre.Y + TaillePave) ;
   PositionGauche  : constant T_Coord := (PositionCentre.X,PositionCentre.Y - TaillePave) ;

   T_Bleue : constant INTEGER :=1;
   T_Rouge : constant INTEGER :=2;
   T_Verte : constant INTEGER :=3;
   T_Jaune : constant INTEGER :=4;

   Sprites: array (1..4) of Integer;

   procedure DessinerBlocHautDroit (Efface : Boolean) is
      status: SYNTH_STATUS;

   begin
      if Efface then
	 --SetPenColor(White);
	 --DrawFillRectangle(0, 0, 
	 --		   319,239);
    DrawimagefromSRAM((320-simonBg.Width)/2, 
                        (240-simonBg.Height)/2, 
                        simonBg.Width, 
                        simonBg.Height, 
                        0);
      else	 
      status:= SYNTH_SetInstrument(0, Guitar_Access);
	   status:=SYNTH_NoteOn(0, C3);
	   DrawimagefromSRAM(165, 35, 
			   Touche_Bleue.Width, 
			   Touche_Bleue.Height, 
			   Sprites(T_Bleue));
      end if;
   end DessinerBlocHautDroit ;
   
   procedure DessinerBlocBasGauche (Efface : Boolean) is
      status: SYNTH_STATUS;
   begin
      if Efface then
	 --SetPenColor(White);
	 --DrawFillRectangle(0, 0, 
	 --		   319,239);
    DrawimagefromSRAM((320-simonBg.Width)/2, 
                        (240-simonBg.Height)/2, 
                        simonBg.Width, 
                        simonBg.Height, 
                        0);
      else	 
	 status:= SYNTH_SetInstrument(0, Guitar_Access);
    status:=SYNTH_NoteOn(0, A3);
	 DrawimagefromSRAM(72, 127, 
			   Touche_Rouge.Width, 
			   Touche_Rouge.Height, 
			   Sprites(T_Rouge));
      end if;
   end DessinerBlocBasGauche ;
   
   procedure DessinerBlocBasDroit (Efface : Boolean) is
      status: SYNTH_STATUS;
   begin
      if Efface then
	 --SetPenColor(White);
	 --DrawFillRectangle(0, 0, 
	 --		   319,239);
    DrawimagefromSRAM((320-simonBg.Width)/2, 
                        (240-simonBg.Height)/2, 
                        simonBg.Width, 
                        simonBg.Height, 
                        0);
      else	 
	 status:= SYNTH_SetInstrument(0, Guitar_Access);
    status:=SYNTH_NoteOn(0, C4);
	 DrawimagefromSRAM(165, 127, 
			   Touche_Verte.Width, 
			   Touche_Verte.Height, 
			   Sprites(T_Verte));
      end if;
   end DessinerBlocBasDroit ;
   
   procedure DessinerBlocHautGauche (Efface : Boolean) is
      status: SYNTH_STATUS;
   begin
      if Efface then
	 --SetPenColor(White);
	 --DrawFillRectangle(0, 0, 
	 --		   319,239);
    DrawimagefromSRAM((320-simonBg.Width)/2, 
                        (240-simonBg.Height)/2, 
                        simonBg.Width, 
                        simonBg.Height, 
                        0);
      else	 
	 status:= SYNTH_SetInstrument(0, Guitar_Access);
    status:=SYNTH_NoteOn(0, A4);
	 DrawimagefromSRAM(74, 35, 
			   Touche_Jaune.Width, 
			   Touche_Jaune.Height, 
			   Sprites(T_Jaune));
      end if;
   end DessinerBlocHautGauche ;
   
   procedure EffacerEcran is
   begin
      ClearScreen(white);
   end EffacerEcran;
   
   procedure EcrireEcran (C : in Integer; L : in Integer; S : in String) is
   begin
      SetTextColor(BLack);
      SetBackColor(white); 
      DrawString(C,L,S);
   end EcrireEcran;
   
   procedure EffacerLigne (L : in Integer) is
   begin
      for I in 0..Text_X'Last loop
	 EcrireEcran(I,L," ");
      end loop;
   end EffacerLigne ;   
   
   procedure AttendreToucheA is
   begin
      EcrireEcran(2,Text_Y'LAST,"Appuyer sur A pour continuer");
      while GetKeyState(Key_A) /= Key_Pressed loop
	 null ;
      end loop ;
      
      while GetKeyState(Key_A) = Key_Pressed loop
	 null ;
      end loop ;
   end AttendreToucheA;
   
   function SaisirLongueurSequence return Integer  is
      MyProgressBar : ProgressBar ;
      potValue: POTENTIOMETER_VALUE;
      Depth: Natural;
      
   begin
      EcrireEcran (2, 4, "Saisissez la taille de la sequence");
      EcrireEcran (2, 11, "Appuyer sur A pour valider");
      CreateProgressBar(myProgressBar, 50, 100, PIXEL_X'Last-100, 26);
      ProgressBarSetMaximum(myProgressBar,15);
      
      while GetKeyState(Key_A) /= Key_Pressed loop
	 potValue:=GetPotentiometerValue(Potentiometer_Left);
	 Depth := (Integer(PotValue)*15/255);
	 ProgressBarChangeValue(myProgressBar, Depth);
	 EcrireEcran (2, 9, Positive'Image(Depth)&"  ");
	 Insa.SysDelay(50);
      end loop;   
      
      while GetKeyState(Key_A) = Key_Pressed loop
	 null ;
      end loop ;
      
      EffacerEcran;
      return Depth ;
   end SaisirLongueurSequence ;
   
   procedure GenererSequence(S : in out T_Sequence) is
      Pave : Integer ;
   begin 
      for I in S'Range loop
	 Pave := GetValue;
	 
	 if Pave < Random_Value'Last / 4 then 
	    S(I):= Haut_Droit;
	 elsif Pave < Random_Value'Last / 2 then
	    S(I):= Haut_Gauche;   
	 elsif Pave < Random_Value'Last * 3 / 4  then
	    S(I):= Bas_Droit; 
	 else
	    S(I):= Bas_Gauche;    
	 end if ;
      end loop;
   end GenererSequence ;
   
   TempsEcoule : integer := 0;
   AttenteAffichage : constant Integer := 5 ;
   
   function GetTempsEcoule return Integer is
   begin
      return TempsEcoule ;
   end GetTempsEcoule ;
   
   procedure TraiterPeriodique is
   begin 
      TempsEcoule := TempsEcoule + 1 ;
   end TraiterPeriodique ;
   
   procedure InitialiserCarte is
   begin      
      TempsEcoule := 0 ;
      SetEventCallBack(TraiterPeriodique'Access);
      StartTimer;
   end InitialiserCarte ;
   
   procedure SuspendreTimer is
   begin
      StopTimer;
   end SuspendreTimer ;
   
   procedure ReprendreTimer is
   begin
      StartTimer;
   end ReprendreTimer ;
   
   procedure Mettreazerotimer is
   begin
      TempsEcoule := 0;
   end Mettreazerotimer ;
   
   function DetecterDirection return T_Direction is
      Resultat : T_Direction ;
      TempsEntree : integer  := TempsEcoule ;
      Valide : Boolean := False ;
      
   begin
      while not Valide loop
	 if GetKeyState(Key_Up) = Key_Pressed and GetKeyState(Key_Right) = Key_Pressed then
	    Resultat := Haut_Droit ;
	    Valide := True ;
	 end if; 
	 
	 if GetKeyState(Key_Up) = Key_Pressed and GetKeyState(Key_Left) = Key_Pressed then
	    Resultat := Haut_Gauche ;
	    Valide := True ;
	 end if;
	 
	 if GetKeyState(Key_Down) = Key_Pressed and GetKeyState(Key_Right) = Key_Pressed then
	    Resultat := Bas_Droit ;
	    Valide := True ;
	 end if;
	 
	 if GetKeyState(Key_Down) = Key_Pressed and GetKeyState(Key_Left) = Key_Pressed then
	    Resultat := Bas_Gauche ;
	    Valide := True ;
	 end if;
	 
	 if GetKeyState(Key_Down) /= Key_Pressed and GetKeyState(Key_Left) /= Key_Pressed and
	   GetKeyState(Key_Up) /= Key_Pressed and GetKeyState(Key_Right) /= Key_Pressed then
	    Resultat := Immobile;
	    Valide := True ;
	 end if;
      end loop;
      
      Mettreazerotimer;
      
      while GetTempsEcoule /= 1 loop
	 null;
      end loop;
      
      return Resultat ;
   end DetecterDirection ;
      
   procedure DessinerPave (P: T_Direction; Efface : Boolean) is
   begin
      case P is
	 when Haut_Droit   => DessinerBlocHautDroit(Efface);	    
	 when Haut_Gauche  => DessinerBlocHautGauche(Efface);
	 when Bas_Droit    => DessinerBlocBasDroit(Efface) ;
	 when Bas_Gauche   => DessinerBlocBasGauche(Efface) ;
	 when others       => null;
      end case;  
   end DessinerPave;   
   
   
   procedure EffaceTout is
   begin
      DessinerPave (Haut_Gauche, True) ;
      DessinerPave (Bas_Gauche, True) ;
      DessinerPave (Haut_Droit, True) ;
      DessinerPave (Bas_Droit, True) ;
   end EffaceTout;
   
   procedure AfficherSequence (S : T_Sequence) is
   begin    
      for I in S'Range loop 
	 DessinerPave (S(I),False);
	 Mettreazerotimer;
	 
	 while  TempsEcoule < AttenteAffichage loop
	    null;
	 end loop;
	 
	 DessinerPave (S(I),True);
	 Mettreazerotimer;
	 
	 while  TempsEcoule < AttenteAffichage loop
	    null;
	 end loop;	 
      end loop;
   end AfficherSequence ;
   
   procedure PetitePause is
   begin
      Mettreazerotimer;
      while  TempsEcoule < 2*AttenteAffichage loop
	 null ;
      end loop ;
   end PetitePause ;
   
   procedure InitialiserSonetImage is
      status: SYNTH_Status;
      i: INTEGER;
   begin 
      -- Demarrage du synthe
      if SYNTH_Start /=SYNTH_SUCCESS then
	 raise CONSTRAINT_ERROR;
      end if;

      status:=SYNTH_SetMainVolume(200);
      i:=0;

      while i<4 loop
	 status:=SYNTH_SetVolume(i, 255);
	 status:=SYNTH_SetInstrument(i, Guitar_Access);
	 i:=i+1;
      end loop;
   end InitialiserSonetImage;

   procedure AfficherSimon is
   begin     
      --SetLayerDisplayMode(Display_Mode_Transparency);
      --SetLayer(Layer_2);
      
      ClearScreen(White);

      UnpackimagetoSRAM(simonBg,0);
      DrawimagefromSRAM((320-simonBg.Width)/2, 
                        (240-simonBg.Height)/2, 
                        simonBg.Width, 
                        simonBg.Height, 
                        0);

      --SetLayer(Layer_1);
      --SetLayerTransparency(Transparency_100,Transparency_100);
      --SetTransparentColorforBTE(White);
      --ClearScreen (White);

      Sprites(T_Bleue):=(simonBg.Width*simonBg.Height);
      UnpackimagetoSRAM(Touche_Bleue,Sprites(T_Bleue));
      Sprites(T_Rouge):=Sprites(T_Bleue)+(Touche_Bleue.Width*Touche_Bleue.Height);
      UnpackimagetoSRAM(Touche_Rouge,Sprites(T_Rouge));
      Sprites(T_Verte):=Sprites(T_Rouge)+(Touche_Rouge.Width*Touche_Rouge.Height);
      UnpackimagetoSRAM(Touche_Verte,Sprites(T_Verte));
      Sprites(T_Jaune):=Sprites(T_Verte)+(Touche_Verte.Width*Touche_Verte.Height);
      UnpackimagetoSRAM(Touche_Jaune,Sprites(T_Jaune));
   end AfficherSimon;

   procedure EffaceEcranFinDuJeu is
   begin
      --SetLayer(Layer_2);
      --ClearScreen(White);
      --SetLayer(Layer_1);
      ClearScreen(White);
   end EffaceEcranFinDuJeu;

   procedure AfficherGameOver is
      status: SYNTH_STATUS;
      stat_MELODY: MELODY_STATUS;

      i: INTEGER;
   begin
      --SetLayer(Layer_1);
      --ClearScreen(Black);

      UnpackimagetoSRAM(GameOver,0);
      DrawimagefromSRAM((320-GameOver.Width)/2, 
                        (240-GameOver.Height)/2, 
                        GameOver.Width, 
                        GameOver.Height, 
                        0);

      if SYNTH_Start =SYNTH_SUCCESS then
	 status:=SYNTH_SetMainVolume(200);

	 i:=0;
	 while (i<4) loop
	    status:= SYNTH_SetVolume(i, 255);               -- Reglage du volume par canal
	    status:= SYNTH_SetInstrument(i, Guitar_Access);	-- Parametrage de l'instrument à utiliser par canal

	    i:=i+1;
	 end loop;

	 stat_MELODY:=MELODY_Start(rip_Melody,rip.music_length);   -- Demarrage de la musique

	 while GetKeyState(Key_A) /= Key_Pressed loop
	    null ;
	 end loop ;
	 
	 while GetKeyState(Key_A) = Key_Pressed loop
	    null ;
	 end loop;

	 stat_MELODY:=MELODY_Stop;
      end if;
   end  AfficherGameOver;

   procedure AfficherGagne is
      i: Integer;
      temps: integer;

      status: SYNTH_STATUS;
      stat_MELODY: MELODY_STATUS;
   begin
      --SetLayer(Layer_1);
      
      Sprites(1):=0;
      UnpackimagetoSRAM(Fire1,Sprites(1));
      Sprites(2):=Sprites(1)+(Fire1.Width*Fire1.Height);
      UnpackimagetoSRAM(Fire2,Sprites(2));
      Sprites(3):=Sprites(2)+(Fire2.Width*Fire2.Height);
      UnpackimagetoSRAM(Fire3,Sprites(3));
      Sprites(4):=Sprites(3)+(Fire3.Width*Fire3.Height);
      UnpackimagetoSRAM(Fire4,Sprites(4));

      Mettreazerotimer;
      ReprendreTimer;

      if SYNTH_Start =SYNTH_SUCCESS then
	 status:=SYNTH_SetMainVolume(200);

	 i:=0;
	 while (i<4) loop
	    status:= SYNTH_SetVolume(i, 255);               -- Reglage du volume par canal
	    status:= SYNTH_SetInstrument(i, Sinus_Instr_Access);	-- Parametrage de l'instrument à utiliser par canal

	    i:=i+1;
	 end loop;

	 stat_MELODY:=MELODY_Start(ymca_Melody,ymca.music_length);   -- Demarrage de la musique
      end if;

      i:=1;
      while (GetKeyState(Key_A) /= Key_Pressed) loop
	 ClearScreen(Black);

	 temps:= GetTempsEcoule;

	 case i is
	    when 1 => DrawimagefromSRAM((320-Fire1.Width)/2, 
					(240-Fire1.Height)/2+50, 
					Fire1.Width, 
					Fire1.Height, 
					Sprites(1));
	    when 2 => DrawimagefromSRAM((320-Fire2.Width)/2, 
					(240-Fire2.Height)/2, 
					Fire2.Width, 
					Fire2.Height, 
					Sprites(2));
	    when 3 => DrawimagefromSRAM((320-Fire3.Width)/2, 
					(240-Fire3.Height)/2, 
					Fire3.Width, 
					Fire3.Height, 
					Sprites(3));
	    when others => DrawimagefromSRAM((320-Fire4.Width)/2, 
					     (240-Fire4.Height)/2, 
					     Fire4.Width, 
					     Fire4.Height, 
					     Sprites(4));
	 end case;

	 i:= i+1;
	 if i>=5 then
	    i:=1;
	 end if;

	 while temps+GetTempsEcoule<temps+6 loop
	    null;
	 end loop;

	 Mettreazerotimer;
	 ReprendreTimer;
      end loop;

      SuspendreTimer;
      Mettreazerotimer;
      ReprendreTimer;

      EffaceEcranFinDuJeu;

      stat_MELODY:=MELODY_Stop;

      while GetKeyState(Key_A) = Key_Pressed loop
	 null ;
      end loop;
   end AfficherGagne;

begin
   InitialiserCarte ;
   InitialiserSonetImage;
end Simon;
