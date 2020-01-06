//
//  StringWriter.cs
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

//using System.Drawing;

namespace rca
{
	/// <summary>
	/// Bitmap writer.
	/// </summary>
	public class StringWriter
	{
		GeneratedFiles gf;

		/// <summary>
		/// Initializes a new instance of the BitmapWriter class.
		/// </summary>
		/// <param name="name">Name.</param>
		/// <param name="baseFileName">Base file name, without extension.</param>
		/// <param name="conversion">converted bitmap.</param>
		public StringWriter (GeneratedFiles gf)
		{
			this.gf = gf;
		}

		public bool Convert (RessourcesString[] rcstrings)
		{	
			foreach (RessourcesString str in rcstrings)
			{
				Common.WriteMessage (Common.VerbosityLevel.Normal, "Processing string id " + str.id);

				if (Common.language == Common.Languages.C) {
					WriteBody_C (str.id, str.text);
					WriteSpecs_C (str.id, str.text);
				} else {
					WriteBody_ADA (str.id, str.text);
					WriteSpecs_ADA (str.id, str.text);
				}
			}

			return true;
		}

		private bool WriteBody_C(string id, string text)
		{
			/* Fill the body */
			gf.body.WriteLine("const char *"+ id + " = \"" + text + "\";" + Environment.NewLine);

			return true;
		}

		private bool WriteSpecs_C(string id, string text)
		{
			/* Fill the specs */
			gf.spec.WriteLine("extern const char *" + id + ";"+ Environment.NewLine);

			return true;
		}

		private bool WriteBody_ADA(string id, string text)
		{
			return true;
		}

		private bool WriteSpecs_ADA(string id, string text)
		{
			/* Fill the specifications */

			/* First fill image data array */
			gf.spec.WriteLine("\t" + id+ " : constant STRING := \"" + text + "\";" + Environment.NewLine);

			return true;
		}
	}
}

