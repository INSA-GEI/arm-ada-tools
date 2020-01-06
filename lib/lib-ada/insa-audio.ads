-- Package Insa.Audio
-- Define functions for controlling audio interface
--
-- Audio device require 16 bits data, signed, at a rate of 22Khz
--

pragma Ada_95;

package Insa.Audio is
   pragma Warnings (Off);

   subtype BUFFER_NUMBER is BYTE range 1 .. 2;
   subtype BUFFER_ELEMENT is BYTE;

   type AUDIO_BUFFER is array(1..512) of BUFFER_ELEMENT;

   type AUDIO_CALLBACK is access procedure (buffer_nbr: BUFFER_NUMBER);
   
   -- StartAudio
   -- Lauch audio processing, which will call Event_Callback every half-audio buffer processed
   procedure StartAudio;
   
   -- StopAudio
   -- Stop audio processing
   procedure StopAudio;
   
   -- FillAudioBuffer
   -- Used to fill audio buffer. Audio buffer is 1024 elements long and split in 2
   -- each time half part is processed, an event is raised, indicating which part of buffer (buffer_nbr) must be filled
   procedure FillAudioBuffer(buffer_nbr: BUFFER_NUMBER; data: AUDIO_BUFFER);
   
   -- SetAudioCallback
   -- used to register an event callback
   -- callback is called every time half part of audio buffer
   procedure SetAudioCallback (callback: AUDIO_CALLBACK);
   
end Insa.Audio;
