with Game.Sprites;
use Game.Sprites;

with Game;
use Game;

with Insa.Graphics;
with Insa.Graphics.Images;
use Insa.Graphics;
use Insa.Graphics.Images;

package body Game.Tetrominos is

  procedure DrawTile(x: NATURAL; y: NATURAL; tile: NATURAL) is
  begin
    if x<1 or x>PIT_WIDTH then
      raise constraint_error;
    end if;

    if y<1 or y>PIT_HEIGHT then
      raise constraint_error;
    end if;

    if tile<Tuile_Bleu or tile>Tuile_Grise then
      raise constraint_error;
    end if;

    DrawImage(PIT_ORIGIN_X+12*(x-1), PIT_ORIGIN_Y + 12*(y-1), sprite(tile));
  end DrawTile;

  procedure ClearTile(x: NATURAL; y: NATURAL) is
  begin
    if x<1 or x>PIT_WIDTH then
      raise constraint_error;
    end if;

    if y<1 or y>PIT_HEIGHT then
      raise constraint_error;
    end if;

    DrawImage(PIT_ORIGIN_X+12*(x-1), PIT_ORIGIN_Y + 12*(y-1), sprite(Tuile_Transparente));
  end ClearTile;

  function CheckTetromino(x: Integer; y: Integer; orientation: NATURAL; tetromino: NATURAL) return Boolean is
    status: Boolean := True;
  begin
    for column in NATURAL range 1..4 loop
      for line in NATURAL range 1..4 loop
        if TetrisForm(orientation, tetromino, column, line) = 1 then
          if pitArray(x+column-1, y+line-1) /=0 then
            status := False;
          end if;
        end if;
      end loop;
    end loop;

    return status;
  exception
    when others => return false;
  end CheckTetromino;

  procedure DrawTetromino(x: Integer; y: Integer; orientation: NATURAL; tetromino: NATURAL) is
  begin
    for column in NATURAL range 1..4 loop
      for line in NATURAL range 1..4 loop
        if TetrisForm(orientation, tetromino, column, line) = 1 then
          DrawTile(x+column-1, y+line-1, tetromino);
        end if;
      end loop;
    end loop;
  end DrawTetromino;

  procedure ClearTetromino(x: Integer; y: Integer; orientation: NATURAL; tetromino: NATURAL) is
  begin
    for column in NATURAL range 1..4 loop
      for line in NATURAL range 1..4 loop
        if TetrisForm(orientation, tetromino, column, line) = 1 then
          ClearTile(x+column-1, y+line-1);
        end if;
      end loop;
    end loop;
  end ClearTetromino;

  procedure UpdatePit(x: Integer; y: Integer; orientation: NATURAL; tetromino: NATURAL) is
  begin
    for column in NATURAL range 1..4 loop
      for line in NATURAL range 1..4 loop
        if TetrisForm(orientation, tetromino, column, line) = 1 then
          pitArray(x+column-1, y+line-1) :=tetromino; 
        end if;
      end loop;
    end loop;
  end UpdatePit;

  procedure UpdatePit is
  begin
    for currentLine in NATURAL range 2..PIT_HEIGHT loop
      if LineCompleted(currentLine)= true then
        for line in reverse NATURAL range 2..currentLine loop
          for column in NATURAL range 1..PIT_WIDTH loop
            pitArray(column, line) := pitArray(column, line-1); 
          end loop;
        end loop;
      end if;
    end loop;

    for column in NATURAL range 1..PIT_WIDTH loop
      pitArray(column, 1) := 0; 
    end loop;

    RedrawPit;
  end UpdatePit;

  procedure RedrawPit is
  begin
    for line in NATURAL range 1..PIT_HEIGHT loop
      for column in NATURAL range 1..PIT_WIDTH loop
        if pitArray(column, line) /= 0 then
          DrawTile(column, line, pitArray(column, line));
        else
          ClearTile(column, line);
        end if; 
      end loop;
    end loop;
  end RedrawPit;

  function LineCompleted(line: NATURAL) return boolean is
    status: boolean :=True;
  begin
    for column in NATURAL range 1..PIT_WIDTH loop
      if pitArray(column, line) = 0 then
        status := False;
      end if;
    end loop;

    return status;
  end LineCompleted;

  function CountCompletedLines return Natural is
    nbCompletedLine: Natural := 0;
  begin
    for line in NATURAL range 1..PIT_HEIGHT loop
      if LineCompleted(line) = True then
        nbCompletedLine := nbCompletedLine +1;
      end if;
    end loop;

    return nbCompletedLine;
  end CountCompletedLines;
end Game.Tetrominos;
