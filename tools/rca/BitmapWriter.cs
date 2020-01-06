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

namespace rca
{
	/// <summary>
	/// Bitmap writer.
	/// </summary>
	public class BitmapWriter
	{
		GeneratedFiles gf;

		/// <summary>
		/// Initializes a new instance of the BitmapWriter class.
		/// </summary>
		/// <param name="name">Name.</param>
		/// <param name="baseFileName">Base file name, without extension.</param>
		/// <param name="conversion">converted bitmap.</param>
		public BitmapWriter (GeneratedFiles gf)
		{
			this.gf = gf;
		}

		public bool Convert (RessourcesImage[] rcimages)
		{	Bitmap bmp;
		
			foreach (RessourcesImage img in rcimages)
			{
				bmp = null;

				try
				{
					bmp = new Bitmap(img.filename);
				}
				catch (ArgumentException ) {
					Common.WriteMessage(Common.VerbosityLevel.Error,"Image "+ img.id+" : " + img.filename + " not found => Ignored");
				}
				catch (Exception e)
				{
					Common.WriteMessage(Common.VerbosityLevel.Error,e.Message);
					return false;
				}

				if (bmp != null) {
					Common.WriteMessage (Common.VerbosityLevel.Normal, "Processing image id " + img.id);
					BitmapConvertion conversion = new BitmapConvertion (bmp, img.color);

					Common.WriteMessage (Common.VerbosityLevel.Verbose, "File infos:");
					Common.WriteMessage (Common.VerbosityLevel.Verbose, "\tHeight: " + bmp.Height);
					Common.WriteMessage (Common.VerbosityLevel.Verbose, "\tWidth: " + bmp.Width);
					Common.WriteMessage (Common.VerbosityLevel.Verbose, "\tPixelFormat: " + bmp.PixelFormat);

					conversion.ConvertColorFormat ();

					conversion.PackBitmap ();
					Common.WriteMessage (Common.VerbosityLevel.Verbose, "");
					Common.WriteMessage (Common.VerbosityLevel.Verbose, "\tPacked size: " + conversion.pixelsList.Count);

					if (Common.language == Common.Languages.C) {
						WriteBody_C (img.id, conversion);
						WriteSpecs_C (img.id, conversion);
					} else {
						WriteBody_ADA (img.id, conversion);
						WriteSpecs_ADA (img.id, conversion);
					}
				}
			}

			return true;
		}

		private bool WriteBody_C(string id, BitmapConvertion conversion)
		{
			/* Fill the body */
			gf.body.WriteLine("const PackedBMP_data "+ id + "_Data[] = {");

			if (Common.colorFormat == Common.ColorFormat.RGB16) {
				for (int i = 0; i < conversion.pixelsList.Count-1; i++) {
					gf.body.WriteLine ("\t{ 0x" + conversion.pixelsList [i].pixel_16b.ToString ("X") + "," + conversion.pixelsList [i].length + " },");
				}

				gf.body.WriteLine ("\t{ 0x" + conversion.pixelsList [conversion.pixelsList.Count-1].pixel_16b.ToString ("X") + "," + conversion.pixelsList [conversion.pixelsList.Count-1].length + " }");
			} else {
				for (int i = 0; i < conversion.pixelsList.Count-1; i++) {
					gf.body.WriteLine ("\t{ 0x" + conversion.pixelsList [i].pixel_8b.ToString ("X") + "," + conversion.pixelsList [i].length + " },");
				}

				gf.body.WriteLine ("\t{ 0x" + conversion.pixelsList [conversion.pixelsList.Count-1].pixel_8b.ToString ("X") + "," + conversion.pixelsList [conversion.pixelsList.Count-1].length + " }");
			}

			gf.body.WriteLine("};"+ Environment.NewLine);
			gf.body.WriteLine("const PackedBMP_Header " + id + " = {");
			gf.body.WriteLine("\t"+conversion.GetWidth()+","+conversion.GetHeight()+",");
			gf.body.WriteLine("\t" + conversion.pixelsList.Count + ",");
			gf.body.WriteLine("\t(PackedBMP_data*) " + id + "_Data };"+ Environment.NewLine);

			return true;
		}

		private bool WriteSpecs_C(string id, BitmapConvertion conversion)
		{
			/* Fill the specs */
			gf.spec.WriteLine("extern const PackedBMP_Header " + id + ";"+ Environment.NewLine);

			return true;
		}

		private bool WriteBody_ADA(string id, BitmapConvertion conversion)
		{
			return true;
		}

		private bool WriteSpecs_ADA(string id, BitmapConvertion conversion)
		{
			/* Fill the specifications */

			/* First fill image data array */
			gf.spec.WriteLine("\t" + id+ "_Data : aliased constant PACK_BITMAP :=");
			gf.spec.WriteLine("\t(");

			if (Common.colorFormat == Common.ColorFormat.RGB16) {
				for (int i = 0; i < conversion.pixelsList.Count-1; i++) {
					gf.spec.WriteLine ("\t\t(16#" + conversion.pixelsList [i].pixel_16b.ToString ("X") + "#," + conversion.pixelsList [i].length + "),");
				}

				gf.spec.WriteLine ("\t\t(16#" + conversion.pixelsList [conversion.pixelsList.Count-1].pixel_16b.ToString ("X") + "#," + conversion.pixelsList [conversion.pixelsList.Count-1].length + ")");
			} else {
				for (int i = 0; i < conversion.pixelsList.Count-1; i++) {
					gf.spec.WriteLine ("\t\t(16#" + conversion.pixelsList [i].pixel_8b.ToString ("X") + "#," + conversion.pixelsList [i].length + "),");
				}

				gf.spec.WriteLine ("\t\t(16#" + conversion.pixelsList [conversion.pixelsList.Count-1].pixel_8b.ToString ("X") + "#," + conversion.pixelsList [conversion.pixelsList.Count-1].length + ")");
			}

			gf.spec.WriteLine("\t);"+ Environment.NewLine);

			/* Next, create a PACK_BITMAP access for previously generated array */
			gf.spec.WriteLine("\t" + id + "_Data_Access : PACK_BITMAP_ACCESS := " + id + "_Data'Access;" + Environment.NewLine);

			/* Finally, create and fill PACK_IMAGE struct */
			gf.spec.WriteLine("\t" + id + " : constant PACK_IMAGE :=");
			gf.spec.WriteLine("\t(");
			gf.spec.WriteLine("\t\t"+conversion.GetWidth()+", "+conversion.GetHeight()+",");
			gf.spec.WriteLine("\t\t" + id +"_Data_Access");
			gf.spec.WriteLine("\t);"+ Environment.NewLine);
			return true;
		}
	}
}
	