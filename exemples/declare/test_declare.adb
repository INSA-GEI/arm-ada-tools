with Insa;
with Insa.Graphics;
with Insa.Keys;

with Unchecked_Deallocation;

procedure Test_Declare is
	
	type TEST_ARRAY is array (NATURAL range <>) of INTEGER;
	type TEST_ARRAY_ACCESS is access TEST_ARRAY;
	
	Key_A_State: Insa.Keys.KEY_STATE := Insa.Keys.Key_Released;
	
	procedure Free is new Unchecked_Deallocation(TEST_ARRAY,  TEST_ARRAY_ACCESS);
begin

	-- Configure la couleur du texte: noir sur fond blanc
	Insa.Graphics.SetTextColor(Insa.Graphics.Black);
	Insa.Graphics.SetBackColor(Insa.Graphics.White);
	
	-- Ecrit sur l'ecran
	Insa.Graphics.DrawString(1,3,"Press A for declaring new array");
	
	-- On attend l'appui de la touche A
	while Key_A_State = Insa.Keys.Key_Released loop
		Key_A_State := Insa.Keys.GetKeyState(Insa.Keys.Key_A);
	end loop;
	
	-- Puis son relachement
	while Key_A_State = Insa.Keys.Key_Pressed loop
		Key_A_State := Insa.Keys.GetKeyState(Insa.Keys.Key_A);
	end loop;

Alloc:
	declare
		tab: TEST_ARRAY_ACCESS;
		index: NATURAL := 1;
	begin
		tab := new TEST_ARRAY(1 .. 10);
		
		Insa.Graphics.DrawString(1,5,"Array declared");

		while index < 11 loop
			tab(index):=index;
			index := index +1;
		end loop;
		
		index:=1;
		while index < 11 loop
			Insa.Graphics.DrawString((3*index)-2,7,INTEGER'IMAGE(tab(index)) & " ");
			
			index := index +1;
		end loop;
		
		Free(tab);
	end Alloc;
	
end Test_Declare;
