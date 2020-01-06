-- gametetris.time package

package Game is
   
   TimeEvent: boolean;
   pragma Volatile (Timeevent); -- de facon a ce que les parties de code relatives à TimeEvent ne soit pas optimisées
   
   procedure Initialize;
   procedure SettimerCallback;
   procedure Unpacksprites;
   procedure Writescore(Score: Natural; Level: Natural);
   
end Game;
