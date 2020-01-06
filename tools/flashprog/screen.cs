//
//  screen.cs
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
	public class ProgressBar
	{
		protected string EmptyProgressBar;
		protected string emptyLine;
		protected int progressbarLength = 30;

		public ProgressBar ()
		{
			emptyLine =new string(' ', Console.WindowWidth-1);
		}

		public void Erase()
		{
			Console.CursorLeft = Console.WindowLeft;
			Console.Write(emptyLine);
			Console.CursorTop++;
			Console.CursorLeft = Console.WindowLeft;
			Console.Write(emptyLine);

			Console.CursorTop--;
			Console.CursorLeft = Console.WindowLeft;

			Console.CursorVisible=true;
		}

		public void Clear()
		{
			Console.CursorVisible=false;

			Console.CursorLeft = Console.WindowLeft;
			Console.WriteLine(emptyLine);
			Console.Write(emptyLine);
			Console.CursorLeft = Console.WindowLeft;

			Draw(" ", 0);

			Console.CursorTop--;
			Console.CursorLeft = Console.WindowLeft;
		}

		protected void Draw(string text, int val)
		{
			string hashString;
			string emptyString;

			int value =val;

			if (value <0) value = 0;
			if (value >100) value =100;

			hashString=	new string ('#', (val*progressbarLength/100));
			emptyString = new string(' ', progressbarLength - (val*progressbarLength/100));

			Console.Write(text + " ["+hashString + emptyString+ "] "+val+"%");
		}

		public void Set (string title, string text, int val)
		{
			Console.CursorLeft = Console.WindowLeft;
			Console.WriteLine(title);

			Console.CursorLeft = Console.WindowLeft;

			Draw(text, val);
			Console.CursorTop--;
			Console.CursorLeft = Console.WindowLeft;
		}
	}
}

