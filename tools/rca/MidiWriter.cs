//
//  BitmapWriter.cs
//
//  Author:
//       DI MERCURIO Sebastien <dimercur@insa-toulouse.fr>
//
//  Copyright (c) 2016 INSA - GEI, Toulouse, France
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Lesser General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Lesser General Public License for more details.
//
//  You should have received a copy of the GNU Lesser General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.

using System;
using System.IO;

using System.Drawing;
using csmidi;
using System.Collections.Generic;

namespace rca
{
	/// <summary>
	/// Midi writer.
	/// </summary>
	public class MidiWriter
	{
		GeneratedFiles gf;

		/// <summary>
		/// Initializes a new instance of the BitmapWriter class.
		/// </summary>
		/// <param name="name">Name.</param>
		/// <param name="baseFileName">Base file name, without extension.</param>
		/// <param name="conversion">converted bitmap.</param>
		public MidiWriter (GeneratedFiles gf)
		{
			this.gf = gf;
		}

		public bool Convert (RessourcesWavetable[] rcWavetables)
		{
			foreach (RessourcesWavetable wave in rcWavetables) {
				Common.WriteMessage (Common.VerbosityLevel.Normal, "Processing wavetable id " + wave.id);

				if (Common.language == Common.Languages.C) {
					WriteBody_C (wave);
					WriteSpecs_C (wave);
				} else {
					WriteBody_ADA (wave);
					WriteSpecs_ADA (wave);
				}
			}

			return true;
		}

		public bool Convert (RessourcesInstrument[] rcInstruments)
		{
			foreach (RessourcesInstrument instrument in rcInstruments) {
				Common.WriteMessage (Common.VerbosityLevel.Normal, "Processing instrument id " + instrument.id);

				if (Common.language == Common.Languages.C) {
					WriteBody_C (instrument);
					WriteSpecs_C (instrument);
				} else {
					WriteBody_ADA (instrument);
					WriteSpecs_ADA (instrument);
				}
			}

			return true;
		}

		public bool Convert (RessourcesMelody[] rcMelodys)
		{	
			MidiFile midifile = new MidiFile ();
			List<MelodyElement> melodyTranslated;
			int timeDivision = 0;

			/* open midi file */
			foreach (RessourcesMelody melody in rcMelodys)
			{
				Common.WriteMessage (Common.VerbosityLevel.Normal, "Processing melody id " + melody.id);
				try {
					midifile.loadMidiFromFile (melody.filename);
				}
				catch (Exception e) {
					Common.WriteMessage (Common.VerbosityLevel.Error, "Error while reading file: " + melody.filename + Environment.NewLine + e.ToString());
					return false;
				}

				timeDivision = midifile.timeDivision;
				melodyTranslated = MidiConvertion.Translate(midifile);

				if (Common.language == Common.Languages.C) {
					WriteBody_C (melody, melodyTranslated);
					WriteSpecs_C (melody, melodyTranslated);
				} else {
					WriteBody_ADA (melody, melodyTranslated);
					WriteSpecs_ADA (melody, melodyTranslated);
				}
			}

			return true;
		}

		/// <summary>
		/// Writes the body AD.
		/// </summary>
		/// <returns><c>true</c>, if body AD was writed, <c>false</c> otherwise.</returns>
		/// <param name="wavetable">Wavetable.</param>
		private bool WriteBody_ADA (RessourcesWavetable wavetable)
		{
			return true;
		}

		private bool WriteSpecs_ADA (RessourcesWavetable wavetable)
		{
			/* Fill the specifications */

			/* First fill waveform data array */
			gf.spec.WriteLine("\t" + wavetable.id + " : aliased constant SYNTH_WAVE :=");
			gf.spec.WriteLine("\t(");

			for (int i = 0; i < wavetable.wave.Length-1; i++) {
				gf.spec.WriteLine ("\t\t" + wavetable.wave[i] + ",");
			}

			gf.spec.WriteLine ("\t\t" + wavetable.wave[wavetable.wave.Length-1]);
			gf.spec.WriteLine("\t);"+ Environment.NewLine);

			/* Next, create a SYNTH_WAVE access for previously generated array */
			gf.spec.WriteLine("\t" + wavetable.id + "_Access : SYNTH_WAVE_ACCESS := " + wavetable.id + "'Access;" + Environment.NewLine);

			return true;
		}

		private bool WriteBody_C(RessourcesWavetable wavetable)
		{
			/* Fill the body */
			gf.body.WriteLine("const SYNTH_Wave "+ wavetable.id + "[] = {");

			for (int i = 0; i < wavetable.wave.Length-1; i++) {
				gf.spec.WriteLine ("\t\t" + wavetable.wave[i] + ",");
			}

			gf.spec.WriteLine ("\t\t" + wavetable.wave[wavetable.wave.Length-1]);
			gf.body.WriteLine("};"+ Environment.NewLine);

			return true;
		}

		private bool WriteSpecs_C(RessourcesWavetable wavetable)
		{
			/* Fill the specs */
			gf.spec.WriteLine("extern const SYNTH_Wave " + wavetable.id + ";"+ Environment.NewLine);

			return true;
		}


		/// <summary>
		/// Writes the body c.
		/// </summary>
		/// <returns><c>true</c>, if body c was writed, <c>false</c> otherwise.</returns>
		/// <param name="id">Identifier.</param>
		/// <param name="conversion">Conversion.</param>

		private bool WriteBody_ADA (RessourcesInstrument instrument)
		{
			return true;
		}

		private bool WriteSpecs_ADA (RessourcesInstrument instrument)
		{
			/* Fill the specifications */
			System.Globalization.CultureInfo customCulture = (System.Globalization.CultureInfo)System.Threading.Thread.CurrentThread.CurrentCulture.Clone();
			customCulture.NumberFormat.NumberDecimalSeparator = ".";

			System.Threading.Thread.CurrentThread.CurrentCulture = customCulture;

			/* First fill instrument record */
			gf.spec.WriteLine("\t" + instrument.id + " : aliased constant SYNTH_INSTRUMENT := (");

			gf.spec.WriteLine ("\t\t" + instrument.hold/1000 + ",");			// Wavetable access
			gf.spec.WriteLine ("\t\tNATURAL(" + instrument.sustain/1000+ "/TickAudio),");			// Wavetable access
			gf.spec.WriteLine ("\t\tTickAudio/" + instrument.attack/1000 + ",");	// Attack
			gf.spec.WriteLine ("\t\tTickAudio/" + instrument.decay/1000 + ",");		// decay
			gf.spec.WriteLine ("\t\t" + instrument.sustainLevel/100 + ",");			// Sustain level
			gf.spec.WriteLine ("\t\tTickAudio/" + instrument.release/1000 + ",");	// Release
			gf.spec.WriteLine ("\t\t" + instrument.waveId + "_Access");			// Wavetable access
			gf.spec.WriteLine("\t);"+ Environment.NewLine);

			/* Next, create a SYNTH_INSTRUMENT access for previously generated array */
			gf.spec.WriteLine("\t" + instrument.id + "_Access : SYNTH_INSTRUMENT_ACCESS := " + instrument.id + "'Access;" + Environment.NewLine);

			return true;
		}

		private bool WriteBody_C(RessourcesInstrument instrument)
		{
			/* Fill the body */
			gf.spec.WriteLine("\tconst SYNTH_Instrument " + instrument.id + "= {");

			gf.spec.WriteLine ("\t\t(SYNTH_Wave*)" + instrument.waveId + ",");			// Wavetable access
			gf.spec.WriteLine ("\t\tTickAudio/" + instrument.attack/1000 + "f,");	// Attack
			gf.spec.WriteLine ("\t\tTickAudio/" + instrument.decay/1000 + "f,");		// decay
			gf.spec.WriteLine ("\t\t" + instrument.sustainLevel/100 + "f,");			// Sustain level
			gf.spec.WriteLine ("\t\tTickAudio/" + instrument.release/1000 + "f,");	// Release
			gf.spec.WriteLine ("\t\t" + instrument.hold/1000 + ",");			// Wavetable access
			gf.spec.WriteLine ("\t\t" + instrument.sustain/1000+ "f/TickAudio");			// Wavetable access
			gf.spec.WriteLine("\t};"+ Environment.NewLine);

			return true;
		}

		private bool WriteSpecs_C(RessourcesInstrument instrument)
		{
			/* Fill the specs */
			gf.spec.WriteLine("extern const SYNTH_Instrument " + instrument.id + ";"+ Environment.NewLine);

			return true;
		}


		/// <summary>
		/// Writes the body c.
		/// </summary>
		/// <returns><c>true</c>, if body c was writed, <c>false</c> otherwise.</returns>
		/// <param name="id">Identifier.</param>
		/// <param name="conversion">Conversion.</param>

		private bool WriteBody_ADA (RessourcesMelody melody, List<MelodyElement> translated)
		{
			return true;
		}

		private bool WriteSpecs_ADA (RessourcesMelody melody, List<MelodyElement> translated)
		{
			/* Fill the specifications */

			/* First fill melody array */
			gf.spec.WriteLine("\t" + melody.id + "_Melody : aliased constant MELODY_NOTES := (");

			for (int i = 0; i < translated.Count-1; i++) {
				gf.spec.WriteLine ("\t\t(" + translated[i].note + "," + translated[i].channel + "," + translated[i].eventTime + "),");			
			}

			gf.spec.WriteLine ("\t\t(" + translated[translated.Count-1].note + "," + translated[translated.Count-1].channel + "," + translated[translated.Count-1].eventTime + ")");	
			gf.spec.WriteLine ("\t);" + Environment.NewLine);

			/* Next, create a MELODY_NOTES access for previously generated array */
			gf.spec.WriteLine("\t" +  melody.id + "_Melody_Access : MELODY_NOTES_ACCESS := " + melody.id + "_Melody'Access;" + Environment.NewLine);

			/* First fill melody array */
			gf.spec.WriteLine("\t" + melody.id + " : aliased constant MELODY_MUSIC := (");
			gf.spec.WriteLine ("\t\t" + translated.Count + ",");			
			gf.spec.WriteLine ("\t\t" + melody.id + "_Melody_Access");	
			gf.spec.WriteLine ("\t);" + Environment.NewLine);

			/* Next, create a MELODY_NOTES access for previously generated array */
			gf.spec.WriteLine("\t" +  melody.id + "_Access: MELODY_MUSIC_ACCESS := " + melody.id + "'Access;" + Environment.NewLine);
			return true;
		}

		private bool WriteBody_C(RessourcesMelody melody, List<MelodyElement> translated)
		{
			/* Fill the specifications */

			/* First fill instrument array */
			gf.spec.WriteLine("\tconst SYNTH_Instrument* " + melody.id + "_Instruments[" + melody.channels.Length + "] = {");

			for (int i = 0; i < melody.channels.Length; i++) {
				gf.spec.WriteLine ("\t\t(SYNTH_Instrument*)&" + melody.channels[i].instrument + ",");	// instrument name
			}

			gf.spec.WriteLine ("\t\t(SYNTH_Instrument*)&" + melody.channels[melody.channels.Length].instrument); // instrument name
			gf.spec.WriteLine ("\t};" + Environment.NewLine);

			/* then volume array */
			gf.spec.WriteLine("\tconst uint8_t" + melody.id + "_Volumes[" + melody.channels.Length + "] = {");

			for (int i = 0; i < melody.channels.Length; i++) {
				gf.spec.WriteLine ("\t\t" + System.Convert.ToByte(((melody.channels[i].volume*255.0)/100.0)) + ",");	// volume
			}

			gf.spec.WriteLine ("\t\t" + System.Convert.ToByte(((melody.channels[melody.channels.Length-1].volume*255.0)/100.0)));	// volume
			gf.spec.WriteLine ("\t};" + Environment.NewLine);

			return true;
		}

		private bool WriteSpecs_C(RessourcesMelody melody, List<MelodyElement> translated)
		{
			/* Fill the specs */
			gf.spec.WriteLine("extern const uint8_t " + melody.id + "_Volumes[" + melody.channels.Length + "];" + Environment.NewLine);
			gf.spec.WriteLine("extern const SYNTH_Instrument* " + melody.id + "_Instruments[" + melody.channels.Length + "];" + Environment.NewLine);
			return true;
		}
	}
}
