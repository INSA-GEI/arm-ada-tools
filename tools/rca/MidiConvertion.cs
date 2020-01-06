using System;
using csmidi;
using System.Collections.Generic;

namespace rca
{
	public class MelodyElement
	{
		public long eventTime;
		public byte note;
		public byte channel;

		public MelodyElement()
		{
			eventTime = 0;
			note = 0;
			channel = 0;
		}
	}

	public static class MidiConvertion
	{
		public static List<MelodyElement> Translate (MidiFile midifile)
		{
			List<MelodyElement> melody = new List<MelodyElement> ();
			UInt16 timeDivision = midifile.timeDivision;

			long quarterTickMicroSeconds=500000; // default time for à 120 beats/min

			foreach (MidiTrack track in midifile.midiTracks) {
				foreach (MidiEvent evt in track.midiEvents) {
					if (evt.GetType () == typeof(MessageMidiEvent)) {
						MessageMidiEvent messageEvt = (MessageMidiEvent)evt;

						if (messageEvt.type == NormalType.NoteON) {
							
								MelodyElement element = new MelodyElement ();

								element.eventTime = (messageEvt.absoluteTicks * quarterTickMicroSeconds) / 96; // Convert midi time in microsecond 
								element.eventTime = element.eventTime / 100;	// get it in tenth of ms (0.1ms)
								//element.eventTime = messageEvt.absoluteTicks;
								element.channel = messageEvt.midiChannel;
								element.note = ConvertNote (messageEvt.parameter1);

								//melody.Insert (SearchIndex (melody, evt.absoluteTicks), element);
								melody.Add (element);

						}
					} else if (evt.GetType () == typeof(MetaMidiEvent)) {
						MetaMidiEvent metaEvt = (MetaMidiEvent)evt;

						if (metaEvt.getMetaType () == MetaType.TempoSetting) {
							byte[] time;
							time = metaEvt.getEventData ();

							if (time.Length >= 6)
								quarterTickMicroSeconds = (long)(time [3] * 65536) + (long)(time [4] * 256) + (long)time [5];
						}
					}
				}
			}

			melody.Sort (delegate(MelodyElement x, MelodyElement y) {
				if (x.eventTime<y.eventTime) return -1;
				else if (x.eventTime>y.eventTime) return 1;
				else return 0;
			});

			ConvertDeltaTime (melody);

			return melody;
		}
	
		private static void ConvertDeltaTime(List<MelodyElement> melody)
		{
			long previousTime = 0;
			MelodyElement prevElement = melody [0];

			foreach (MelodyElement element in melody) {
				if (element.eventTime == previousTime)
					prevElement.eventTime = 0;
				else {
					long tmp = element.eventTime;
					prevElement.eventTime = element.eventTime - previousTime;
					previousTime = tmp;
				}

				prevElement = element;
			}

			melody [melody.Count - 1].eventTime = 0;
		}

		private static byte ConvertNote(byte midiNote) {
			if (midiNote>=24) return (byte)(midiNote-24); //C0 in midi file is coded 24 and coded 0 in SoftSynth
			else return 0;
		}
	}
}

