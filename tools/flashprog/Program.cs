//
//  Main.cs
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
using System.Diagnostics;

namespace flashprog
{
	class MainClass
	{
		public static SerialLink serial;

		public static void Main (string[] args)
		{
			SerialLink.ComState state;
			string errorMessage;
			Download dwnl;

			string portName="";

			DebugMessages.Init();
			about.WelcomeBanner ();

			DebugMessages.Write("flashprog started with arguments: ");
			foreach (string str in args) {
				DebugMessages.Write (str+" ");
			}
			DebugMessages.WriteLine ("");

			if (parameters.Analyse (args, out errorMessage) == false) {
				Console.WriteLine(errorMessage);
				about.Help();
			} else {
				if (parameters.port.Equals("")) portName = SerialLink.GetDefaultPort();
				else portName = parameters.port;

				VerboseMessages.WriteLine("Serial port: " + portName + Environment.NewLine + 
					"Baudrate: " + parameters.baudrate + Environment.NewLine + 
					"Block size: " + parameters.blockSize);
				DebugMessages.WriteLine("Serial port: " + portName + Environment.NewLine + 
					"Baudrate: " + parameters.baudrate + Environment.NewLine + 
					"Block size: " + parameters.blockSize);

				if (portName == "") {
					Console.WriteLine ("No valid connection available. Check target connection");
				} else {
					serial = new SerialLink (portName, parameters.baudrate);
					state = serial.Open ();

					if (state == SerialLink.ComState.Success) {

						VerboseMessages.WriteLine ("Serial port " + serial.PortName + " opened succesfully.");

						if (!parameters.filename.Equals ("")) {
							VerboseMessages.WriteLine ("File to flash: " + parameters.filename);
							DebugMessages.WriteLine ("File to flash: " + parameters.filename);

							dwnl = new Download (parameters.filename);

							Stopwatch stopWatch = new Stopwatch ();

							stopWatch.Start ();
							dwnl.Run ();
							stopWatch.Stop ();

							VerboseMessages.WriteLine ("Download ended with code: " + dwnl.status);
							DebugMessages.WriteLine ("Download ended with code: " + dwnl.status);

							TimeSpan ts = stopWatch.Elapsed;

							Console.WriteLine ("Duration = " + ts.Seconds.ToString() +"," + ts.Milliseconds.ToString().Substring(0,1) + " seconds");
							if (dwnl.status != Download.DownloadState.Success) {
								switch (dwnl.status) {
								case Download.DownloadState.CorruptedFileError:
									Console.WriteLine ("File error: file " + parameters.filename + " is corrupted.");
									break;
								case Download.DownloadState.InvalidFileError:
									Console.WriteLine ("File error: file " + parameters.filename + " is not a valid intel HEX format file.");
									break;
								case Download.DownloadState.NoFileError:
									Console.WriteLine ("File error: unable to open file " + parameters.filename);
									break;
								case Download.DownloadState.InvalidProtocolError:
									Console.WriteLine ("Protocol error: invalid answer from target.");
									break;
								case Download.DownloadState.IOError:
									Console.WriteLine ("Fatal IO error.");
									break;
								case Download.DownloadState.TimeoutError:
									Console.WriteLine ("Timeout error: check target connection.");
									break;
								default:
									Console.WriteLine ("Unknown error : " + dwnl.status.ToString());
									break;
								}
							} else
								Console.WriteLine ("Download successfull.");
							dwnl = null;
						} else {
							Console.WriteLine ("Error: filename not provided");
							DebugMessages.WriteLine ("Error: filename not provided");

							about.Help ();
						}
					} else {
						switch (state) {
						case SerialLink.ComState.InvalidPortNameError:
							Console.WriteLine ("Serial port " + serial.PortName + " does not exist.");
							break;
						case SerialLink.ComState.PortBusyError:
							Console.WriteLine ("Serial port " + serial.PortName + " is busy: close other application using it or wait for port to be ready.");
							break;
						case SerialLink.ComState.UnknownError:
							Console.WriteLine ("Unknown error occured while opening serial port " + serial.PortName + ".");
							break;
						default:
							break;
						}
					}
				}
			}
		}
	}
}

