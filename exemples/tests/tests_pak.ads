pragma Ada_95;

with Insa.Audio;
use Insa.Audio;

package Tests_pak is
   
    -- Variables globales utilisées pour le test Periodic_Timer
    Compteur: Integer :=0;
    Compteur_100ms : Integer :=0;
    Event_Flag: integer;
	AudioEvent_Flag: Boolean;
	BufferNbr: BUFFER_NUMBER;
	
    procedure Timer_Event;

	procedure Audio_Event(buffer_nbr: BUFFER_NUMBER);
end Tests_pak;
