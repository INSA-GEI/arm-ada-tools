-- Tetris main application

with Insa;
with Insa.Graphics;
with Insa.Graphics.Advanced;
with Insa.Graphics.Images;
with Insa.Keys;
with Insa.Timer;

use Insa;
use Insa.Graphics.Advanced;
use Insa.Graphics.Images;
use Insa.Keys;

with Game;
with Game.Tetrominos;
with Game.Sprites;

use Game;
use Game.Tetrominos;
use Game.Sprites;

procedure Tetris is
  Score: Natural;
  Level: Natural;
  
  pos_x, pos_y: Integer;
  keyList, previousKeyList: KEY_LIST := (others => 0);
  orientation,next_orientation: Natural;
  tetromino: Natural;
  GravityKey: boolean := false;
  GravityCounter: Natural := 0;

  function Gravity return boolean is
    GravityLevelArray : constant array(0..10) of Natural := 
      (15,13,11,9,7,6,5,4,3,2,1);
    GravityLevel:Natural;
    Status:Boolean:=false;
  begin
    if level<=10 then
      GravityLevel := GravityLevelArray(level);
    else
      GravityLevel := GravityLevelArray(10);
    end if;

    GravityCounter:=GravityCounter+1;

    if GravityCounter>=GravityLevel then
      Status := True;
      GravityCounter:=0;
    end if;

    return Status;
  end Gravity;

  procedure UpdateLevel is
  begin
    level := score/10;
  end UpdateLevel;

  procedure UpdateScore(lines: Natural) is
  begin
    case lines is
      when 0 => null;
      when 1 => score:= score+1;
      when 2 => score:= score+3;
      when 3 => score:= score+8;
      when others => score:= score+5*lines;
    end case;
  
    UpdateLevel;
  end UpdateScore;

  procedure UpdateScoreAndPit is
  begin 
    -- le tetromino ne peut pas descendre plus bas
    -- ecrire le tetromino dans la table
    UpdatePit(pos_x, pos_y, orientation, tetromino);
    DrawTetromino(pos_x, pos_y, orientation, tetromino);

    -- Verifier que des lignes n'ont pas été terminées et incrementer le score
    if CountCompletedLines /=0 then
      UpdateScore(CountCompletedLines);
      UpdatePit;
      Writescore(Score,Level);
    end if;

    -- tirer le nouveau tetromino
    pos_x:=PIT_WIDTH/2-2;
    pos_y:=0;
    orientation:=1;
    tetromino:=GetNextTetromino;

    if CheckTetromino(pos_x, pos_y, orientation, tetromino) = true then
      DrawTetromino(pos_x, pos_y, orientation, tetromino);
    elsif CheckTetromino(pos_x, pos_y+1, orientation, tetromino) = true then
      pos_y:=pos_y+1;
      DrawTetromino(pos_x, pos_y, orientation, tetromino);
    else 
      ShowGameOver;

      keyList:=GetAllKeys;
      TimeEvent:= False;
      Score:=0;
      Level:=0;
      pitArray:=(others => (others => 0));

      ShowMainGame;
      Writescore(Score,Level);

      if CheckTetromino(pos_x, pos_y, orientation, tetromino) = true then
        DrawTetromino(pos_x, pos_y, orientation, tetromino);
      else 
        pos_y:=pos_y+1;
        DrawTetromino(pos_x, pos_y, orientation, tetromino);
      end if;

      PlayBGM; 
    end if;
  end UpdateScoreAndPit;

begin
  TimeEvent:= False;
  Score:=0;
  Level:=0;
  
  Initialize;
  ShowTitleScreen;

  ShowMainGame;
  Writescore(Score,Level);
  
  SettimerCallback;
  Timer.Starttimer;

  pos_x:=PIT_WIDTH/2-2;
  pos_y:=0;
  orientation:=1;
  tetromino:=GetNextTetromino;

  if CheckTetromino(pos_x, pos_y, orientation, tetromino) = true then
    DrawTetromino(pos_x, pos_y, orientation, tetromino);
  else 
    pos_y:=pos_y+1;
    DrawTetromino(pos_x, pos_y, orientation, tetromino);
  end if;

  loop 
    if Timeevent = True then
      Timeevent := False; 
      GravityKey := Gravity;
      PlayBGM;
    end if;

    keyList:=GetAllKeys;
    if keyList.Left /= previousKeyList.Left and keyList.Left =1 then
      if CheckTetromino(pos_x-1, pos_y, orientation, tetromino) = true then
        Cleartetromino(pos_x, pos_y, orientation, tetromino);
        pos_x := pos_x -1;
        DrawTetromino(pos_x, pos_y, orientation, tetromino);
      end if;
    end if;

    if keyList.Right /= previousKeyList.Right and keyList.Right =1 then
      if CheckTetromino(pos_x+1, pos_y, orientation, tetromino) = true then
        Cleartetromino(pos_x, pos_y, orientation, tetromino);
        pos_x := pos_x +1;
        DrawTetromino(pos_x, pos_y, orientation, tetromino);
      end if;
    end if;

    if (keyList.Down /= previousKeyList.Down and keyList.Down =1) or (GravityKey = True) then
      GravityKey := false;

      if CheckTetromino(pos_x, pos_y+1, orientation, tetromino) = true then
        Cleartetromino(pos_x, pos_y, orientation, tetromino);
        pos_y := pos_y +1;
        DrawTetromino(pos_x, pos_y, orientation, tetromino);
      else
        UpdateScoreAndPit;
      end if;
    end if;

    if keyList.A /= previousKeyList.A and keyList.A =1 then
      if orientation =4 then
        next_orientation:=1;
      else
        next_orientation:=orientation+1;
      end if;

      if CheckTetromino(pos_x, pos_y, next_orientation, tetromino) = true then
        Cleartetromino(pos_x, pos_y, orientation, tetromino);
        DrawTetromino(pos_x, pos_y, next_orientation, tetromino);
        orientation:= next_orientation;
      end if;
    end if; 

    if keyList.B /= previousKeyList.B and keyList.B =1 then
      if orientation =1 then
        next_orientation:=4;
      else
        next_orientation:=orientation-1;
      end if;

      if CheckTetromino(pos_x, pos_y, next_orientation, tetromino) = true then
        Cleartetromino(pos_x, pos_y, orientation, tetromino);
        DrawTetromino(pos_x, pos_y, next_orientation, tetromino);
        orientation:= next_orientation;
      end if;
    end if; 
    
    if keyList.Center /= previousKeyList.Center and keyList.Center =1 then
      Cleartetromino(pos_x, pos_y, orientation, tetromino);

      while CheckTetromino(pos_x, pos_y+1, orientation, tetromino) = true loop
        pos_y := pos_y +1;
      end loop;

      UpdateScoreAndPit;
    end if;

    previousKeyList:=keyList;
  end loop;
   
end Tetris;
