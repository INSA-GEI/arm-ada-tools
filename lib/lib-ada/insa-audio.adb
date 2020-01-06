-- Package Insa.Audio
-- Define functions for controlling audio interface
--
-- Audio device require 16 bits data, signed, at a rate of 22Khz
--

pragma Ada_95;

package body Insa.Audio is
   
   -- glue for interfacing C functions of the OS
   type CtoADA_AUDIO_CALLBACK is access procedure(buffer_nbr: BUFFER_NUMBER);
   pragma Convention(C, CtoADA_AUDIO_CALLBACK);
   
   Event_Callback: AUDIO_CALLBACK:=null;
   
   -- First level callback, directly called from the OS
   procedure CtoADAAudioCallback(buffer_nbr: BUFFER_NUMBER);
   pragma Convention(C, CtoADAAudioCallback);
   
   procedure CtoADAAudioCallback(buffer_nbr: BUFFER_NUMBER) is
   begin
      Event_Callback.all(Buffer_Nbr);
   end CtoADAAudioCallback;
   
   -- StartAudio
   -- Launch audio processing, which will call Event_Callback every half-audio buffer processed
   procedure StartAudio is
      
      procedure Wrapper_StartAudio;
      pragma Import (C, Wrapper_StartAudio, "AUDIO_Start");
      
   begin
      Wrapper_StartAudio;
   end StartAudio;
   
   -- StopAudio
   -- Stop audio processing
   procedure StopAudio is
      
      procedure Wrapper_StopAudio;
      pragma Import (C, Wrapper_StopAudio, "AUDIO_Stop");
      
   begin
      Wrapper_StopAudio;
   end StopAudio;
   
   -- FillAudioBuffer
   -- Used to fill audio buffer. Audio buffer is 1024 elements long and split in 2
   -- each time half part is processed, an event is raised, indicating which part of buffer (buffer_nbr) must be filled
   procedure FillAudioBuffer(buffer_nbr: BUFFER_NUMBER; data: AUDIO_BUFFER) is
      
      type AUDIO_BUFFER_ACCESS is access all AUDIO_BUFFER;
      
      procedure Wrapper_FillAudioBuffer(buffer_nbr: BUFFER_NUMBER; data: AUDIO_BUFFER_ACCESS);
      pragma Import (C, Wrapper_FillAudioBuffer, "AUDIO_FillBuffer");
      
   begin
      Wrapper_FillAudioBuffer(Buffer_Nbr, Data'Unrestricted_Access);
   end FillAudioBuffer;
   
   -- SetAudioCallback
   -- used to register an event callback
   -- callback is called every time half part of audio buffer
   procedure SetAudioCallback (callback: AUDIO_CALLBACK) is
      
      procedure Wrapper_SetAudioCallback (callback: CtoADA_AUDIO_CALLBACK);
      pragma Import (C, Wrapper_SetAudioCallback, "AUDIO_SetEventCallback");
      
   begin
      Event_Callback := Callback;
      Wrapper_SetAudioCallback(CtoADAAudioCallback'Access);
   end SetAudioCallback;
   
end Insa.Audio;
