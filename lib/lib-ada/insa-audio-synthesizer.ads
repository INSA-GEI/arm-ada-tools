-- Package Insa.Audio.Synthetiser
-- High level note and music generation (synthetiser)
--

pragma Ada_95;

package Insa.Audio.Synthesizer is
    pragma Warnings (Off);

    WaveTableLength : constant INTEGER := 55;
    NotesLength     : constant INTEGER := 12*8;
    TickAudio       : constant FLOAT   := 1.0/44100.0;

    subtype SYNTH_WAVE_ELEMENT is BYTE;
    --type SYNTH_WAVE is array(1..WaveTableLength) of SYNTH_WAVE_ELEMENT;
    type SYNTH_WAVE is array(NATURAL range <>) of SYNTH_WAVE_ELEMENT;
    type SYNTH_WAVE_ACCESS is access constant SYNTH_WAVE;
    subtype SYNTH_NOTE is BYTE;
    subtype SYNTH_STATUS is BYTE;
    subtype MELODY_STATUS is BYTE;

    type SYNTH_INSTRUMENT is
    record
	    hold_time:          NATURAL;
	    sustain_time:       NATURAL;
        attack_increment:   FLOAT;
	    decay_increment:    FLOAT;
        decay_level:        FLOAT;
        release_increment:  FLOAT;
        wavetable:          SYNTH_WAVE_ACCESS;
    end record;
    --pragma Pack (SYNTH_INSTRUMENT);
    --pragma Convention   (Convention => C, 
    --                    Entity      => SYNTH_INSTRUMENT);

    type SYNTH_INSTRUMENT_ACCESS is access constant SYNTH_INSTRUMENT;
    type SYNTH_INSTRUMENT_ARRAY is array(NATURAL range <>) of SYNTH_INSTRUMENT;
    type SYNTH_INSTRUMENT_ARRAY_ACCESS is access constant SYNTH_INSTRUMENT_ARRAY;

    type MELODY_NOTES_ELEMENT is
    record
	    note:       SYNTH_NOTE;
	    channel:    BYTE;
	    duration:   WORD;
    end record;
    --pragma Pack (MELODY_NOTES_ELEMENT);
    pragma Convention   (Convention => C, 
                        Entity      => MELODY_NOTES_ELEMENT);

    type MELODY_NOTES is array(NATURAL range <>) of MELODY_NOTES_ELEMENT;
    type MELODY_NOTES_ACCESS is access constant MELODY_NOTES;
    pragma Pack (MELODY_NOTES);

    type CHANNEL_VOLUME_ARRAY is array(NATURAL range <>) of BYTE;
    type CHANNEL_VOLUME_ARRAY_ACCESS is access constant CHANNEL_VOLUME_ARRAY;

    type MELODY_MUSIC is
    record
	    --instruments_length: WORD;
	    music_length:       NATURAL;
	    --instrument:         SYNTH_INSTRUMENT_ARRAY_ACCESS;
	    --channels_volume:    CHANNEL_VOLUME_ARRAY_ACCESS;
	    notes:              MELODY_NOTES_ACCESS;
    end record;
    pragma Pack (MELODY_MUSIC);
    pragma Convention   (Convention => C, 
                        Entity      => MELODY_MUSIC);

    type MELODY_MUSIC_ACCESS is access constant MELODY_MUSIC;

    type MELODY_POSITION_ACCESS is access all BYTE;

    SinWave: constant SYNTH_WAVE :=
	(
		128, 142, 156, 171, 184, 197, 209, 219, 229, 237, 244, 249, 253,
		255, 255, 254, 251, 247, 241, 233, 224, 214, 203, 190, 177, 164,
		149, 135, 121, 107, 92, 79, 66, 53, 42, 32, 23, 15, 9, 5, 2, 1,
		1, 3, 7, 12, 19, 27, 37, 47, 59, 72, 85, 100, 114
	); 
	 
	SquareWave: aliased constant SYNTH_WAVE :=
	(
		255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,
		255,255,255,255,255,255,255,255,255,255,255,255,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	);
	
	TriangleWave: aliased constant SYNTH_WAVE :=
	(
		128,137,146,155,164,173,182,191,200,209,218,227,236,245,255,245,
		236,227,218,209,200,191,182,173,164,155,146,137,128,118,109,100,
		91,82,73,64,55,46,37,28,19,10,1,9,19,29,39,48,58,68,78,87,97,107,
		117
	);

    C0              : constant SYNTH_NOTE :=0;
    C0_S            : constant SYNTH_NOTE :=1;
    D0              : constant SYNTH_NOTE :=2;
    D0_S            : constant SYNTH_NOTE :=3;
    E0              : constant SYNTH_NOTE :=4;
    F0              : constant SYNTH_NOTE :=5;
    F0_S            : constant SYNTH_NOTE :=6;
    G0              : constant SYNTH_NOTE :=7;
    G0_S            : constant SYNTH_NOTE :=8;
    A0              : constant SYNTH_NOTE :=9;
    A0_S            : constant SYNTH_NOTE :=10;
    B0              : constant SYNTH_NOTE :=11;

    C1              : constant SYNTH_NOTE :=12;
    C1_S            : constant SYNTH_NOTE :=13;
    D1              : constant SYNTH_NOTE :=14;
    D1_S            : constant SYNTH_NOTE :=15;
    E1              : constant SYNTH_NOTE :=16;
    F1              : constant SYNTH_NOTE :=17;
    F1_S            : constant SYNTH_NOTE :=18;
    G1              : constant SYNTH_NOTE :=19;
    G1_S            : constant SYNTH_NOTE :=20;
    A1              : constant SYNTH_NOTE :=21;
    A1_S            : constant SYNTH_NOTE :=22;
    B1              : constant SYNTH_NOTE :=23;

    C2              : constant SYNTH_NOTE :=24;
    C2_S            : constant SYNTH_NOTE :=25;
    D2              : constant SYNTH_NOTE :=26;
    D2_S            : constant SYNTH_NOTE :=27;
    E2              : constant SYNTH_NOTE :=28;
    F2              : constant SYNTH_NOTE :=29;
    F2_S            : constant SYNTH_NOTE :=30;
    G2              : constant SYNTH_NOTE :=31;
    G2_S            : constant SYNTH_NOTE :=32;
    A2              : constant SYNTH_NOTE :=33;
    A2_S            : constant SYNTH_NOTE :=34;
    B2              : constant SYNTH_NOTE :=35;

    C3              : constant SYNTH_NOTE :=36;
    C3_S            : constant SYNTH_NOTE :=37;
    D3              : constant SYNTH_NOTE :=38;
    D3_S            : constant SYNTH_NOTE :=39;
    E3              : constant SYNTH_NOTE :=40;
    F3              : constant SYNTH_NOTE :=41;
    F3_S            : constant SYNTH_NOTE :=42;
    G3              : constant SYNTH_NOTE :=43;
    G3_S            : constant SYNTH_NOTE :=44;
    A3              : constant SYNTH_NOTE :=45;
    A3_S            : constant SYNTH_NOTE :=46;
    B3              : constant SYNTH_NOTE :=47;

    C4              : constant SYNTH_NOTE :=48;
    C4_S            : constant SYNTH_NOTE :=49;
    D4              : constant SYNTH_NOTE :=50;
    D4_S            : constant SYNTH_NOTE :=51;
    E4              : constant SYNTH_NOTE :=52;
    F4              : constant SYNTH_NOTE :=53;
    F4_S            : constant SYNTH_NOTE :=54;
    G4              : constant SYNTH_NOTE :=55;
    G4_S            : constant SYNTH_NOTE :=56;
    A4              : constant SYNTH_NOTE :=57;
    A4_S            : constant SYNTH_NOTE :=58;
    B4              : constant SYNTH_NOTE :=59;

    C5              : constant SYNTH_NOTE :=60;
    C5_S            : constant SYNTH_NOTE :=61;
    D5              : constant SYNTH_NOTE :=62;
    D5_S            : constant SYNTH_NOTE :=63;
    E5              : constant SYNTH_NOTE :=64;
    F5              : constant SYNTH_NOTE :=65;
    F5_S            : constant SYNTH_NOTE :=66;
    G5              : constant SYNTH_NOTE :=67;
    G5_S            : constant SYNTH_NOTE :=68;
    A5              : constant SYNTH_NOTE :=69;
    A5_S            : constant SYNTH_NOTE :=70;
    B5              : constant SYNTH_NOTE :=71;

    C6              : constant SYNTH_NOTE :=72;
    C6_S            : constant SYNTH_NOTE :=73;
    D6              : constant SYNTH_NOTE :=74;
    D6_S            : constant SYNTH_NOTE :=75;
    E6              : constant SYNTH_NOTE :=76;
    F6              : constant SYNTH_NOTE :=77;
    F6_S            : constant SYNTH_NOTE :=78;
    G6              : constant SYNTH_NOTE :=79;
    G6_S            : constant SYNTH_NOTE :=80;
    A6              : constant SYNTH_NOTE :=81;
    A6_S            : constant SYNTH_NOTE :=82;
    B6              : constant SYNTH_NOTE :=83;

    C7              : constant SYNTH_NOTE :=84;
    C7_S            : constant SYNTH_NOTE :=85;
    D7              : constant SYNTH_NOTE :=86;
    D7_S            : constant SYNTH_NOTE :=87;
    E7              : constant SYNTH_NOTE :=88;
    F7              : constant SYNTH_NOTE :=89;
    F7_S            : constant SYNTH_NOTE :=90;
    G7              : constant SYNTH_NOTE :=91;
    G7_S            : constant SYNTH_NOTE :=92;
    A7              : constant SYNTH_NOTE :=93;
    A7_S            : constant SYNTH_NOTE :=94;
    B7              : constant SYNTH_NOTE :=95;

    MUTE            : constant SYNTH_NOTE := 255;

    MELODY_SUCCESS  : constant MELODY_STATUS := 0;
	MELODY_ERROR    : constant MELODY_STATUS := 1;

    SYNTH_SUCCESS   : constant SYNTH_STATUS := 0;
	SYNTH_ERROR     : constant SYNTH_STATUS := 1;
	SYNTH_INVALID_CHANNEL   : constant SYNTH_STATUS := 2;

    function SYNTH_Start return SYNTH_STATUS;
    function SYNTH_Stop return SYNTH_STATUS;
   
    function SYNTH_SetMainVolume(volume: INTEGER) return SYNTH_Status;
    function SYNTH_SetVolume(channel: INTEGER; volume: INTEGER) return SYNTH_Status;
    function SYNTH_SetInstrument(channel: INTEGER; instrument : SYNTH_INSTRUMENT_ACCESS) return SYNTH_Status;
    function SYNTH_NoteOn(channel: INTEGER; note: SYNTH_NOTE) return SYNTH_STATUS;
    function SYNTH_NoteOff(channel: INTEGER) return SYNTH_Status;

    function MELODY_Start(music: MELODY_NOTES; length: NATURAL) return MELODY_Status;
    function MELODY_Stop return MELODY_Status;
    function MELODY_GetPosition return BYTE;

end Insa.Audio.Synthesizer;
