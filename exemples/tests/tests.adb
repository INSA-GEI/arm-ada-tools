with Insa;
with Insa.Graphics;
with Insa.Graphics.UI;
with Insa.Graphics.Images;
with Insa.Graphics.Advanced;
with Insa.Sensors;
with Insa.Keys;
with Insa.Timer;
with Insa.Random_Number;
with Insa.Memory;
with Insa.Led;
with Insa.Audio;

with Tests_Pak;
with Ada.Text_IO;

use Insa;
use Insa.Graphics;
use Insa.Graphics.UI;
use Insa.Graphics.Images;
use Insa.Graphics.Advanced;
use Insa.Sensors;
use Insa.Keys;
use Insa.Timer;
use Insa.Random_Number;
use Insa.Memory;
use Insa.Audio;

with Ressources;
use Ressources;

procedure Tests is
   
   procedure Test_Gyroscope is
      Val: Float;
      Valeurs_Gyroscope: SENSOR_VALUES;
      Bar_X, Bar_Y, Bar_Z: CenterBar;
     
   begin 
      SetTextColor(Black);
      SetBackColor(White);
      DrawString(15, 11, "Press key A");
	
      DrawString(5, 4, "Axe X: ");
      DrawString(5, 6, "Axe Y: ");
      DrawString(5, 8, "Axe Z: ");
      
      CreateCenterBar(Bar_X,12*8,4*16,200,20);
      CreateCenterBar(Bar_Y,12*8,6*16,200,20);
      CreateCenterBar(Bar_Z,12*8,8*16,200,20);
      
      CenterBarSetMaximum(Bar_X,256);
      CenterBarSetMaximum(Bar_Y,256);
      CenterBarSetMaximum(Bar_Z,256);
      
      loop 
	 -- Read Gyro Angular data
	 Valeurs_Gyroscope:= GetGyroscopicValues;
	 
	 Val:=Valeurs_Gyroscope(1);
	 CenterBarChangeValue(Bar_X,Integer(Val));

	 Val:=Valeurs_Gyroscope(2);
	 CenterBarChangeValue(Bar_Y,Integer(Val));

	 Val:=Valeurs_Gyroscope(3);
	 CenterBarChangeValue(Bar_Z,Integer(Val));

	 Insa.SysDelay(50); -- Attente de 50 millisecondes
	 
	 exit when GetKeyState(KEY_A) = KEY_PRESSED;	
      end loop;
   end Test_Gyroscope;
   
   procedure Test_Accelerometre is
      Val: Float;
      Valeurs_Accelerometre: SENSOR_VALUES;
      Bar_X, Bar_Y, Bar_Z: CenterBar;
     
   begin 
      SetTextColor(Black);
      SetBackColor(White);
      DrawString(15, 11, "Press key A");
	
      DrawString(5, 4, "Axe X: ");
      DrawString(5, 6, "Axe Y: ");
      DrawString(5, 8, "Axe Z: ");
      
      CreateCenterBar(Bar_X,12*8,4*16,200,20);
      CreateCenterBar(Bar_Y,12*8,6*16,200,20);
      CreateCenterBar(Bar_Z,12*8,8*16,200,20);
      
      CenterBarSetMaximum(Bar_X,1200);
      CenterBarSetMaximum(Bar_Y,1200);
      CenterBarSetMaximum(Bar_Z,1200);
      
      loop 
	 -- Read Gyro Angular data
	 Valeurs_Accelerometre:= GetAccelerometerValues;
	 
	 Val:=Valeurs_Accelerometre(1);
	 CenterBarChangeValue(Bar_X,Integer(Val));

	 Val:=Valeurs_Accelerometre(2);
	 CenterBarChangeValue(Bar_Y,Integer(Val));

	 Val:=Valeurs_Accelerometre(3);
	 CenterBarChangeValue(Bar_Z,Integer(Val));

	 Insa.SysDelay(50); -- Attente de 50 millisecondes

	 exit when GetKeyState(KEY_A) = KEY_PRESSED;	
      end loop;
   end Test_Accelerometre;
   
   procedure Test_Magnetometre is
      Val: Float;
      Valeurs_Magnetometre: SENSOR_VALUES;
      Bar_X, Bar_Y, Bar_Z: CenterBar;
     
   begin 
      SetTextColor(Black);
      SetBackColor(White);
      DrawString(15, 11, "Press key A");
	
      DrawString(5, 4, "Axe X: ");
      DrawString(5, 6, "Axe Y: ");
      DrawString(5, 8, "Axe Z: ");
      
      CreateCenterBar(Bar_X,12*8,4*16,200,20);
      CreateCenterBar(Bar_Y,12*8,6*16,200,20);
      CreateCenterBar(Bar_Z,12*8,8*16,200,20);
      
      CenterBarSetMaximum(Bar_X,512);
      CenterBarSetMaximum(Bar_Y,512);
      CenterBarSetMaximum(Bar_Z,512);
      
      loop 
	 -- Read Gyro Angular data
	 Valeurs_Magnetometre:= GetMagneticValues;
	 
	 Val:=Valeurs_Magnetometre(1);
	 CenterBarChangeValue(Bar_X,Integer(Val));

	 Val:=Valeurs_Magnetometre(2);
	 CenterBarChangeValue(Bar_Y,Integer(Val));

	 Val:=Valeurs_Magnetometre(3);
	 CenterBarChangeValue(Bar_Z,Integer(Val));

	 Insa.SysDelay(50); -- Attente de 50 millisecondes

	 exit when GetKeyState(KEY_A) = KEY_PRESSED;	
      end loop;
   end Test_Magnetometre;
   
   procedure Test_Periodic_Timer is 
   begin 
      SetTextColor(Black);
      SetBackColor(White);
      DrawString(15, 11, "Press key A");
	
      DrawString(5, 6, "Time: ");
      Tests_Pak.Event_Flag := 0;
      Tests_Pak.Compteur:=0;
      
      SetEventCallBack(Tests_Pak.Timer_Event'Access);
      StartTimer;
      
      loop 

	 if Tests_Pak.Event_Flag = 1 then
	    Tests_Pak.Event_Flag:= 0;
	    DrawString(12, 6, Integer'Image(Tests_Pak.Compteur));
         end if;
	 
	 exit when GetKeyState(KEY_A) = KEY_PRESSED;	
      end loop;
      
      StopTimer;
      
   end Test_Periodic_Timer;
   
   procedure Test_Keys is  
      State: Key_State;
      Val: POTENTIOMETER_VALUE;
      Pot_Bar_Left, Pot_Bar_Right: ProgressBar;
   begin
      
      CreateProgressBar(Pot_Bar_Left,100,46,200,20);
      CreateProgressBar(Pot_Bar_Right,100,78,200,20);
      ProgressBarSetMaximum(Pot_Bar_Left,255);
      ProgressBarSetMaximum(Pot_Bar_Right,255);
      
      loop
	 State:= GetKeyState(KEY_A);
	 if state = KEY_PRESSED then 
	    SetTextColor(White);
	    SetBackColor(Black);
	 else 
	    SetTextColor(Black);
	    SetBackColor(White);
	 end if;
	 
	 DrawString(30, 10, "A");
	 
	 State:= GetKeyState(KEY_B);
	 if state = KEY_PRESSED then 
	    SetTextColor(White);
	    SetBackColor(Black);
	 else 
	    SetTextColor(Black);
	    SetBackColor(White);
	 end if;
	 
	 DrawString(36, 10, "B");
	 
	 State:= GetKeyState(KEY_UP);
	 if state = KEY_PRESSED then 
	    SetTextColor(White);
	    SetBackColor(Black);
	 else 
	    SetTextColor(Black);
	    SetBackColor(White);
	 end if;
	 
	 DrawString(8, 8, "U");
	 
	 State:= GetKeyState(KEY_DOWN);
	 if state = KEY_PRESSED then
	    SetTextColor(White);
	    SetBackColor(Black);
	 else
	    SetTextColor(Black);
	    SetBackColor(White);
	 end if;
	 
	 DrawString(8, 12, "D");
	 
	 State:= GetKeyState(KEY_LEFT);
	 if state = KEY_PRESSED then 
	    SetTextColor(White);
	    SetBackColor(Black);
	 else 
	    SetTextColor(Black);
	    SetBackColor(White);
	 end if;
	 
	 DrawString(4, 10, "L");
	 
	 State:= GetKeyState(KEY_RIGHT);
	 if state = KEY_PRESSED then 
	    SetTextColor(White);
	    SetBackColor(Black);
	 else 
	    SetTextColor(Black);
	    SetBackColor(White);
	 end if;
	 
	 DrawString(12, 10, "R");
	 
	 State:= GetKeyState(KEY_CENTER);
	 if state = KEY_PRESSED then 
	    SetTextColor(White);
	    SetBackColor(Black);
	 else 
	    SetTextColor(Black);
	    SetBackColor(White);
	 end if;
	 
	 DrawString(8, 10, "C");
	 
	 Val:= GetPotentiometerValue(Potentiometer_Left);
	 
	 SetTextColor(Black);
	 SetBackColor(White);
	 DrawString(4, 3, "Left : ");
	 ProgressBarChangeValue(Pot_Bar_Left,INTEGER(val));
	 
	 Val:= GetPotentiometerValue(Potentiometer_Right);
	 
	 SetTextColor(Black);
	 SetBackColor(White);
	 DrawString(4, 5, "Right : ");
	 ProgressBarChangeValue(Pot_Bar_Right,INTEGER(val));
	 
	 exit when GetKeyState(KEY_A)=KEY_PRESSED and
	   GetKeyState(KEY_CENTER)=KEY_PRESSED;
	 
      end loop;
   end Test_Keys;
   
   procedure Test_Drawlines is
      Val: RANDOM_VALUE;
      X1, X2, Tmp_X: Pixel_X;
      Y1, Y2, Tmp_Y: Pixel_Y;
      Color: Insa.Graphics.COLOR;
      
   begin 
      loop
	 Val:=GetValue/256;
	 Color:=Insa.Graphics.COLOR(val);

	 Val:=GetValue;
	 X1:=(Val*PIXEL_X'Last)/RANDOM_VALUE'Last;
	 
	 Val:=GetValue;
	 X2:=(Val*PIXEL_X'Last)/RANDOM_VALUE'Last;
	 
	 Val:=GetValue;
	 Y1:=(Val*(PIXEL_Y'Last-16))/RANDOM_VALUE'Last;
	 
	 Val:=GetValue;
	 Y2:=(Val*(PIXEL_Y'Last-16))/RANDOM_VALUE'Last;
	 
	 Y1:=Y1+16;
	 Y2:=Y2+16;
	 
	 if (X1>X2) then
	    Tmp_X:=X1;
	    X1:=X2;
	    X2:=Tmp_X;
	 end if;
	 
	 if (Y1>Y2) then
	    Tmp_Y:=Y1;
	    Y1:=Y2;
	    Y2:=Tmp_Y;
	 end if;
	 
	 SetPenColor(Color);
	 DrawLine(X1,Y1,X2,Y2);
	 
	 exit when GetKeyState(KEY_A)=KEY_PRESSED ;
      end loop;
   end Test_Drawlines;
   
   procedure Test_FillRectangles is
      Val: RANDOM_VALUE;
      X1, X2, Tmp_X: Pixel_X;
      Y1, Y2, Tmp_Y: Pixel_Y;
      Color: Insa.Graphics.COLOR;
      
   begin 
      loop
	 Val:=GetValue/256;
	 Color:=Insa.Graphics.COLOR(val);
	 
	 Val:=GetValue;
	 X1:=(Val*PIXEL_X'Last)/RANDOM_VALUE'Last;
	 
	 Val:=GetValue;
	 X2:=(Val*PIXEL_X'Last)/RANDOM_VALUE'Last;
	 
	 Val:=GetValue;
	 Y1:=(Val*(PIXEL_Y'Last-16))/RANDOM_VALUE'Last;
	 
	 Val:=GetValue;
	 Y2:=(Val*(PIXEL_Y'Last-16))/RANDOM_VALUE'Last;
	 
	 Y1:=Y1+16;
	 Y2:=Y2+16;
	 
	 if (X1>X2) then
	    Tmp_X:=X1;
	    X1:=X2;
	    X2:=Tmp_X;
	 end if;
	 
	 if (Y1>Y2) then
	    Tmp_Y:=Y1;
	    Y1:=Y2;
	    Y2:=Tmp_Y;
	 end if;
	 
	 SetPenColor(Color);
	 DrawFillRectangle(X1,Y1,X2,Y2);
	 
	 exit when GetKeyState(KEY_A)=KEY_PRESSED ;
      end loop;
   end Test_FillRectangles;
   
   procedure Test_FillCircles is
      Val: RANDOM_VALUE;
      X: Pixel_X;
      Y: Pixel_Y;
      Radius: Integer;
      Color: Insa.Graphics.COLOR;
      
   begin 
      loop
	 Val:=GetValue/256;
	 Color:=Insa.Graphics.COLOR(val);
	 
	 Val:=GetValue;
	 X:=(Val*PIXEL_X'Last)/RANDOM_VALUE'Last;
	 
	 Val:=GetValue;
	 Y:=(Val*(PIXEL_Y'Last-16))/RANDOM_VALUE'Last;
	 
	 Val:=GetValue;
	 Radius:=(Val*Y)/RANDOM_VALUE'Last;
	 
	 Y:=Y+16;

	 SetPenColor(Color);
	 DrawFillCircle(X,Y,Radius);
	 
	 exit when GetKeyState(KEY_A)=KEY_PRESSED ;
      end loop;
   end Test_FillCircles;
   
   procedure Test_DrawBitmap is
	Sprites: array(1..1) of IMAGE;
   
   	INSA_Index:               constant INTEGER := 1;
   	Val: RANDOM_VALUE;
    X: Pixel_X;
    Y: Pixel_Y;
      
   	procedure ChargeSprites is
   	begin
		Sprites(INSA_Index):=UnpackImage(INSA_2016);
   	end ChargeSprites;

   begin
	ChargeSprites;
	
	loop
		Val:=GetValue;
		X:=(Val*(PIXEL_X'Last-Sprites(INSA_Index).Width))/RANDOM_VALUE'Last;
	 
		Val:=GetValue;
		Y:=(Val*(PIXEL_Y'Last-16-Sprites(INSA_Index).Height))/RANDOM_VALUE'Last;
		
		DrawImage(X,Y+16,Sprites(INSA_Index));
	exit when GetKeyState(KEY_A)=KEY_PRESSED ;
    end loop;
    
    FreeImage(Sprites(INSA_Index));
    
   end Test_DrawBitmap;

   procedure Test_DrawBitmapFromSRAM is
   	Val: RANDOM_VALUE;
    X: Pixel_X;
    Y: Pixel_Y;
      
   	procedure ChargeSprites is
   	begin
		UnpackImageToSRAM(INSA_2016,MEMORY_ADDRESS'First);
   	end ChargeSprites;

   begin
	ChargeSprites;
	
	loop
		Val:=GetValue;
		X:=(Val*(PIXEL_X'Last-INSA_2016.Width))/RANDOM_VALUE'Last;
	 
		Val:=GetValue;
		Y:=(Val*(PIXEL_Y'Last-16-INSA_2016.Height))/RANDOM_VALUE'Last;
		
		DrawImageFromSRAM(X,Y+16,INSA_2016.Width, INSA_2016.Height, MEMORY_ADDRESS'First);
	exit when GetKeyState(KEY_A)=KEY_PRESSED ;
    end loop;
   end Test_DrawBitmapFromSRAM;
   
   procedure Test_ScrollVertical is
   	D: Pixel_Y;
      
   	procedure ChargeSprites is
   	begin
		UnpackImageToSRAM(INSA_2016,MEMORY_ADDRESS'First);
   	end ChargeSprites;

   begin
	ChargeSprites;
	DrawImageFromSRAM((PIXEL_X'Last-INSA_2016.Width)/2,
	                  (PIXEL_Y'Last-INSA_2016.Height)/2,
	                  INSA_2016.Width, INSA_2016.Height, 
	                  MEMORY_ADDRESS'First);
	
	SetScrollWindow((PIXEL_X'Last-INSA_2016.Width)/2,
	                 16,
	                 INSA_2016.Width,
	                 PIXEL_Y'Last-16);
	                 
	D:=0;
	loop
		ScrollVertical(D);
		
		D:=D+1;
		if D>=(PIXEL_Y'Last-16) then
			D:=0;
		end if;
		
		Insa.SysDelay(20); -- Attente de 50 millisecondes
		
	exit when GetKeyState(KEY_A)=KEY_PRESSED ;
    end loop;
    
    ScrollVertical(0);
    
   end Test_ScrollVertical;
   
   procedure Test_ScrollHorizontal is
   	D: Pixel_X;
      
   	procedure ChargeSprites is
   	begin
		UnpackImageToSRAM(INSA_2016,MEMORY_ADDRESS'First);
   	end ChargeSprites;

   begin
	ChargeSprites;
	DrawImageFromSRAM((PIXEL_X'Last-INSA_2016.Width)/2,
	                  (PIXEL_Y'Last-INSA_2016.Height)/2,
	                  INSA_2016.Width, INSA_2016.Height, 
	                  MEMORY_ADDRESS'First);
	
	SetScrollWindow(0,
	                 (PIXEL_Y'Last-INSA_2016.Height)/2,
	                 PIXEL_X'Last,
	                 INSA_2016.Height);
	                 
	D:=0;
	loop
		ScrollHorizontal(D);
		
		D:=D+1;
		if D>=(PIXEL_X'Last) then
			D:=0;
		end if;
		
		Insa.SysDelay(20); -- Attente de 50 millisecondes
		
	exit when GetKeyState(KEY_A)=KEY_PRESSED ;
    end loop;
    
    ScrollHorizontal(0);
    
   end Test_ScrollHorizontal;
   
   procedure Test_BTE is
    sizeINSABitmap: NATURAL;
    sizePacmanBitmap: NATURAL;
    
    X: PIXEL_X;
    Y: PIXEL_Y;
    Last_X: PIXEL_X;
    
   	procedure ChargeSprites is
   	begin
		UnpackImageToSRAM(INSA_2016,MEMORY_ADDRESS'First);
		sizeINSABitmap := INSA_2016.Width*INSA_2016.Height;
		
		UnpackImageToSRAM(Pacman_Gauche,MEMORY_ADDRESS'First+sizeINSABitmap);
		sizePacmanBitmap := Pacman_Gauche.Width * Pacman_Gauche.Height;
   	end ChargeSprites;

   begin
	ChargeSprites;
	SetLayerDisplayMode(Display_Mode_Transparency);
	SetLayerTransparency(Transparency_100, Transparency_100);
	SetLayer(LAYER_2);
	SetPenColor(White);
	DrawFillRectangle(PIXEL_X'First, 16 , PIXEL_X'Last, PIXEL_Y'Last);

	DrawImageFromSRAM((PIXEL_X'Last-INSA_2016.Width)/2,
	                  (PIXEL_Y'Last-INSA_2016.Height)/2,
	                  INSA_2016.Width, INSA_2016.Height, 
	                  MEMORY_ADDRESS'First);
	
	DrawImageFromSRAM((PIXEL_X'Last-Pacman_Gauche.Width)/2,
	                  200,
	                  Pacman_Gauche.Width, Pacman_Gauche.Height, 
	                  MEMORY_ADDRESS'First+sizeINSABitmap);
	                  
	SetTransparentColorforBTE(Black);
	SetLayer(LAYER_1);
	ClearScreen(Black);                 
	                  
	Last_X:= (PIXEL_X'Last-Pacman_Gauche.Width)/2+20;   
	Y:= (PIXEL_Y'Last-Pacman_Gauche.Height)/2 ;
	X:=(PIXEL_X'Last-Pacman_Gauche.Width)/2;   
	SetForegroundColorforBTE(0,0,0);
	
	loop
		SetBTESource((PIXEL_X'Last-Pacman_Gauche.Width)/2, 200,  LAYER_2);
		
		Last_X:=X;
		if (X-Pacman_Gauche.Width)<PIXEL_X'First then
			
			X:=PIXEL_X'Last - Pacman_Gauche.Width;
			
		else
			X:=X-Pacman_Gauche.Width;
		end if;
		
		SetBTEDestination(X,Y, LAYER_1);
		SetBTESize(Pacman_Gauche.Width, Pacman_Gauche.Height);
		
		StartBTE(Block_Mode,Block_Mode, ROP_Function_12, BTE_Operation_2);
		
		SetBTEDestination(Last_X,Y, LAYER_1);
		StartBTE(Block_Mode,Block_Mode, ROP_Function_12, BTE_Operation_12);
		
		--Last_X:=X;
		Insa.SysDelay(100); -- Attente de 50 millisecondes
		
	exit when GetKeyState(KEY_A)=KEY_PRESSED ;
    end loop;
    
    SetLayer(LAYER_2);
	ClearScreen(Black);
	
	SetLayer(LAYER_1);
	ClearScreen(White);
    
   end Test_BTE;
   
	procedure Test_Audio is
		BufferAudio: AUDIO_BUFFER;
		Volume: BYTE;
		val: BYTE;
		Frequency: Integer;
		Compteur: FLOAT :=0.0;
		Tmp:Integer;
		
		Bar_Volume, Bar_Frequency: ProgressBar;
		
		type TEST_WAVE is array (Integer range <>) of BYTE;
		SinWave: constant TEST_WAVE (0..54) :=
		(128, 142, 156, 171, 184, 197, 209, 219, 229, 237, 244, 249, 253,
		  255, 255, 254, 251, 247, 241, 233, 224, 214, 203, 190, 177, 164,
		  149, 135, 121, 107, 92, 79, 66, 53, 42, 32, 23, 15, 9, 5, 2, 1,
		  1, 3, 7, 12, 19, 27, 37, 47, 59, 72, 85, 100, 114); 

		procedure BuildBuffer(volume: BYTE; Frequency: Integer) is
			Cnt: Integer;
			Increment: Float;
			tmp: INTEGER;
			
		begin 
			Increment:=44100.0/Float(Frequency);
			Increment:= 55.0/Increment;
			
			for Index in AUDIO_BUFFER'Range loop
				Cnt:= INTEGER(Float'Truncation(Compteur));
				Tmp:=INTEGER(SinWave(cnt))*INTEGER(volume);
				Tmp:=Tmp/255;
				BufferAudio(Index):=BYTE(Tmp);
				
				Compteur:=Compteur+Increment;
				if Compteur>=55.0 then
					Compteur:=Compteur-55.0;
				end if;
				
			end loop;
		end BuildBuffer;
		
	begin
		BuildBuffer(0,100);
		FillAudioBuffer(1, BufferAudio);
		FillAudioBuffer(2, BufferAudio);
		Tests_pak.AudioEvent_Flag:=False;
		Compteur:=0.0;
		
		CreateProgressBar(Bar_Volume,120,78,170,20);
		CreateProgressBar(Bar_Frequency,120,158,170,20);
		ProgressBarSetMaximum(Bar_Volume,255);
		ProgressBarSetMaximum(Bar_Frequency,15);
		
		SetTextColor(Black);
		SetBackColor(White);
		
		SetAudioCallback(tests_pak.Audio_Event'Access);
		StartAudio;
		
		loop 
			if Tests_pak.AudioEvent_Flag = True then
				Volume:= GetPotentiometerValue(Potentiometer_Left);
				Val:=GetPotentiometerValue(Potentiometer_Right);
				Val:=Val/16;
				Tmp:=INTEGER(Val)*5000;
				Tmp:=Tmp/15;
				Frequency:=Tmp;
				
				BuildBuffer(Volume, Frequency);
				FillAudioBuffer(Tests_pak.BufferNbr, BufferAudio);
				Tests_pak.AudioEvent_Flag:=False;
				
				SetTextColor(Black);
				SetBackColor(White);
				DrawString(3, 5, "Volume : ");
				ProgressBarChangeValue(Bar_Volume,INTEGER(volume));
				
				SetTextColor(Black);
				SetBackColor(White);
				DrawString(3, 10, "Frequency : ");
				ProgressBarChangeValue(Bar_Frequency,INTEGER(Val));
				
				Tmp:=INTEGER(Volume)*100;
				Tmp:=Tmp/255;
				
				SetTextColor(Black);
				SetBackColor(White);
				DrawString(3,7,Integer'Image(Tmp) & "%");
				DrawString(3,12,INTEGER'Image(Frequency) & " Hz");
				
			end if;
			
			exit when GetKeyState(KEY_A)=KEY_PRESSED ;
		end loop;
		
		StopAudio;
	end Test_Audio;
   
   procedure Test_External_Ram is
      Cnt, Tmp: MEMORY_BYTE;
      Addr: MEMORY_ADDRESS;
      State: Boolean;
      
      Buffer_Test: MEMORY_BUFFER(0..255);
   begin 
      
      SetTextColor(Black);
      SetBackColor(White);
      DrawString(5, 5, "Byte W/R :");
      DrawString(5, 8, "Block W/R :");
      
      State:=False;
      Cnt:=MEMORY_BYTE'First;
      
      -- 1st: Test ecternal memory on a Byte by Byte basis
      for Addr_Cnt in MEMORY_ADDRESS'Range loop
      -- Ada.Text_IO.Put_Line("Write " & MEMORY_BYTE'Image(Cnt) & " at " & Integer'Image(Addr_Cnt));
	 WriteByte(Addr_Cnt, Cnt);
	 
	 if Cnt=MEMORY_BYTE'Last then
	    Cnt:=MEMORY_BYTE'First;
	 else
	    Cnt:=Cnt+1;
	 end if;
      end loop;
      
      Cnt:=MEMORY_BYTE'First;
      
      for Addr_Cnt in MEMORY_ADDRESS'Range loop
      	 Tmp:=ReadByte(Addr_Cnt);
      -- Ada.Text_IO.Put_Line("Read " & MEMORY_BYTE'Image(Tmp) & " at " & Integer'Image(Addr_Cnt));
	 
	 if Tmp/=Cnt then
	    State:=True;
	 end if;
	 
	 if Cnt=MEMORY_BYTE'Last then
	    Cnt:=MEMORY_BYTE'First;
	 else
	    Cnt:=Cnt+1;
	 end if;

	 exit when State = True;
      end loop;
      
      if State = False then
	 SetTextColor(Green);
	 DrawString(17, 5, "OK");
      else
	 SetTextColor(Red);
	 DrawString(17, 5, "FAIL");
      end if;
      
      -- 2nd: Test the external memory block by block
      for I in Buffer_Test'Range loop
	 Buffer_Test(I):=MEMORY_BYTE'Val(I);
      end loop;

      Addr:=MEMORY_ADDRESS'First;
      
      loop
	 WriteByteBuffer(Addr, Buffer_Test);
	 
	 exit when Addr >= MEMORY_ADDRESS'Last-Buffer_Test'Length-1;
	 Addr:=Addr+Buffer_Test'Length;
      end loop;
      
      State:=False;
      Cnt:=MEMORY_BYTE'First;
      Addr:=MEMORY_ADDRESS'First;
      
      loop
	 for I in Buffer_Test'Range loop
	    Buffer_Test(I):=MEMORY_BYTE'First;
	 end loop;
	 
	 ReadByteBuffer(Addr, Buffer_Test);
	 
	 for I in Buffer_Test'Range loop
	    if Buffer_Test(I)/=MEMORY_BYTE'Val(I) then
	       State:= True;
	    end if;
	    
	    exit when State=True;
	 end loop;
	 
	 exit when Addr >= MEMORY_ADDRESS'Last-Buffer_Test'Length-1 or State=True; 
	 Addr:=Addr+Buffer_Test'Length;
      end loop;
      
      if State = False then
	 SetTextColor(Green);
	 DrawString(17, 8, "OK");
      else
	 SetTextColor(Red);
	 DrawString(17, 8, "FAIL");
      end if;
      
      -- end of test
      SetTextColor(Black);
      SetBackColor(White);
      DrawString(15, 11, "Press key A");
      
      loop 
	exit when GetKeyState(KEY_A)=KEY_PRESSED ;
      end loop;
   end Test_External_Ram;
   
begin
   Insa.Led.SetLed(Insa.Led.Led_On);
   
   loop
	  
	  Ada.Text_IO.Put_Line("Test Audio");
      CreateWindow("Audio", White, White, Black);
      Test_Audio;
      
      while (GetKeyState(KEY_A) = Key_Pressed) loop
      	 null;
      end loop;
      
      Ada.Text_IO.Put_Line("Test Keys");
      CreateWindow("Keys", White, White, Black);
      Test_Keys;
      
      while (GetKeyState(KEY_A) = Key_Pressed) loop
      	 null;
      end loop;
      
      Ada.Text_IO.Put_Line("Test Gyroscope");
      CreateWindow("Gyroscope", White, White, Black);
      Test_Gyroscope;
      
      while (GetKeyState(KEY_A) = Key_Pressed) loop
      	 null;
      end loop;
      
      Ada.Text_IO.Put_Line("Test Accelerometre");
      CreateWindow("Accelerometre", White, White, Black);
      Test_Accelerometre;
      
      while (GetKeyState(KEY_A) = Key_Pressed) loop
      	 null;
      end loop;
      
      Ada.Text_IO.Put_Line("Test Magnetometre");
      CreateWindow("Magnetometre", White, White, Black);
      Test_Magnetometre;
      
      while (GetKeyState(KEY_A) = Key_Pressed) loop
      	 null;
      end loop;
      
      Ada.Text_IO.Put_Line("Test Periodic Timer");
      CreateWindow("Periodic Timer", White, White, Black);
      Test_Periodic_Timer;
      
      while (GetKeyState(KEY_A) = Key_Pressed) loop
      	 null;
      end loop;
      
      Ada.Text_IO.Put_Line("Test DrawLines");
      CreateWindow("DrawLines", White, White, Black);
      Test_Drawlines;
      
      while (GetKeyState(KEY_A) = Key_Pressed) loop
      	 null;
      end loop; 
      
      Ada.Text_IO.Put_Line("Test DrawFillRectangle");
      CreateWindow("DrawFillRectangle", White, White, Black);
      Test_FillRectangles;
      
      while (GetKeyState(KEY_A) = Key_Pressed) loop
      	 null;
      end loop; 
      
      Ada.Text_IO.Put_Line("Test DrawFillCircle");
      CreateWindow("DrawFillCircle", White, White, Black);
      Test_FillCircles;
      
      while (GetKeyState(KEY_A) = Key_Pressed) loop
      	 null;
      end loop; 
      
      Ada.Text_IO.Put_Line("Test_DrawBitmap");
      CreateWindow("DrawBitmap", White, White, Black);
      Test_DrawBitmap;
      
      while (GetKeyState(KEY_A) = Key_Pressed) loop
      	 null;
      end loop; 
      
      Ada.Text_IO.Put_Line("Test_DrawBitmapFromSRAM");
      CreateWindow("DrawBitmapFromSRAM", White, White, Black);
      Test_DrawBitmapFromSRAM;
      
      while (GetKeyState(KEY_A) = Key_Pressed) loop
      	 null;
      end loop; 
      
      Ada.Text_IO.Put_Line("Test_ScrollVertical");
      CreateWindow("ScrollVertical", White, White, Black);
      Test_ScrollVertical;
      
      while (GetKeyState(KEY_A) = Key_Pressed) loop
      	 null;
      end loop; 
      
      while (GetKeyState(KEY_A) = Key_Pressed) loop
      	 null;
      end loop; 
      
      Ada.Text_IO.Put_Line("Test_ScrollHorizontal");
      CreateWindow("ScrollHorizontal", White, White, Black);
      Test_ScrollHorizontal;
      
      while (GetKeyState(KEY_A) = Key_Pressed) loop
      	 null;
      end loop; 
      
      SetLayer(LAYER_2);
      Ada.Text_IO.Put_Line("Test_BTE");
      CreateWindow("BTE", White, White, Black);
      Test_BTE;
      
      while (GetKeyState(KEY_A) = Key_Pressed) loop
      	 null;
      end loop; 
      
      Ada.Text_IO.Put_Line("Test External Memory");
      CreateWindow("External Memory", White, White, Black);
      Test_External_RAM;
      
      while (GetKeyState(KEY_A) = Key_Pressed) loop
	 null;
      end loop;
   end loop;

end Tests;
