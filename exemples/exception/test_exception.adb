with Insa;
with Insa.Graphics;
with Insa.Keys;
with Ada.Text_IO;
with pac_exception;

procedure Test_Exception is
	Key_A_State: Insa.Keys.KEY_STATE := Insa.Keys.Key_Released;
	Key_B_State: Insa.Keys.KEY_STATE := Insa.Keys.Key_Released;
	Key_C_State: Insa.Keys.KEY_STATE := Insa.Keys.Key_Released;
begin

	Ada.Text_IO.Put("Salut");
	-- Configure la couleur du texte: noir sur fond blanc
	Insa.Graphics.SetTextColor(Insa.Graphics.Black);
	Insa.Graphics.SetBackColor(Insa.Graphics.White);
	
	-- Ecrit sur l'ecran
	Insa.Graphics.DrawString(1,4,"Press A for uncaught exception");
	Insa.Graphics.DrawString(1,5,"Press B for caught exception");
	Insa.Graphics.DrawString(1,6,"Press Center for div by 0 exception");
		
	while (Key_A_State = Insa.Keys.Key_Released) and 
	      (Key_B_State = Insa.Keys.Key_Released) and
		  (Key_C_State = Insa.Keys.Key_Released) loop
		Key_A_State := Insa.Keys.GetKeyState(Insa.Keys.Key_A);
		Key_B_State := Insa.Keys.GetKeyState(Insa.Keys.Key_B);
		Key_C_State := Insa.Keys.GetKeyState(Insa.Keys.Key_Center);
	end loop;

	if Key_A_State = Insa.Keys.Key_Pressed then
		-- Attente que la touche soit relach�e
		while Key_A_State = Insa.Keys.Key_Pressed loop
			Key_A_State := Insa.Keys.GetKeyState(Insa.Keys.Key_A);
		end loop;
		
		-- Leve une exception non intercept�e
		pac_exception.raise_array;
	end if;
	
	if Key_B_State = Insa.Keys.Key_Pressed then
		-- Attente que la touche soit relach�e
		while Key_B_State = Insa.Keys.Key_Pressed loop
			Key_B_State := Insa.Keys.GetKeyState(Insa.Keys.Key_B);
		end loop;
		
		-- Leve une exception intercept�e
		begin
			pac_exception.raise_simple;
		exception
			when Constraint_Error =>
				Insa.Graphics.DrawString(1,8,"Caught Constraint_Error exception");
			when others =>
				Insa.Graphics.DrawString(1,8,"Caught unknown exception");
		end;
	end if;
	
	if Key_C_State = Insa.Keys.Key_Pressed then
		-- Attente que la touche soit relach�e
		while Key_C_State = Insa.Keys.Key_Pressed loop
			Key_C_State := Insa.Keys.GetKeyState(Insa.Keys.Key_Center);
		end loop;
		
		-- Leve une exception division par 0
		pac_exception.raise_div_by_zero;
	end if;
end Test_Exception;
