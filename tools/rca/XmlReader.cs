//
//  XmlReader.cs
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
using System.Xml;

namespace rca
{
	public enum XmlReadStatus
	{
		Success,
		FileNotFound,
		NodeNotFound,
		InvalidFile
	}

	public class RessourcesFile
	{
		public string filename;
		public Common.Languages language;
	}

	public class RessourcesImage
	{
		public string id;
		public string filename;
		public Common.ColorFormat color;
		public bool isPacked;
	}

	public class RessourcesString
	{
		public string id;
		public string text;
	}

	public class RessourcesWavetable
	{
		public const int WavetableMaxLength = 55;
		public string id;
		public byte[] wave;
	}

	public class RessourcesInstrument
	{
		public string id;
		public string waveId;
		public double attack;
		public double hold;
		public double decay;
		public double sustainLevel;
		public double sustain;
		public double release;
	}

	public class RessourcesChannel
	{
		public string instrument = "";
		public double volume = 0;
	}

	public class RessourcesMelody
	{
		public string id;
		public RessourcesChannel[] channels;
		public string filename;
	}

	public class XmlReader
	{
		public RessourcesFile rcFile;
		public RessourcesImage[] rcImage;
		public RessourcesString[] rcString;
		public RessourcesWavetable[] rcWavetable;
		public RessourcesInstrument[] rcInstrument;
		public RessourcesChannel[] rcChannel;
		public RessourcesMelody[] rcMelody;

		public XmlReader ()
		{
		}

		public XmlReadStatus Read (string filename)
		{
			XmlNodeList FileList;
			XmlNode RessourceNode;
			XmlNodeList ImageList;
			XmlNodeList TextList;
			XmlNodeList WavetableList;
			XmlNodeList InstrumentList;
			XmlNodeList MelodyList;
			XmlDocument doc = new XmlDocument ();

			int i = 0;

			try {
				doc.Load (filename);
			} catch (System.IO.FileNotFoundException e) {
				Common.WriteMessage (Common.VerbosityLevel.Error, e.Message);
				return XmlReadStatus.FileNotFound;
			} catch (Exception e) {
				Common.WriteMessage (Common.VerbosityLevel.Error, e.Message);
				return XmlReadStatus.InvalidFile;
			}

			/* Lecture des infos sur le fichier */
			try {
				RessourceNode = doc.SelectSingleNode ("/ressources");
			} catch (Exception e) {
				Common.WriteMessage (Common.VerbosityLevel.Error, e.Message); 
				return XmlReadStatus.InvalidFile;
			}

			try {
				FileList = RessourceNode.SelectNodes ("file");
			} catch (Exception e) {
				Common.WriteMessage (Common.VerbosityLevel.Error, e.Message); 
				return XmlReadStatus.InvalidFile;
			}

			rcFile = new RessourcesFile ();

			rcFile.filename = FileList [0].InnerText;
			rcFile.language = Common.Languages.C;

			if (FileList [0].Attributes.GetNamedItem ("language") != null) {
				if (FileList [0].Attributes.GetNamedItem ("language").Value.ToLower () == "ada")
					rcFile.language = Common.Languages.ADA;
				else if (FileList [0].Attributes.GetNamedItem ("language").Value.ToLower () == "c")
					rcFile.language = Common.Languages.C;
				else {
					Common.WriteMessage (Common.VerbosityLevel.Error, "Invalid language for file generation");
				}
			} else {
				Common.WriteMessage (Common.VerbosityLevel.Normal, "Unset language for code generation: Set to \"C\"");
			}
				
			Common.WriteMessage (Common.VerbosityLevel.Verbose, "File to generate: " + rcFile.filename + " , Language = " + rcFile.language);

			/* Lecture des infos sur les images */
			try {
				ImageList = RessourceNode.SelectNodes ("image");
			} catch (Exception e) {
				Common.WriteMessage (Common.VerbosityLevel.Error, e.Message);
				return XmlReadStatus.InvalidFile;
			}

			rcImage = new RessourcesImage[ImageList.Count];
			i = 0;
			Common.WriteMessage (Common.VerbosityLevel.Verbose, "Nbr of image to convert: " + rcImage.Length);

			foreach (XmlNode node in ImageList) {
				rcImage [i] = new RessourcesImage ();

				rcImage [i].filename = node.InnerText;
				rcImage [i].color = Common.ColorFormat.RGB8;
				rcImage [i].isPacked = false;
				rcImage [i].id = "";

				if (node.Attributes.GetNamedItem ("id") != null)
					rcImage [i].id = node.Attributes.GetNamedItem ("id").Value;

				if (node.Attributes.GetNamedItem ("color") != null) {
					if (node.Attributes.GetNamedItem ("color").Value.ToLower () == "8bpp")
						rcImage [i].color = Common.ColorFormat.RGB8;
					else if (node.Attributes.GetNamedItem ("color").Value.ToLower () == "16bpp")
						rcImage [i].color = Common.ColorFormat.RGB16;
					else {
						Common.WriteMessage (Common.VerbosityLevel.Normal, "Invalid color format for image " + rcImage [i].filename + " :Set to 8bpp");
					}
				} else {
					Common.WriteMessage (Common.VerbosityLevel.Normal, "Unset color format for image " + rcImage [i].filename + " :Set to 8bpp");
				}

				if (node.Attributes.GetNamedItem ("packed") != null) {
					if (node.Attributes.GetNamedItem ("packed").Value.ToLower () == "true")
						rcImage [i].isPacked = true;
					else if (node.Attributes.GetNamedItem ("id").Value.ToLower () == "false")
						rcImage [i].isPacked = false;
					else {
						Common.WriteMessage (Common.VerbosityLevel.Normal, "Invalid packing format for image " + rcImage [i].filename + " :Set to false");
					}
				} else {
					Common.WriteMessage (Common.VerbosityLevel.Normal, "Unset packing format for image " + rcImage [i].filename + " :Set to false");
				}

				if (rcImage [i].id == "") {
					Common.WriteMessage (Common.VerbosityLevel.Normal, "Unset id for image " + rcImage [i].filename + " : Set as image_" + i);
					rcImage [i].id = "image_" + i;
				}

				i++;
			}

			/* Lecture des infos sur les textes */
			try {
				TextList = RessourceNode.SelectNodes ("string");
			} catch (Exception e) {
				Common.WriteMessage (Common.VerbosityLevel.Error, e.Message);
				return XmlReadStatus.InvalidFile;
			}

			rcString = new RessourcesString[TextList.Count];
			i = 0;
			Common.WriteMessage (Common.VerbosityLevel.Verbose, "Nbr of text string to convert: " + rcString.Length);

			foreach (XmlNode node in TextList) {
				rcString [i] = new RessourcesString ();
				rcString [i].text = node.InnerText;
				rcString [i].id = "";

				if (node.Attributes.GetNamedItem ("id") != null)
					rcString [i].id = node.Attributes.GetNamedItem ("id").Value;
				else {
					Common.WriteMessage (Common.VerbosityLevel.Normal, "Unset id for text label \"" + rcString [i].text + "\" : Set as label_" + i);
					rcString [i].id = "label" + i;
				}

				i++;
			}

			/* Lecture des infos sur les images */
			/* D'abord les wavetables */
			try {
				WavetableList = RessourceNode.SelectNodes ("wavetable");
			} catch (Exception e) {
				Common.WriteMessage (Common.VerbosityLevel.Error, e.Message);
				return XmlReadStatus.InvalidFile;
			}

			rcWavetable = new RessourcesWavetable[WavetableList.Count];
			i = 0;
			Common.WriteMessage (Common.VerbosityLevel.Verbose, "Nbr of wavetable to convert: " + rcWavetable.Length);

			foreach (XmlNode node in WavetableList) {
				rcWavetable [i] = new RessourcesWavetable ();

				rcWavetable [i].wave = null;
				rcWavetable [i].id = "";

				if (node.Attributes.GetNamedItem ("id") != null)
					rcWavetable [i].id = node.Attributes.GetNamedItem ("id").Value;

				byte[] wave = new byte[RessourcesWavetable.WavetableMaxLength];
				XmlNodeList waveElements;

				/* Get inner elements */
				try {
					waveElements = node.SelectNodes ("value");	
				} catch (Exception e) {
					Common.WriteMessage (Common.VerbosityLevel.Error, e.Message);
					return XmlReadStatus.InvalidFile;
				}

				for (int wavectn = 0; wavectn < RessourcesWavetable.WavetableMaxLength; wavectn++) {
					if (wavectn < waveElements.Count) {
						var str = waveElements [wavectn].InnerText;
						wave [wavectn] = Convert.ToByte (str);
					} else
						wave [wavectn] = 0;
				}

				rcWavetable [i].wave = wave;

				if (rcWavetable [i].id == "") {
					Common.WriteMessage (Common.VerbosityLevel.Normal, "Unset id for wavetable. Set as wave_" + i);
					rcWavetable [i].id = "wave_" + i;
				}

				i++;
			}

			/* Ensuite les instruments */
			try {
				InstrumentList = RessourceNode.SelectNodes ("instrument");
			} catch (Exception e) {
				Common.WriteMessage (Common.VerbosityLevel.Error, e.Message);
				return XmlReadStatus.InvalidFile;
			}

			rcInstrument = new RessourcesInstrument[InstrumentList.Count];
			i = 0;
			Common.WriteMessage (Common.VerbosityLevel.Verbose, "Nbr of instrument to convert: " + rcInstrument.Length);

			foreach (XmlNode node in InstrumentList) {
				rcInstrument [i] = new RessourcesInstrument ();

				rcInstrument [i].id = "wave_" + i;
				rcInstrument [i].attack = 0.0;
				rcInstrument [i].decay = 0.0;
				rcInstrument [i].sustainLevel = 0.0;
				rcInstrument [i].hold = 0.0;
				rcInstrument [i].release = 0.0;
				rcInstrument [i].sustain = 0.0;
				rcInstrument [i].waveId = "SYNTH_SquareWave";

				if (node.Attributes.GetNamedItem ("id") != null)
					rcInstrument [i].id = node.Attributes.GetNamedItem ("id").Value;

				if (rcInstrument [i].id == "") {
					Common.WriteMessage (Common.VerbosityLevel.Normal, "Unset id for wavetable. Set as wave_" + i);
					rcInstrument [i].id = "wave_" + i;
				}
				XmlNodeList instrElements;

				/* Get inner element wave */
				try {
					instrElements = node.SelectNodes ("wave");	
				} catch (Exception e) {
					Common.WriteMessage (Common.VerbosityLevel.Error, e.Message);
					return XmlReadStatus.InvalidFile;
				}

				/* only take into account the first element: if there is more elements, print a message */
				if (instrElements.Count != 0)
					rcInstrument [i].waveId = instrElements [0].InnerText;
				if (instrElements.Count > 1)
					Common.WriteMessage (Common.VerbosityLevel.Normal, "More than one Wave element for instrument" + rcInstrument [i].id);

				/* Get inner element attack */
				try {
					instrElements = node.SelectNodes ("attack");	
				} catch (Exception e) {
					Common.WriteMessage (Common.VerbosityLevel.Error, e.Message);
					return XmlReadStatus.InvalidFile;
				}

				/* only take into account the first element: if there is more elements, print a message */
				if (instrElements.Count != 0)
					rcInstrument [i].attack = Convert.ToDouble (instrElements [0].InnerText);
				if (instrElements.Count > 1)
					Common.WriteMessage (Common.VerbosityLevel.Normal, "More than one Attack element for instrument" + rcInstrument [i].id);

				/* Get inner element hold */
				try {
					instrElements = node.SelectNodes ("hold");	
				} catch (Exception e) {
					Common.WriteMessage (Common.VerbosityLevel.Error, e.Message);
					return XmlReadStatus.InvalidFile;
				}

				/* only take into account the first element: if there is more elements, print a message */
				if (instrElements.Count != 0)
					rcInstrument [i].hold = Convert.ToDouble (instrElements [0].InnerText);
				if (instrElements.Count > 1)
					Common.WriteMessage (Common.VerbosityLevel.Normal, "More than one Hold element for instrument" + rcInstrument [i].id);

				/* Get inner element decay */
				try {
					instrElements = node.SelectNodes ("decay");	
				} catch (Exception e) {
					Common.WriteMessage (Common.VerbosityLevel.Error, e.Message);
					return XmlReadStatus.InvalidFile;
				}

				/* only take into account the first element: if there is more elements, print a message */
				if (instrElements.Count != 0)
					rcInstrument [i].decay = Convert.ToDouble (instrElements [0].InnerText);
				if (instrElements.Count > 1)
					Common.WriteMessage (Common.VerbosityLevel.Normal, "More than one Decay element for instrument" + rcInstrument [i].id);

				/* Get inner element sustain */
				try {
					instrElements = node.SelectNodes ("sustain");	
				} catch (Exception e) {
					Common.WriteMessage (Common.VerbosityLevel.Error, e.Message);
					return XmlReadStatus.InvalidFile;
				}

				/* only take into account the first element: if there is more elements, print a message */
				if (instrElements.Count != 0)
					rcInstrument [i].sustain = Convert.ToDouble (instrElements [0].InnerText);
				if (instrElements.Count > 1)
					Common.WriteMessage (Common.VerbosityLevel.Normal, "More than one Sustain element for instrument" + rcInstrument [i].id);
				
				if (instrElements [0].Attributes.GetNamedItem ("level") != null)
					rcInstrument [i].sustainLevel = Convert.ToDouble (instrElements [0].Attributes.GetNamedItem ("level").Value);
				if (rcInstrument [i].sustainLevel == 0.0)
					Common.WriteMessage (Common.VerbosityLevel.Normal, "Warning: sustain level for instrument " + rcInstrument [i].id + " set to 0 ");

				/* Get inner element release */
				try {
					instrElements = node.SelectNodes ("release");	
				} catch (Exception e) {
					Common.WriteMessage (Common.VerbosityLevel.Error, e.Message);
					return XmlReadStatus.InvalidFile;
				}

				/* only take into account the first element: if there is more elements, print a message */
				if (instrElements.Count != 0)
					rcInstrument [i].release = Convert.ToDouble (instrElements [0].InnerText);
				if (instrElements.Count > 1)
					Common.WriteMessage (Common.VerbosityLevel.Normal, "More than one Release element for instrument" + rcInstrument [i].id);

				i++;
			}

			/* Ensuite les melodies */
			try {
				MelodyList = RessourceNode.SelectNodes ("melody");
			} catch (Exception e) {
				Common.WriteMessage (Common.VerbosityLevel.Error, e.Message);
				return XmlReadStatus.InvalidFile;
			}

			rcMelody = new RessourcesMelody[MelodyList.Count];
			i = 0;
			Common.WriteMessage (Common.VerbosityLevel.Verbose, "Nbr of melodys to convert: " + rcMelody.Length);

			foreach (XmlNode node in MelodyList) {
				rcMelody [i] = new RessourcesMelody ();

				rcMelody [i].id = "";
				rcMelody [i].channels = null;
				rcMelody [i].filename = "";

				if (node.Attributes.GetNamedItem ("id") != null)
					rcMelody [i].id = node.Attributes.GetNamedItem ("id").Value;

				if (rcMelody [i].id == "") {
					Common.WriteMessage (Common.VerbosityLevel.Normal, "Unset id for melody. Set as melody_" + i);
					rcMelody [i].id = "melody_" + i;
				}

				XmlNodeList melodyElements;

				/* Get inner element channels */
				try {
					melodyElements = node.SelectNodes ("channel");	
				} catch (Exception e) {
					Common.WriteMessage (Common.VerbosityLevel.Error, e.Message);
					return XmlReadStatus.InvalidFile;
				}

				if (melodyElements.Count != 0) {
					RessourcesChannel[] channels = new RessourcesChannel[16];
					rcMelody [i].channels = channels;

					for (int counter=0; counter<16; counter++) {
						channels [counter] = new RessourcesChannel ();
						channels [counter].instrument = "SYNTH_DefaultInstr";
						channels [counter].volume = 100.0;
					}

					for (int channelCounter = 0; channelCounter < melodyElements.Count; channelCounter++) {
						byte channelnbr;

						try {
							channelnbr = Convert.ToByte (melodyElements [channelCounter].InnerText);
						} catch  {
							Common.WriteMessage (Common.VerbosityLevel.Error, "Channel nbr " + melodyElements [channelCounter].InnerText + " for melody " + rcMelody [i].id + " is invalid.");
							return XmlReadStatus.InvalidFile;
						}

						if (channelnbr >= 16) {
							Common.WriteMessage (Common.VerbosityLevel.Error, "Channel nbr " + channelnbr + " for melody " + rcMelody [i].id + " is invalid.");
							return XmlReadStatus.InvalidFile;
						}

						if (melodyElements [channelCounter].Attributes.GetNamedItem ("instrument") != null)
							channels [channelnbr].instrument = melodyElements [channelCounter].Attributes.GetNamedItem ("instrument").Value;
						else
							channels [channelnbr].instrument = "";

						if (melodyElements [channelCounter].Attributes.GetNamedItem ("volume") != null)
							try {
								channels [channelnbr].volume = Convert.ToDouble (melodyElements [channelCounter].Attributes.GetNamedItem ("volume").Value);
							} catch {
								Common.WriteMessage (Common.VerbosityLevel.Error, "Volume value " + melodyElements [channelCounter].Attributes.GetNamedItem ("volume").Value + " is invalid for melody " + rcMelody [i].id);
								return XmlReadStatus.InvalidFile;
							}
					}
				} else
					Common.WriteMessage (Common.VerbosityLevel.Normal, "No channel configuration for melody " + rcMelody [i].id);

				/* Get inner element channels */
				try {
					melodyElements = node.SelectNodes ("midi");	
				} catch (Exception e) {
					Common.WriteMessage (Common.VerbosityLevel.Error, e.Message);
					return XmlReadStatus.InvalidFile;
				}

				if (melodyElements.Count != 0) {
					rcMelody [i].filename = melodyElements [0].InnerText;
				} else {
					Common.WriteMessage (Common.VerbosityLevel.Error, "No midi file given for melody " + rcMelody [i].id);
					return XmlReadStatus.InvalidFile;
				}
					
				i++;
			}
			return XmlReadStatus.Success;
		}
	}
}
	