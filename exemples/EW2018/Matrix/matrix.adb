with Insa;
with Insa.Graphics;

use Insa;
use Insa.Graphics;

with Insa.Random_Number;

with Insa.Keys;
use Insa.Keys;

with ada.text_io;

procedure Matrix is

  MAX_NEW_DROP:     constant Natural := 5;
  MAX_TOTAL_DROPS:  constant Natural := 35;

  dropColor : array (0..8) of COLOR := 
  (
    16#00#, 16#04#, 16#08#, 16#0C#, 16#10#,
    16#14#, 16#18#, 16#1C#, 16#FF#
  );

  type MATRIX_RAIN_ELEMENT is record
    value: Natural;
    color: Integer;
  end record; 

  type MATRIX_RAIN_ARRAY is array (0..TEXT_X'Last,0..TEXT_Y'Last) of MATRIX_RAIN_ELEMENT;
  matrixRain: MATRIX_RAIN_ARRAY := (others => (others => (0,0)));

  currentDropQuantity: Natural:=0;

  procedure WriteChar(x: Natural; y: Natural) is 
  begin   
    SetTextColor(dropColor(matrixRain(x,y).color));
    if matrixRain(x,y).value=0 then
      DrawString(x, y, "0");
    elsif matrixRain(x,y).value=1 then
      DrawString(x, y, "1");
    else
      DrawString(x, y, " ");
    end if;
  end WriteChar;

  function DrawValue return Natural is
    val: Insa.Random_Number.RANDOM_VALUE;
  begin
    val := Insa.Random_Number.GetValue;

    -- renvoi comme valeur soit 0 soit 1
    if (val mod 2)=0 then return 0;
    else return 1;
    end if;
  end DrawValue;

  function DrawColumn return Natural is
    val: Insa.Random_Number.RANDOM_VALUE;
    column: Natural;
  begin
    val := Insa.Random_Number.GetValue;

    -- renvoi une valeur entre 0 et TEXT_X'Last
    column := val mod (TEXT_X'Last+1);
    return column;
  end DrawColumn;

  function DrawDropNumber return Natural is
    val: Insa.Random_Number.RANDOM_VALUE;
    dropNumber: Natural;
  begin
    val := Insa.Random_Number.GetValue;

    -- renvoi une valeur entre 0 et MAX_NEW_DROP
    dropNumber := val mod (MAX_NEW_DROP+1); 
    return dropNumber;
  end DrawDropNumber;

  procedure updateScreen is
  begin
    for y in 0..TEXT_Y'Last loop
      for x in 0..TEXT_X'Last loop
        if matrixRain(x,y).color /= 0 then
          matrixRain(x,y).color:=matrixRain(x,y).color-1;
          WriteChar(x,y);
        end if;
      end loop;
    end loop;
  end updateScreen;

  procedure moveDrops is
  begin
    SetTextColor(dropColor(dropColor'Last));
    currentDropQuantity:=0;

    for y in reverse 0..TEXT_Y'Last loop
      for x in 0..TEXT_X'Last loop
        if matrixRain(x,y).color = (dropColor'Last-1) then
          if y<=(TEXT_Y'Last-1) then
            currentDropQuantity:=currentDropQuantity+1;
            matrixRain(x, y+1):=(DrawValue,dropColor'Last);
            WriteChar(x,y+1);
          end if;
        end if;
      end loop;
    end loop;
  end moveDrops;

  procedure addDrops is
    quantity: Natural;
    column: Natural;
  begin
    quantity:=DrawDropNumber;
    SetTextColor(dropColor(dropColor'Last));

    if currentDropQuantity + quantity > MAX_TOTAL_DROPS then
      quantity := MAX_TOTAL_DROPS-currentDropQuantity;
    end if;

    for i in 1..quantity loop
      column := DrawColumn;
      matrixRain(column, 0):= (DrawValue,dropColor'Last);
      WriteChar(column,0);
    end loop;

    currentDropQuantity:=currentDropQuantity+quantity;
  end addDrops;

begin
  SetTextColor(Black);
  SetBackColor(Black);
  DrawFillRectangle(0,0,PIXEL_X'Last, PIXEL_Y'Last);
  SetTextColor(dropColor(dropColor'last));

  while true loop
    updateScreen;

    -- while GetKeyState(Key_A)/=Key_Pressed loop
    --  null;
    --end loop;

    --while GetKeyState(Key_A)=Key_Pressed loop
    --  null;
    --end loop;

    moveDrops;

    

    addDrops;

    

    SysDelay(100);
  end loop;
end Matrix;