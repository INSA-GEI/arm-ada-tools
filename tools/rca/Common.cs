//
//  Common.cs
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

namespace rca
{
	public struct GeneratedFiles
	{
		public TextWriter body;
		public TextWriter spec;

		public string filenameshort;
	}

	/// <summary>
	/// Common.
	/// </summary>
	public static class Common
	{
		/// <summary>
		/// Color format.
		/// </summary>
		public enum ColorFormat
		{
			/// <summary>
			/// The RG b8.
			/// </summary>
			RGB8,

			/// <summary>
			/// The RG b16.
			/// </summary>
			RGB16
		};

		/// <summary>
		/// The color format.
		/// </summary>
		public static ColorFormat colorFormat= ColorFormat.RGB8;

		/// <summary>
		/// Languages.
		/// </summary>
		public enum Languages
		{
			/// <summary>
			/// The c.
			/// </summary>
			C,

			/// <summary>
			/// The AD.
			/// </summary>
			ADA
		};
			
		public enum VerbosityLevel
		{
			Normal,
			Verbose,
			Error
		};

		/// <summary>
		/// The language.
		/// </summary>
		public static Languages language = Languages.C;

		public static bool verbose = false;

		public static bool quiet = false;

		public static string bitmapFilename="";

		public static string baseName=""; 

		public static string jobFile=""; 

		public static void WriteMessage(VerbosityLevel level, string message)
		{
			if (quiet == false)
			{
				if ((verbose == true) || (level != VerbosityLevel.Verbose)) {

					if (level == VerbosityLevel.Error ) Console.WriteLine ("Error: " + message);
					else Console.WriteLine (message);
				}
			}
		}
	}
}

