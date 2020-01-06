-- gametetris.time package
with Insa;
with Insa.Graphics;

use Insa;
use Insa.Graphics;

package Game is
  BgrColor: constant COLOR := LightGrey;
  BgrScore: constant COLOR := LightGrey;
  Transparentcolor: constant COLOR := 252;

  PIT_ORIGIN_X: constant Natural := 12;
  PIT_ORIGIN_Y: constant Natural := 12;
  PIT_WIDTH: constant Natural := 12;
  PIT_HEIGHT: constant Natural := 18;

  TimeEvent: boolean;
  pragma Volatile (Timeevent); -- De facon a ce que les parties de code relatives à TimeEvent ne soit pas optimisées
  
  subtype Orientation is Natural range 1..4;

  procedure Initialize;
  procedure SettimerCallback;
  procedure Writescore(Score: Natural; Level: Natural);
  function GetNextTetromino return Natural;
  procedure ShowGameOver;
  procedure ShowMainGame;
  procedure ShowTitleScreen;
  procedure PlayBGM;
  procedure PlayGameOverMusic;
end Game;
