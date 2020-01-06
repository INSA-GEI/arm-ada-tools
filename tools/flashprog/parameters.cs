//
//  parameters.cs
//
//  Author:
//       DI MERCURIO Sebastien <>
//
//  Copyright (c) 2014 dimercur
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

namespace flashprog
{
	static class parameters
	{
		public static string filename="";
		public static string port="";
		public static bool resetAfterDownload=true;
		public static bool verbose=false;
		public static int baudrate=500000;
		public static int blockSize = 1024;

		public static string monitor="";

		public static bool Analyse (string[] args, out string errorMessage)
		{
			bool state = true;
			errorMessage = " ";
			string baudstr;
			string blockstr;

			foreach (string str in args) {
				if (str.Equals ("-r"))
					resetAfterDownload = false;
				else if (str.Equals ("-v"))
					verbose = true;
				else if (str.Equals ("-h")) {
					return false;
				} else if (str.Contains ("-p=")) {
					if (port.Equals (""))
						port = str.Substring (3);
					else {
						errorMessage = "Too much ports defined.";
						return false;
					}
				} else if (str.Contains ("-b=")) {
					blockstr = str.Substring (3);
					blockSize = Convert.ToInt32 (blockstr);

					if (blockSize > 1024) {
						errorMessage = "Block size too big: " + blockSize;
						return false;
					} else if (blockSize < 16) {
						errorMessage = "Block size too small: " + blockSize;
						return false;
					}
				} else if (str.Contains ("-s=")) {
					baudstr = str.Substring (3);
					baudrate = Convert.ToInt32 (baudstr);
				}
				else if (str.StartsWith("-"))
				{
					errorMessage = "Unknown parameter: "+str;
					return false;
				}
				else {
					if (filename.Equals("")) filename = str;
					else {
						errorMessage = "Too much files defined.";
						return false;
					}
				}
			}

			return state;
		}
	}
}
	