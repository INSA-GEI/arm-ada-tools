with Insa;
with Insa.Graphics;
with Insa.Graphics.Images;

use Insa;
use Insa.Graphics;
use Insa.Graphics.Images;

package Game.Sprites is
  Tuile_Bleu: constant Integer :=1;
  Tuile_Verte: constant Integer :=2;
  Tuile_Jaune: constant Integer :=3;
  Tuile_Cyan: constant Integer :=4;
  Tuile_Violet: constant Integer :=5;
  Tuile_Rouge: constant Integer :=6;
  Tuile_Orange: constant Integer :=7;
  Tuile_Grise: constant Integer :=8;
  Tuile_Transparente: constant Integer :=9;
  
  Mur_H: constant Integer :=10;
  Mur_V: constant Integer :=11;
  
  Coin_1: constant Integer :=12;
  Coin_2: constant Integer :=13;
  Coin_3: constant Integer :=14;
  Coin_4: constant Integer :=15;
  
  Sprite: array (1..20) of IMAGE;

  procedure UnpackSprites;
end Game.Sprites;