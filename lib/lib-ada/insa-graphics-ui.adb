-- Package Insa.Graphics.UI
-- Provide several widgets for creating GUI
--

pragma Ada_95;

with Insa.Graphics;

package body Insa.Graphics.UI is
   pragma Warnings (Off);
   
   procedure DrawProgressBar(x: PIXEL_X; y: PIXEL_Y; w: PIXEL_X; h: PIXEL_Y; val: PROGRESS_BAR_RANGE; maxval: PROGRESS_BAR_RANGE) is
      Length: INTEGER;
      Local_Value : PROGRESS_BAR_RANGE;
   begin
      -- Dessin du cadre 
      Insa.Graphics.SetTextColor(Insa.Graphics.Black);
      Insa.Graphics.DrawLine(x,y,x+w,y);
      Insa.Graphics.DrawLine(x,y,x,y+h);
      Insa.Graphics.DrawLine(x+w,y,x+w,y+h);
      Insa.Graphics.DrawLine(x,y+h,x+w,y+h);
      
      Local_Value := Val;
      
      if (local_value>maxval) then
	 local_value := maxval;
      end if;
      
      -- Dessin du remplissage 
      Length := (local_value * (w-4)) / maxval;
      
      Insa.Graphics.SetTextColor(Insa.Graphics.Blue);
      Insa.Graphics.DrawFillRectangle(x+2, y+2, (x+2)+Length , (y+2)+h-4);
      
      Insa.Graphics.SetTextColor(Insa.Graphics.White);
      Insa.Graphics.DrawFillRectangle(x+2+length+1, y+2, (x+2+Length+1)+(w-4)-Length, (y+2)+ h-4);
   end DrawProgressBar;
   
   procedure DrawCenterBar(x: PIXEL_X; y: PIXEL_Y; w: PIXEL_X; h: PIXEL_Y; val: INTEGER; maxval: POSITIVE);
     pragma Import (C, DrawCenterBar, "GUI_CenterBar");
   
   --  procedure DrawCenterBar(x: PIXEL_X; y: PIXEL_Y; w: PIXEL_X; h: PIXEL_Y; val: INTEGER; maxval: POSITIVE) is
   --     Length1: INTEGER;
   --     Length2: INTEGER;
   --     Length: INTEGER;
   --     Local_Value : INTEGER;
   --  begin
   --     -- Dessin du cadre
   --     Insa.Graphics.SetTextColor(Insa.Graphics.Black);
   --     Insa.Graphics.DrawLine(x,y,x+w,y);
   --     Insa.Graphics.DrawLine(x,y,x,y+h);
   --     Insa.Graphics.DrawLine(x+w,y,x+w,y+h);
   --     Insa.Graphics.DrawLine(x,y+h,x+w,y+h);
      
   --     if Val >= 0 and val >= Maxval then
   --  	Local_Value := maxval-1;
   --     end if;
	  
   --     if Val < 0 and (-val) >= maxval then
   --  	Local_Value := -(maxval-1);
   --     end if;
	  
   --     -- Dessin du remplissage
   --     length1 := (w-4)/2;
   --     length2 := (Local_Value * (w-4)) / maxval;
   --     length2 := length2/2;
   --     length := length1 + length2;
      
   --     Insa.Graphics.SetTextColor(Insa.Graphics.Blue);
   --     Insa.Graphics.DrawFillRectangle(x+2, y+2, (x+2)+ length, (y+2) + h-4);
      
   --     Insa.Graphics.SetTextColor(Insa.Graphics.White);
   --     Insa.Graphics.DrawFillRectangle(x+2+length+1, y+2, (x+2+length+1)+(w-4)-length, (y+2)+h-4);
   --  end DrawCenterBar;
   
   procedure CreateProgressBar(bar: in out ProgressBar; x: PIXEL_X; y: PIXEL_Y; w: PIXEL_X; h: PIXEL_Y) is
      begin
	bar.x :=x;
	bar.y :=y;
 	bar.w :=w;
	bar.h :=h;

	bar.val:=0;
	bar.maxval:=PROGRESS_BAR_RANGE'LAST;

	DrawProgressBar(bar.x, bar.y, bar.w, bar.h, bar.val, bar.maxval);
      end CreateProgressBar;

   procedure ProgressBarSetMaximum(bar: in out ProgressBar; maxval: PROGRESS_BAR_RANGE) is
      begin
	if bar.w=0 then
           -- progress bar non initialisée
	   raise OBJECT_NOT_INITIALIZED;
	end if;

	bar.maxval:=maxval;
	if bar.val > bar.maxval then
	   bar.val := bar.maxval;
	end if;

	DrawProgressBar(bar.x, bar.y, bar.w, bar.h, bar.val, bar.maxval);
      end ProgressBarSetMaximum;

   procedure ProgressBarChangeValue(bar: in out ProgressBar; val: PROGRESS_BAR_RANGE) is
      begin
	if bar.w=0 then
           -- progress bar non initialisée
	   raise OBJECT_NOT_INITIALIZED;
	end if;
	
	if Bar.Val /= Val then
	   bar.val:=val;
	   if bar.val > bar.maxval then
	      bar.val := bar.maxval;
	   end if;

	   DrawProgressBar(bar.x, bar.y, bar.w, bar.h, bar.val, bar.maxval);
	end if;
	
      end ProgressBarChangeValue;

   -- procedures pour les center bars
   procedure CreateCenterBar(bar: in out CenterBar; x: PIXEL_X; y: PIXEL_Y; w: PIXEL_X; h: PIXEL_Y) is
      begin
	bar.x :=x;
	bar.y :=y;
 	bar.w :=w;
	bar.h :=h;

	bar.val:=0;
	bar.maxval:=CENTER_BAR_RANGE'LAST;

	DrawCenterBar(bar.x, bar.y, bar.w, bar.h, bar.val, bar.maxval);
      end CreateCenterBar;

   procedure CenterBarSetMaximum(bar: in out CenterBar; maxval: CENTER_BAR_RANGE) is
      begin
	if bar.w=0 then
           -- progress bar non initialisée
	   raise OBJECT_NOT_INITIALIZED;
	end if;

	bar.maxval:=maxval;
	if bar.val > bar.maxval then
	   bar.val := bar.maxval;
	end if;

	if bar.val < -bar.maxval then
	   bar.val := -bar.maxval;
	end if;

	DrawCenterBar(bar.x, bar.y, bar.w, bar.h, bar.val, bar.maxval);
      end CenterBarSetMaximum;

   procedure CenterBarChangeValue(bar: in out CenterBar; val: INTEGER) is
      begin
	if bar.w=0 then
           -- progress bar non initialisée
	   raise OBJECT_NOT_INITIALIZED;
	end if;
	
	if Bar.Val /= Val then
	   bar.val:=val;
	   if bar.val > bar.maxval then
	      bar.val := bar.maxval;
	   end if;

	   if bar.val < -bar.maxval then
	      bar.val := -bar.maxval;
	   end if;

	   DrawCenterBar(bar.x, bar.y, bar.w, bar.h, bar.val, bar.maxval);
	end if;
      end CenterBarChangeValue;
      
      procedure CreateWindow(Title: String; Background: COLOR; TitlebarText: COLOR; TitlebarBgnd: COLOR) is
	Blackbkg: constant String := "                                        ";
      begin
	Insa.Graphics.ClearScreen(background);
	Insa.Graphics.SetTextColor(titlebarText);
	Insa.Graphics.SetBackColor(titlebarBgnd);
	Insa.Graphics.DrawString(0,0,blackbkg);
	Insa.Graphics.DrawString((40-Title'length)/2, 0, title);
      end CreateWindow;
      
end Insa.Graphics.UI;
