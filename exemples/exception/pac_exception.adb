package body pac_exception is
	
	Dummy_Array : array (1..10) of INTEGER;
	count: INTEGER;
	
	procedure raise_simple is
	begin
		raise Constraint_Error;
	end raise_simple;
	
	procedure raise_array is	 
	begin
		count :=1;
		
		while count <12 loop
			Dummy_Array(count) := count;
			count := count +1;
		end loop;
	end raise_array;
	
	procedure raise_div_by_zero is
		A,B,C: Integer := 1;
	begin
		while B> -1 loop
			C:= A / B;
			
			B:= B-1;
		end loop;
	end raise_div_by_zero;
end pac_exception;
