with Insa;
with Insa.Graphics;

package Tortue is

   -- Utilisation des couleurs du paquetage AdagraphX :
   -- Black, Blue, Green, Cyan, Red, Magenta, Brown,
   -- Light_Gray, Dark_Gray, Light_Blue, Light_Green,
   -- Light_Cyan, Light_Red, Light_Magenta, Yellow, White

   -- D�finition d'une exception lev�e lorsque la tortue sort de l'�cran
   Liberte : exception;

   -- proc�dure permettant l'ouverture d'une fen�tre graphique
   -- => PREMIERE PROCEDURE A UTILISER AVANT DE FAIRE APPEL AUX SUIVANTES DANS LE PROGRAMME DE DESSIN
   -- La tortue est positionn�e en haut � gauche, coordonn�es (0, 0), la t�te vers le bas (orientation = 180�),
   -- plume baiss�e et pr�te � dessiner en blanc

   procedure Ouvrir_Page;

   -- proc�dure permettant la fermeture d'une fen�tre graphique
   -- => DERNIERE PROCEDURE A APPELER AVANT DE QUITTER LE PROGRAMME DE DESSIN
   procedure Fermer_Page;

   -- proc�dure permettant d'avancer de X unit�s dans la direction courante et depuis la position actuelle de la tortue
   procedure Avancer(X: in Float);

   -- proc�dure permettant de reculer de X unit�s dans la direction courante et depuis la position actuelle de la tortue
   procedure Reculer(X: in Float);

   -- proc�dure permettant de faire pivoter la position angulaire de la tortue de X degr� dans le sens inverse des aiguilles d'une montre
   procedure Tourner_Gauche(X: in Float);

   -- proc�dure permettant de faire pivoter la position angulaire de la tortue de X degr� dans le sens des aiguilles d'une montre
   procedure Tourner_Droite(X: in Float);

   -- proc�dure permettant de positionner la tortue sur une position angulaire sp�cifique (valeur X)
   -- X=0 : la tortue est orient�e vers le haut
   -- X=90 : la tortue est orient�e vers la droite
   -- X=180 : la tortue est orient�e vers le bas
   -- X=270 : la tortue est orient�e vers la gauche
   procedure Orienter(X: in Float);

   -- proc�dure permettant de lever la plume de la tortue
   -- => DANS CETTE ETAT AUCUN DEPLACEMENT NE SERA VISIBLE A L'ECRAN
   procedure Lever_Plume;

   -- proc�dure permettant de lever la plume de la tortue
   -- => DANS CETTE ETAT TOUT DEPLACEMENT LAISSERA UNE TRACE A L'ECRAN
   procedure Baisser_Plume;

   -- proc�dure permettant de choisir la couleur du trac�
   procedure Choix_Couleur(pen_color: in Insa.Graphics.COLOR);

   -- function retournant l'abscisse (= le num�ro de colonne) de la position courante de la tortue
   function Coordonnee_X return Float;

   -- function retournant l'ordonnee (= le num�ro de ligne) de la position courante de la tortue
   function Coordonnee_Y return Float;

   -- function retournant la valeur de la position angulaire courante de la tortue
   function Coordonnee_Direction return Float;

   -- function retournant le nombre maximum de lignes qui peut �tre affich� dans la fen�tre
   function Hauteur_Page return Float;

   -- function retournant le nombre maximum de colonnes qui peut �tre affich� dans la fen�tre
   function Largeur_Page return Float;

   -- proc�dure permettant un d�placement de la position courante vers le point (X, Y)
   procedure Absolue(X: in Insa.Graphics.PIXEL_X; Y: in Insa.Graphics.PIXEL_Y);

   -- proc�dure permettant un d�placement depuis la position courante (point A) vers un point B tel que abscisse(B)-abscisse(A) = X et ordonnee(B)-ordonnee(A) = Y
   procedure Deplacement(X: in Float; Y: in Float);
   
end Tortue;


