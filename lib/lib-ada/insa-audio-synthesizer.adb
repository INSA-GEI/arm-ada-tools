-- Package Insa.Audio.Synthetiser
-- High level note and music generation (synthetiser)
--

pragma Ada_95;

with Insa.Audio;
use Insa.Audio;

package body Insa.Audio.Synthesizer is
	
	function SYNTH_Start return SYNTH_STATUS is
		function Wrapper_SYNTH_Start return SYNTH_STATUS;
      	pragma Import (C, Wrapper_SYNTH_Start, "SYNTH_Start");
   	begin
      	return Wrapper_SYNTH_Start;
	end Synth_Start;

    function SYNTH_Stop return SYNTH_STATUS is
		function Wrapper_SYNTH_Stop return SYNTH_STATUS;
      	pragma Import (C, Wrapper_SYNTH_Stop, "SYNTH_Stop");
	begin
		return Wrapper_SYNTH_Stop;
	end Synth_Stop;

	function SYNTH_SetMainVolume(volume: INTEGER) return SYNTH_Status is
		function Wrapper_SYNTH_SetMainVolume(volume: INTEGER) return SYNTH_STATUS;
      	pragma Import (C, Wrapper_SYNTH_SetMainVolume, "SYNTH_SetMainVolume");
	begin
		return Wrapper_SYNTH_SetMainVolume(volume);
	end SYNTH_SetMainVolume;

    function SYNTH_SetVolume(channel: INTEGER; volume: INTEGER) return SYNTH_Status is
		function Wrapper_SYNTH_SetVolume(channel: INTEGER; volume: INTEGER) return SYNTH_STATUS;
      	pragma Import (C, Wrapper_SYNTH_SetVolume, "SYNTH_SetVolume");
	begin
		return Wrapper_SYNTH_SetVolume(channel, volume);
	end SYNTH_SetVolume;

    function SYNTH_SetInstrument(channel: INTEGER; instrument: SYNTH_INSTRUMENT_ACCESS) return SYNTH_Status is
		function Wrapper_SYNTH_SetInstrument(channel: INTEGER; instrument_access: SYNTH_INSTRUMENT_ACCESS) return SYNTH_STATUS;
      	pragma Import (C, Wrapper_SYNTH_SetInstrument, "SYNTH_SetInstrument");
	begin
		return Wrapper_SYNTH_SetInstrument(channel, instrument);
	end SYNTH_SetInstrument;

    function SYNTH_NoteOn(channel: INTEGER; note: SYNTH_NOTE) return SYNTH_STATUS is
		function Wrapper_SYNTH_NoteOn(channel: INTEGER; note: SYNTH_NOTE) return SYNTH_STATUS;
      	pragma Import (C, Wrapper_SYNTH_NoteOn, "SYNTH_NoteOn");
	begin
		return Wrapper_SYNTH_NoteOn(channel,note);
	end SYNTH_NoteOn;
	
	function SYNTH_NoteOff(channel: INTEGER) return SYNTH_STATUS is
		function Wrapper_SYNTH_NoteOff(channel: INTEGER) return SYNTH_STATUS;
      	pragma Import (C, Wrapper_SYNTH_NoteOff, "SYNTH_NoteOff");
	begin
		return Wrapper_SYNTH_NoteOff(channel);
	end SYNTH_NoteOff;

    function MELODY_Start(music: in MELODY_NOTES; length: NATURAL) return MELODY_Status is
		function Wrapper_MELODY_Start(music_access: MELODY_NOTES_ACCESS; length: NATURAL) return MELODY_Status;
      	pragma Import (C, Wrapper_MELODY_Start, "MELODY_Start");
	begin
		return Wrapper_MELODY_Start(music'Unrestricted_Access, length);
	end MELODY_Start;

    function MELODY_Stop return MELODY_Status is
		function Wrapper_MELODY_Stop return MELODY_Status;
      	pragma Import (C, Wrapper_MELODY_Stop, "MELODY_Stop");
	begin
		return Wrapper_MELODY_Stop;
	end MELODY_Stop;

    function MELODY_GetPosition return BYTE is
		function Wrapper_MELODY_GetPosition(position: MELODY_POSITION_ACCESS) return MELODY_Status;
      	pragma Import (C, Wrapper_MELODY_GetPosition, "MELODY_GetPosition");

		pos: BYTE;
		status: MELODY_Status;
	begin
		status:= Wrapper_MELODY_GetPosition(pos'Unrestricted_Access);

		if (status /= MELODY_SUCCESS) then
			pos:=0;
		end if;

		return pos;
	end MELODY_GetPosition;

end Insa.Audio.Synthesizer;
