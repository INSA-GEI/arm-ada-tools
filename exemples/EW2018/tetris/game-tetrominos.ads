with Insa;
use Insa;

package Game.Tetrominos is
    type TetrisFormType is array (1..4, 1..7, 1..4, 1..4) of Byte;
    TetrisForm: constant TetrisFormType :=
  (
    (
      -- Forms for 0 degree
      (
      (
  (0, 1, 0, 0),
  (0, 1, 0, 0),
  (0, 1, 0, 0),
  (0, 1, 0, 0)
)
      ),
      (
(
  (0, 0, 0, 0),
  (0, 1, 1, 0),
  (0, 1, 1, 0),
  (0, 0, 0, 0)
)
      ),
      (
(
  (0, 0, 0, 0),
  (0, 1, 0, 0),
  (0, 1, 0, 0),
  (0, 1, 1, 0)
)
      ),
      (
(
  (0, 0, 0, 0),
  (0, 0, 1, 0),
  (0, 0, 1, 0),
  (0, 1, 1, 0)
)
      ),
      (
(
  (0, 0, 0, 0),
  (0, 0, 1, 0),
  (0, 1, 1, 0),
  (0, 1, 0, 0)
)
      ),
      (
(
  (0, 0, 0, 0),
  (0, 1, 0, 0),
  (0, 1, 1, 0),
  (0, 0, 1, 0)
)
      ),
      (
(
  (0, 0, 0, 0),
  (1, 1, 1, 0),
  (0, 1, 0, 0),
  (0, 0, 0, 0)
)
      )
    ),
    (
      -- Forms for 90 degrees
      (
(
  (0, 0, 0, 0),
  (0, 0, 0, 0),
  (1, 1, 1, 1),
  (0, 0, 0, 0)
)
      ),
      (
(
  (0, 0, 0, 0),
  (0, 1, 1, 0),
  (0, 1, 1, 0),
  (0, 0, 0, 0)
)
      ),
      (
(
  (0, 0, 0, 0),
  (0, 0, 0, 1),
  (0, 1, 1, 1),
  (0, 0, 0, 0)
)
      ),
      (
(
  (0, 0, 0, 0),
  (0, 1, 1, 1),
  (0, 0, 0, 1),
  (0, 0, 0, 0)
)
      ),
      (
(
  (0, 0, 0, 0),
  (0, 1, 1, 0),
  (0, 0, 1, 1),
  (0, 0, 0, 0)
)
      ),
      (
(
  (0, 0, 0, 0),
  (0, 0, 1, 1),
  (0, 1, 1, 0),
  (0, 0, 0, 0)
)
      ),
      (
(
  (0, 0, 0, 0),
  (0, 1, 0, 0),
  (0, 1, 1, 0),
  (0, 1, 0, 0)
)
      )
    ),
    -- Forms for 180 °
    (
      (
(
  (0, 1, 0, 0),
  (0, 1, 0, 0),
  (0, 1, 0, 0),
  (0, 1, 0, 0)
)
      ),
      (
(
  (0, 0, 0, 0),
  (0, 1, 1, 0),
  (0, 1, 1, 0),
  (0, 0, 0, 0)
)
      ),
      (
(
  (0, 0, 0, 0),
  (0, 1, 1, 0),
  (0, 0, 1, 0),
  (0, 0, 1, 0)
)
      ),
      (
(
  (0, 0, 0, 0),
  (0, 1, 1, 0),
  (0, 1, 0, 0),
  (0, 1, 0, 0)
)
      ),
      (
(
  (0, 0, 0, 0),
  (0, 0, 1, 0),
  (0, 1, 1, 0),
  (0, 1, 0, 0)
)
      ),
      (
(
  (0, 0, 0, 0),
  (0, 1, 0, 0),
  (0, 1, 1, 0),
  (0, 0, 1, 0)
)
      ),
      (
(
  (0, 0, 0, 0),
  (0, 1, 0, 0),
  (1, 1, 1, 0),
  (0, 0, 0, 0)
)
      )
    ),
    -- forms for 270 °
    (
      (
(
  (0, 0, 0, 0),
  (0, 0, 0, 0),
  (1, 1, 1, 1),
  (0, 0, 0, 0)
)
      ),
      (
(
  (0, 0, 0, 0),
  (0, 1, 1, 0),
  (0, 1, 1, 0),
  (0, 0, 0, 0)
)
      ),
      (
(
  (0, 0, 0, 0),
  (1, 1, 1, 0),
  (1, 0, 0, 0),
  (0, 0, 0, 0)
)
      ),
      (
(
  (0, 0, 0, 0),
  (1, 0, 0, 0),
  (1, 1, 1, 0),
  (0, 0, 0, 0)
)
      ),
      (
(
  (0, 0, 0, 0),
  (1, 1, 0, 0),
  (0, 1, 1, 0),
  (0, 0, 0, 0)
)
      ),
      (
(
  (0, 0, 0, 0),
  (0, 1, 1, 0),
  (1, 1, 0, 0),
  (0, 0, 0, 0)
)
      ),
      (
(
  (0, 0, 0, 0),
  (0, 0, 1, 0),
  (0, 1, 1, 0),
  (0, 0, 1, 0)
)
      )
    )
    );
  
  type PIT_ARRAY is array (1..PIT_WIDTH,1..PIT_HEIGHT) of Natural;
  pitArray: PIT_ARRAY := (others => (others => 0));

  type COMPLETED_LINES is record
    line1: Natural;
    line2: Natural;
    line3: Natural;
    line4: Natural;
  end record;

  procedure DrawTile(x: Natural; y: Natural; tile: Natural);
  procedure ClearTile(x: Natural; y: Natural);
  function CheckTetromino(x: Integer; y: Integer; orientation: Natural; tetromino: Natural) return Boolean;
  procedure DrawTetromino(x: Integer; y: Integer; orientation: Natural; tetromino: Natural);
  procedure ClearTetromino(x: Integer; y: Integer; orientation: Natural; tetromino: Natural);
  procedure UpdatePit(x: Integer; y: Integer; orientation: Natural; tetromino: Natural);
  procedure UpdatePit;
  procedure RedrawPit;
  function LineCompleted(line: Natural) return boolean;
  function CountCompletedLines return Natural;
end Game.Tetrominos;
