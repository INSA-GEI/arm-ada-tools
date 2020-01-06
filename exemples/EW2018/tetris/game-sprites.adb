with Insa;
with Insa.Graphics;
with Insa.Graphics.Images;

use Insa;
use Insa.Graphics;
use Insa.Graphics.Images;

with Game;
with Ressources;

use Game;
use Ressources;

package body Game.Sprites is
  Bloc_Transparent: IMAGE;

  procedure UnpackSprites is
    Bloc_Transparent_Sprite: BITMAP_ACCESS := new BITMAP(1..12*12);
  begin
    Sprite(Tuile_Bleu):=Unpackimage(Bloc_Bleu);
    Sprite(Tuile_Verte):=Unpackimage(Bloc_Vert);
    Sprite(Tuile_Jaune):=Unpackimage(Bloc_Jaune);
    Sprite(Tuile_Cyan):=Unpackimage(Bloc_Cyan);
    Sprite(Tuile_Violet):=Unpackimage(Bloc_Violet);
    Sprite(Tuile_Rouge):=Unpackimage(Bloc_Rouge);
    Sprite(Tuile_Orange):=Unpackimage(Bloc_Orange);
    Sprite(Tuile_Grise):=Unpackimage(Bloc_Gris);

    Sprite(Mur_H):=Unpackimage(Mur_Horizontal);
    Sprite(Mur_V):=Unpackimage(Mur_Vertical);
    
    Sprite(Coin_1):=Unpackimage(Mur_Coin_1);
    Sprite(Coin_2):=Unpackimage(Mur_Coin_2);
    Sprite(Coin_3):=Unpackimage(Mur_Coin_3);
    Sprite(Coin_4):=Unpackimage(Mur_Coin_4);

    for line in natural range 1..12 loop
      for column in natural range 1..12 loop 
        Bloc_Transparent_Sprite((line-1)*12 + column) := Transparentcolor;
      end loop;
    end loop;

    Bloc_Transparent.Width := 12;
    Bloc_Transparent.Height := 12;
    Bloc_Transparent.Data := Bloc_Transparent_Sprite;

    Sprite(Tuile_Transparente):=Bloc_Transparent;
  end UnpackSprites;

end Game.Sprites;