//
//  About.cs
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
using System.Diagnostics;
using System.Reflection;
using Mono.Options;
using System.Collections.Generic;

namespace rca
{
	/// <summary>
	/// About.
	/// </summary>
	public class About
	{
		private string programName="";

		private Version programVersion;

		private string copyright = "";
	
		public About()
		{
			programVersion= typeof(MainProgram).Assembly.GetName().Version;
			programName = typeof(MainProgram).Assembly.GetName ().Name;
			Assembly currentAssem = typeof(About).Assembly;

			object[] attribs = currentAssem.GetCustomAttributes(typeof(AssemblyCopyrightAttribute), true);
			if (attribs.Length > 0)
			{
				copyright = ((AssemblyCopyrightAttribute)attribs [0]).Copyright;
			}
		}

		/// <summary>
		/// Welcomes the banner.
		/// </summary>
		public void WelcomeBanner ()
		{
			Common.WriteMessage(Common.VerbosityLevel.Normal,programName + " version " + programVersion.ToString());
			Common.WriteMessage(Common.VerbosityLevel.Normal,copyright + "\n");
		}

		/// <summary>
		/// Help this instance.
		/// </summary>
		public void Help ()
		{
			Common.WriteMessage(Common.VerbosityLevel.Normal,"Usage:");
			Common.WriteMessage(Common.VerbosityLevel.Normal,programName + " [options] job_file");
			Common.WriteMessage(Common.VerbosityLevel.Normal,"where options are:");
			Common.WriteMessage(Common.VerbosityLevel.Normal,"     -q     : Make " + programName + " quiet: no message other than error are printed");
			Common.WriteMessage(Common.VerbosityLevel.Normal,"     -v     : Make " + programName + " verbose: lot of debugging infos are printed");
			Common.WriteMessage(Common.VerbosityLevel.Normal,"     -h     : Show this help");
			Common.WriteMessage(Common.VerbosityLevel.Normal,"");
		}

		public bool ParseCmd(string[] args)
		{

			bool showHelp=false;

			var p = new OptionSet () {
				{
					"v|verbose","Increase debug messages verbosity",
					v => { if (v!=null) Common.verbose = true;}
				},
				{
					"q|quiet","Make program totally quiet (even if verbosity is set)",
					v => { if (v!=null) Common.quiet = true;}
				},
				{
					"h|help","Show this message and exit",
					v => { if (v!=null) showHelp = true;}
				}

			};

			List<string> extra = new List<string>(10);
			try {
				extra = p.Parse (args);
			}
			catch /*(OptionException e)*/ {
				//Common.WriteMessage(Common.VerbosityLevel.Error,e.Message);
				//Common.WriteMessage(Common.VerbosityLevel.Normal,"Try `"+programName+" --help' for more information.");

				//return false;
			}

			if (showHelp) {
				this.Help ();
			}

			if (extra.Count >0) {
				Common.jobFile = extra [0];
			}
			else {
				//Common.WriteMessage(Common.VerbosityLevel.Error,"No job file");
				//Common.WriteMessage(Common.VerbosityLevel.Normal,"Try `"+programName+" --help' for more information.");

				//return false;
			}

			return true;
		}
	}
}

