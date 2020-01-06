//
//  DebugMessages.cs
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
	public static class VerboseMessages
	{
		public static void WriteLine (string s)
		{
			if (parameters.verbose) {
				Console.WriteLine (s);
			}
		}

		public static void Write (string s)
		{
			if (parameters.verbose) {
				Console.Write (s);
			}
		}
	}

	public static class DebugMessages
	{
		private static string filename = @"flashprog.log";

		public static void Init ()
		{
			try {
				using (System.IO.StreamWriter file = new System.IO.StreamWriter(filename)) {
					try {
						file.WriteLine ("flashprog " + typeof(MainClass).Assembly.GetName().Version + 
							" run " + DateTime.Now + 
							" by " + System.Environment.UserName +
							" on " + System.Environment.MachineName + "\n"
						); 
					} finally {
						//do nothing
					}
				}
			} finally {
				//do nothing
			}
		}

		public static void WriteLine (string s)
		{
			try {
				using (System.IO.StreamWriter file = new System.IO.StreamWriter(filename, true)) {
					try {
						file.WriteLine (s);
					} finally {
						// do nothing
					}
				}
			} finally {
				// do nothing
			}
		}

public static void Write (string s)
		{
			try {
				using (System.IO.StreamWriter file = new System.IO.StreamWriter(filename, true)) {
					try {
						file.Write (s);
					} finally {
						// do nothing
					}
				}
			} finally {
				// do nothing
			}
		}
	}
}
	