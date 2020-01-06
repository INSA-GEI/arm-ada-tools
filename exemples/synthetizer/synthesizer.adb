with Insa;
with Insa.Graphics;
with Insa.Graphics.UI;
with Insa.Keys;
with Insa.Timer;
with Insa.Audio.Synthesizer;
with Ada.Text_IO;

use Insa;
use Insa.Graphics;
use Insa.Graphics.UI;
use Insa.Keys;
use Insa.Audio.Synthesizer;

with Ressources;
use Ressources;

procedure Synthesizer is

	procedure Test_Synthesizer is
				
		Bar_Volume, Bar_Melody: ProgressBar;
        volume: BYTE;
        melodyrunning: INTEGER;
        melody_pos: BYTE;

		status: SYNTH_STATUS;
		stat_MELODY: MELODY_STATUS;

		i: INTEGER;
    begin

		-- Mise en place de l'interface: une barre de progression pour le volume principal
		-- Une barre de progression pour la musique
        SetTextColor(Black);
        SetBackColor(White);
        DrawString(15, 11, "Press key A");

        DrawString(10, 9, "Press B to play music");
        DrawString(3, 5, "Vol : ");
        DrawString(3, 7, "Stop : ");

		-- Demarrage du synthe
        if SYNTH_Start /=SYNTH_SUCCESS then
			raise CONSTRAINT_ERROR;
		end if;

        melodyrunning:=0;
        melody_pos:=0;

		CreateProgressBar(Bar_Volume,120,78,170,20);
		CreateProgressBar(Bar_Melody,120,115,170,20);
		ProgressBarSetMaximum(Bar_Volume,255);
		ProgressBarSetMaximum(Bar_Melody,255);

        while (GetKeyState(KEY_A) /= KEY_PRESSED) loop
            volume := GetPotentiometerValue(Potentiometer_Left); -- Recupere le volume 
			ProgressBarChangeValue(Bar_Volume,INTEGER(volume));

            if melodyrunning = 1 then
				-- Si la musique est en train d'etre jouée, recuperation de la position (entre 0 et 255)
                melody_pos:=MELODY_GetPosition;
				ProgressBarChangeValue(Bar_Melody,INTEGER(melody_pos)); -- et mise a jour de la barre de progression

                if melody_pos = 255 then  -- Quand on arrive à 100 % (255), la melodie est terminée, ras des indicateurs
                    melodyrunning:=0;
                    melody_pos:=0;
					ProgressBarChangeValue(Bar_Melody,INTEGER(melody_pos));

                    SetTextColor(Black);
                    SetBackColor(White);
                    DrawString(3, 7, "Stop : ");
                end if;
            end if;

            if GetKeyState(KEY_B) = KEY_PRESSED then
				-- lancement de la musique
                if melodyrunning=0 then
                    melodyrunning:=1;
                    melody_pos:=0;

                    SetTextColor(Black);
                    SetBackColor(White);
                    DrawString(3, 7, "Play : ");

					-- reglage du volume principal
                    status:=SYNTH_SetMainVolume(INTEGER(volume));

					i:=0;
					while (i<4) loop
						status:= SYNTH_SetVolume(i, 100);               -- Reglage du volume par canal
    					status:= SYNTH_SetInstrument(i, Guitar_Access);	-- Parametrage de l'instrument à utiliser par canal
						i:=i+1;
					end loop;

                    stat_MELODY:=MELODY_Start(ymca_Melody,ymca.music_length);   -- Demarrage de la musique
                end if;
            end if;
        end loop;

		-- Avant de partir, arret de la melodie
        stat_MELODY:= MELODY_Stop;

		-- et arret du synthe
        status:= SYNTH_Stop;
    end Test_Synthesizer;
   
begin
 
	-- Ada.Text_IO.Put_Line("Test Synthesizer");
    CreateWindow("Test Synthesizer", White, White, Black);
    Test_Synthesizer;
      
    while (GetKeyState(KEY_A) = Key_Pressed) loop
      	null;
    end loop;

end Synthesizer;
