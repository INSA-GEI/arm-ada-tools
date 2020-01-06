//
//  about.cs
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
using System.Reflection;
using System.Reflection.Emit;

namespace flashprog
{
	public static class about
	{
		public static void WelcomeBanner ()
		{
			Version version = typeof(MainClass).Assembly.GetName().Version;
			Type attributeType = typeof(AssemblyCopyrightAttribute);

			attributeType.Assembly.ToString ();
			Console.WriteLine("flashprog version " + version);
			Console.WriteLine("INSA - GEI 2018");
		}

		public static void Help ()
		{
			Console.WriteLine("Usage:");
			Console.WriteLine("flashprog {options} filename");
			Console.WriteLine("where options are:");
			Console.WriteLine("     -p=[portname] : Define portname as the tty port to use to connect to the target");
			Console.WriteLine("                     by default use the first /dev/ttyUSBx device found");
			Console.WriteLine("     -s=[speed]    : Define speed (default is "+ parameters.baudrate +" bauds)");
			Console.WriteLine("     -b=[size]     : Define packet size, in byte (default is "+ parameters.blockSize +" bytes)");
			Console.WriteLine("     -r            : Don't send reset command to the target at the end of an upload");
			Console.WriteLine("     -v            : Show more infos");
			Console.WriteLine("     -h            : Show this help");
			Console.WriteLine("");
		}
	}
}
	