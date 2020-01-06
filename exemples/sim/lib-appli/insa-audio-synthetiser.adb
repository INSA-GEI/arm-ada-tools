-- Package Insa.Audio.Synthetiser
-- High level note  generation (synthetiser)
--

pragma Ada_95;

with Insa.Audio;
use Insa.Audio;

package body Insa.Audio.Synthetiser is
	WaveTableLength: constant INTEGER := 54;
	WaveNumber: constant INTEGER := 3;
	
	SynthBuffer: AUDIO_BUFFER;
	AudioEventFlag: INTEGER:=0;
	
	type SYNTH_WAVE is array (0..WaveTableLength) of BYTE;
	type SYNTH_WAVES is array (1..WaveNumber) of SYNTH_WAVE;
	
	SinWave: constant SYNTH_WAVE :=
	(
		128, 142, 156, 171, 184, 197, 209, 219, 229, 237, 244, 249, 253,
		255, 255, 254, 251, 247, 241, 233, 224, 214, 203, 190, 177, 164,
		149, 135, 121, 107, 92, 79, 66, 53, 42, 32, 23, 15, 9, 5, 2, 1,
		1, 3, 7, 12, 19, 27, 37, 47, 59, 72, 85, 100, 114
	); 
	 
	SquareWave: constant SYNTH_WAVE :=
	(
		255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
		255,255,255,255,255,255,255,255,255,255,255,255,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	);
	
	TriangleWave: constant SYNTH_WAVE :=
	(
		128,137,146,155,164,173,182,191,200,209,218,227,236,245,255,245,
		236,227,218,209,200,191,182,173,164,155,146,137,128,118,109,100,
		91,82,73,64,55,46,37,28,19,10,1,9,19,29,39,48,58,68,78,87,97,107,
		117
	);
	
	WaveBank: constant SYNTH_WAVES :=
	(
		SinWave, SquareWave, TriangleWave
	);
	
	procedure StartSynthetiser is
	begin
		null;
	end StartSynthetiser;
	
	procedure NoteOn(note: Integer) is
	begin
		null;
	end NoteOn;
   
	procedure SynthAudioEvent (buffer_nbr: BUFFER_NUMBER) is
	begin 
		null;
	end SynthAudioEvent;
   
end Insa.Audio.Synthetiser;
