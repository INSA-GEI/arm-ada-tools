//
//  DebugMessage.cs
//
//  Author:
//       dimercur <${AuthorEmail}>
//
//  Copyright (c) 2014 dimercur
//
//  This library is free software; you can redistribute it and/or modify
//  it under the terms of the GNU Lesser General Public License as
//  published by the Free Software Foundation; either version 2.1 of the
//  License, or (at your option) any later version.
//
//  This library is distributed in the hope that it will be useful, but
//  WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
//  Lesser General Public License for more details.
//
//  You should have received a copy of the GNU Lesser General Public
//  License along with this library; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

using System;

namespace adashell
{
	public static class VerboseMessages
	{
		public static void WriteLine (string s)
		{
			Console.WriteLine (s);
		}

		public static void Write (string s)
		{
			Console.Write (s);
		}
	}

	public static class DebugMessages
	{
		private static string filename = @"adashell.log";

		public static void Init ()
		{
			try {
				using (System.IO.StreamWriter file = new System.IO.StreamWriter(filename)) {
					try {
						file.WriteLine ("Adashell " + typeof(MainClass).Assembly.GetName().Version + 
							" run " + DateTime.Now + 
							" by " + System.Environment.UserName +
							" on " + System.Environment.MachineName + "\n"
						); 
					} finally {
						//do nothing
					}
				}
#pragma warning disable 0168
			} catch (Exception e) {
#pragma warning restore 0168
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
#pragma warning disable 0168
			} catch (Exception e) {
#pragma warning restore 0168
				// do nothing
			}

			Console.WriteLine (s);
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
#pragma warning disable 0168
			} catch (Exception e) {
#pragma warning restore 0168
				// do nothing
			}

			Console.Write (s);
		}

		public static void Write (char c)
		{
			try {
				using (System.IO.StreamWriter file = new System.IO.StreamWriter(filename, true)) {
					try {
						file.Write (c);
					} finally {
						// do nothing
					}
				}
#pragma warning disable 0168
			} catch (Exception e) {
#pragma warning restore 0168
				// do nothing
			}

			Console.Write (c);
		}
	}
}

