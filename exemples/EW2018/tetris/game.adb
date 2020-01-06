-- tetris.time package

with Insa;
with Insa.Graphics;
with Insa.Graphics.Advanced;
with Insa.Graphics.Images;
with Insa.Timer;
with Insa.Keys;

with Game.Tetrominos;
with Game.Sprites;

use Insa;
use Insa.Graphics;
use Insa.Graphics.Advanced;
use Insa.Graphics.Images;
use Insa.Timer;
use Insa.Keys;

use Game.Tetrominos;
use Game.Sprites;

with Insa.Audio.Synthesizer;
use Insa.Audio.Synthesizer;

with Insa.Random_Number;

with Ressources;
use Ressources;

package body Game is

  BGM_Started : boolean;

  procedure EventTimer is
  begin 
    TimeEvent := True;
    
  end EventTimer;
  
  procedure SettimerCallback is
  begin
    Timer.SetEventCallback(EventTimer'access);
  end SettimerCallback;
  
  procedure Initialize is
    status: SYNTH_STATUS;
  begin
    -- Decompresse les Sprite 
    UnpackSprites;
    
    -- Start Synthe
    status:=SYNTH_Start;
  end Initialize;
  
  procedure Writescore(Score: Natural; Level: Natural) is
  begin
    Settextcolor(White);
    Setbackcolor(TransparentColor);
      
    Drawstring ( 27,2,"Lvl: " & Integer'Image(Level));
    Drawstring (27,3,Integer'Image(Score));
  end Writescore;
  
  function getSizeX(tetromino : Natural; orient: Orientation) return Natural is
    counter: Natural := 0;
    max_counter: Natural := 0;
    line, column: Natural :=1;
  begin
    if orient<1 or orient>4 then
      raise constraint_error;
    end if;

    if tetromino<1 or tetromino>7 then
      raise constraint_error;
    end if;

    for column in 1..4 loop
      for line in 1..4 loop
        if TetrisForm(orient,tetromino,column,line) = 1 then
          counter := counter +1;
          if counter > max_counter then 
            max_counter := counter;
          end if;
        end if;
      end loop;
    end loop;

    return max_counter;
  end getSizeX;

  function getSizeY(tetromino : Natural; orient: Orientation) return Natural is
    counter: Natural := 0;
    max_counter: Natural := 0;
    line, column: Natural :=1;
  begin
    if orient<1 or orient>4 then
      raise constraint_error;
    end if;

    if tetromino<1 or tetromino>7 then
      raise constraint_error;
    end if;

    for line in 1..4 loop
      for column in 1..4 loop
        if TetrisForm(orient,tetromino,column,line) = 1 then
          counter := counter +1;
          if counter > max_counter then 
            max_counter := counter;
          end if;
        end if;
      end loop;
    end loop;

    return max_counter;
  end getSizeY;

  function GetNextTetromino return Natural is
    randomValue: Insa.Random_Number.RANDOM_VALUE;
    value:Integer;
  begin
    randomValue:=Insa.Random_Number.getValue;
    value:=randomValue*7/65536;
    value:=value+1;

    if value>7 then 
      value := 7;
    end if;

    return value;
  end GetNextTetromino;

  procedure PlayBGM is
    i: Integer;
    status: SYNTH_STATUS;
  begin
  
    if BGM_Started =false then
      BGM_Started := true;
      status:=SYNTH_SetMainVolume(50);

      i:=0;
		  while (i<4) loop
			  status:= SYNTH_SetVolume(i, 100);               -- Reglage du volume par canal
    	  status:= SYNTH_SetInstrument(i, Guitar_Access);	-- Parametrage de l'instrument à utiliser par canal

		    i:=i+1;
		  end loop;

      status:=MELODY_Start(themeA_Melody,themeA.music_length);   -- Demarrage de la musique
    else
      if MELODY_GetPosition = 255 then
        status:=MELODY_Start(themeA_Melody,themeA.music_length); 
      end if;
    end if;
  end PlayBGM;

  procedure PlayGameOverMusic is
    i: Integer;
    status: SYNTH_STATUS;
  begin
  
    status:=Melody_Stop;
      
    status:=SYNTH_SetMainVolume(100);

    i:=0;
		while (i<4) loop
			status:= SYNTH_SetVolume(i, 100);               -- Reglage du volume par canal
    	status:= SYNTH_SetInstrument(i, Guitar_Access);	-- Parametrage de l'instrument à utiliser par canal

		  i:=i+1;
		end loop;

    status:=MELODY_Start(gameover_music_Melody,gameover_music.music_length);   -- Demarrage de la musique
    
  end PlayGameOverMusic;

  procedure ShowMainGame is
  procedure Affichefond is
    begin
      SetLayer(Layer_2);
      SetTextColor(Navy);
      DrawFillRectangle(0,0,319,239);
    end Affichefond;
  begin
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
      Drawimage(6, I*Sprite(Mur_V).Height, Sprite(Mur_V));
      Drawimage(12+12*12, I*Sprite(Mur_V).Height, Sprite(Mur_V));
    end loop;
    
    for I in Integer range 1..12 loop
      Drawimage(I*Sprite(Mur_H).Width, 6, Sprite(Mur_H)); 
      Drawimage(I*Sprite(Mur_H).Width, 19*12, Sprite(Mur_H)); 
    end loop;
    
    Drawimage(6,19*12,Sprite(Coin_4));
    Drawimage(13*12,19*12,Sprite(Coin_3));
    Drawimage(6,6,Sprite(Coin_1));
    Drawimage(13*12,6,Sprite(Coin_2));
    
    -- Dessin de la zone de score
    for I in Integer range 1..4 loop
      Drawimage((12*16)+6, (16)+I*Sprite(Mur_V).Height, Sprite(Mur_V));
      Drawimage((12*16)+12*9, (16)+I*Sprite(Mur_V).Height, Sprite(Mur_V));
    end loop;
    
    for I in Integer range 1..8 loop
      Drawimage((12*16)+I*Sprite(Mur_H).Width, (16)+6, Sprite(Mur_H)); 
      Drawimage((12*16)+I*Sprite(Mur_H).Width, (12*2)+(4*12)+4, Sprite(Mur_H)); 
    end loop;
    
    Drawimage((12*16)+6,16+6,Sprite(Coin_1));        -- Coin  Sup Gauche
    Drawimage((12*16)+12*9,16+6,Sprite(Coin_2));  -- Coin  Sup Droit
    Drawimage((12*16)+6,6*12+4,Sprite(Coin_4));       -- Coin  Inf Gauche
    Drawimage((12*16)+12*9,6*12+4,Sprite(Coin_3)); -- Coin  Inf Droit
    Drawstring(27,1, "Score");
    
    -- Dessin de la zone d'attaque
    for I in Integer range 1..2 loop
      Drawimage((12*16)+6, (9*12)-12+I*Sprite(Mur_V).Height, Sprite(Mur_V));
      Drawimage((12*16)+12*9, (9*12)-12+I*Sprite(Mur_V).Height, Sprite(Mur_V));
    end loop;
    
    for I in Integer range 1..8 loop
      Drawimage((12*16)+I*Sprite(Mur_H).Width, (9*12)-6, Sprite(Mur_H)); 
      Drawimage((12*16)+I*Sprite(Mur_H).Width, (9*12)+(3*12)-12, Sprite(Mur_H)); 
    end loop;
    
    Drawimage((12*16)+6,(9*12)-6,Sprite(Coin_1));        -- Coin  Sup Gauche
    Drawimage((12*16)+12*9,(9*12)-6,Sprite(Coin_2));  -- Coin  Sup Droit
    Drawimage((12*16)+6,(8*12)+(3*12),Sprite(Coin_4));       -- Coin  Inf Gauche
    Drawimage((12*16)+12*9,(8*12)+(3*12),Sprite(Coin_3)); -- Coin  Inf Droit
    Drawstring(27,6, "Attack");
    
    -- Dessin de la zone "next"
    for I in Integer range 1..4 loop
      Drawimage((12*16)+6, (13*12)+4+I*Sprite(Mur_V).Height, Sprite(Mur_V));
      Drawimage((12*16)+12*9, (13*12)+4+I*Sprite(Mur_V).Height, Sprite(Mur_V));
    end loop;
    
    for I in Integer range 1..8 loop
      Drawimage((12*16)+I*Sprite(Mur_H).Width, (13*12)+10, Sprite(Mur_H)); 
      Drawimage((12*16)+I*Sprite(Mur_H).Width, (13*12)+(5*12)+4, Sprite(Mur_H)); 
    end loop;
    
    Drawimage((12*16)+6,(13*12)+10,Sprite(Coin_1));        -- Coin  Sup Gauche
    Drawimage((12*16)+12*9,(13*12)+10,Sprite(Coin_2));  -- Coin  Sup Droit
    Drawimage((12*16)+6,(13*12)+(5*12)+4,Sprite(Coin_4));       -- Coin  Inf Gauche
    Drawimage((12*16)+12*9,(13*12)+(5*12)+4,Sprite(Coin_3)); -- Coin  Inf Droit
    Drawstring(27,10, "Next");
    
    SetLayer(Layer_1);
    BGM_Started:=false;
  end ShowMainGame;

  procedure ShowTitleScreen is
    status: SYNTH_STATUS;
    i: INTEGER;
  begin
    UnpackimagetoSRAM(TitleScreen,0);

    DrawimagefromSRAM(0,0, 
                      TitleScreen.Width, 
                      TitleScreen.Height, 
                      0);

		status:=SYNTH_SetMainVolume(100);

    --i:=0;
		--while (i<4) loop
			--status:= SYNTH_SetVolume(i, 100);               -- Reglage du volume par canal
    	--status:= SYNTH_SetInstrument(i, Guitar_Access);	-- Parametrage de l'instrument à utiliser par canal

		-- i:=i+1;
		--end loop;

   -- status:=MELODY_Start(intro_Melody,intro.music_length);   -- Demarrage de la musique

    while (GetKeyState(Key_A) /= Key_Pressed) loop
      if MELODY_GetPosition = 255 then
       status:=MELODY_Start(intro_Melody,intro.music_length);
     end if;
    end loop;

    --status:=Melody_Stop;
  end ShowTitleScreen;

  procedure ShowGameOver is
    counter: Natural:=0;
    status:SYNTH_STATUS;

  begin

    PlayGameOverMusic;

    for line in Natural range 1..PIT_HEIGHT loop
      counter:=0;

      while counter<1 loop
        if TimeEvent = True then
          TimeEvent:=False;
          counter:=counter+1;
        end if;
      end loop;

      for column in Natural range 1..PIT_WIDTH loop
        DrawTile(column, line, Tuile_Grise);
      end loop;
    end loop;

    Settextcolor(White);
    Setbackcolor(TransparentColor);
      
    Drawstring(5,5,"           ");
    Drawstring(5,6," GAME OVER ");
    Drawstring(5,7,"           ");
    Drawstring(5,8,"  Press A  ");
    Drawstring(5,9,"           ");

    while MELODY_GetPosition = 0 loop
      null;
    end loop;

    status:=Melody_Stop;

    while GetKeyState(Key_A) /= 1 loop
      null;
    end loop;
  end ShowGameOver;
end Game;
