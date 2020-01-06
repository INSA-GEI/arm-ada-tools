pragma Ada_95;

with Insa.Graphics;
use Insa.Graphics;

package body Tests_pak is
   
	procedure Timer_Event is	 
	begin
		Compteur_100ms:= Compteur_100ms +1;
		if Compteur_100ms=10 then
			Compteur_100ms:=0;
			Compteur:=Compteur+1;
			-- DrawString(12, 6, Integer'Image(Compteur));
			Event_Flag:=1;
		end if;
      
      --  if (Compteur = Integer'Last) then 
      --  	 Compteur:= 0;
      --  else
      --  	 Compteur:= Compteur +1;
      --  end if;
      
      --  Event_Flag := True;
	end Timer_Event; 
	
	procedure Audio_Event(buffer_nbr: BUFFER_NUMBER) is	 
	begin
		BufferNbr:=buffer_nbr;
		AudioEvent_Flag:= True;
		
	end Audio_Event;

end Tests_pak;
