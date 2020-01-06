//
//  SerialLink.cs
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
	public class SerialLink: System.IO.Ports.SerialPort
	{
		public enum ComState
		{
			Success,
			InvalidPortNameError,
			PortBusyError,
			UnknownError
		};

		public SerialLink (string port, int baudrate)
		{
			this.PortName = port;
			this.BaudRate = baudrate;
			//this.BaudRate = 230400;
			this.NewLine = "\n";
			this.Parity = System.IO.Ports.Parity.None;
			this.DataBits = 8;
			this.StopBits = System.IO.Ports.StopBits.One;
			this.Handshake = System.IO.Ports.Handshake.None;

			this.ReadBufferSize = 24;
			this.ReadTimeout = 500;

			this.WriteBufferSize = 4096*2;
			this.WriteTimeout = InfiniteTimeout;
		}

		public new ComState Open ()
		{
			ComState state = ComState.Success;

			try {
				base.Open ();
			} catch (System.IO.IOException e) {
				if (e.Message.Contains ("Device or resource busy")) state = ComState.PortBusyError;
				else if (e.Message.Contains ("No such file or directory")) state= ComState.InvalidPortNameError;
				else 
				{
					state= ComState.UnknownError;
					Console.WriteLine (e);
				}
			}
#pragma warning disable 0168
			catch(ArgumentException e) {
#pragma warning restore 0168
				state= ComState.InvalidPortNameError;
				Console.WriteLine (e.Message);
			}
			catch(Exception e) {
				state= ComState.UnknownError;
				Console.WriteLine (e);
			}

			return state;
		}

		public static string GetDefaultPort ()
		{
			string portName = "";
			string[] portList = System.IO.Ports.SerialPort.GetPortNames ();

			foreach (string name in portList) {
				if (name.Contains("USB"))
				{
					if (portName.Equals("")) portName = name;
				}
			}

			//if (portName.Equals("")) portName="/dev/ttyUSB0";

			return portName;
		}
	}
}
	