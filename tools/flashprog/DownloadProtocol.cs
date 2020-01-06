//
//  DownloadProtocol.cs
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
	public class DownloadProtocol
	{
		private SerialLink serial;

		public enum ProtocolStatus
		{
			Success,
			TimeoutError,
			ConnectionError,
			TransmissionError,
			ChecksumError
		};

		public const string connectionPattern="`````";
		public enum Protocol
		{
			Acq='A',
			NotAcq='N',
			InvalidChecksum='I',
			Erase='E',
			SetAddress='@',
			Program='P',
			Checksum='V',
			Reset='R',
			Filename='F'
		};

		protected const int maxRetries = 3;

		public DownloadProtocol ()
		{
			this.serial = MainClass.serial;
		}

		public ProtocolStatus Connect ()
		{
			return SendCommand(connectionPattern);
		}

		public ProtocolStatus Erase (UInt32 startAddress, UInt32 endAddress)
		{
			String cmd;

			cmd = ((char)Protocol.Erase) + ToHex(startAddress)+ToHex(endAddress);
			cmd = cmd.ToUpper();
			cmd = cmd + AddChecksum(cmd);

			return SendCommand(cmd);
		}

		public ProtocolStatus SetAddress (UInt32 address)
		{
			String cmd;

			cmd = ((char)Protocol.SetAddress) + ToHex(address);
			cmd = cmd.ToUpper();
			cmd = cmd + AddChecksum(cmd);

			return SendCommand(cmd);
		}

		public ProtocolStatus SetFilename (UInt32 NbrBlock, int BlockSize,  String Filename)
		{
			String cmd;

			cmd = ((char)Protocol.Filename) + ToHex((Byte)((Byte)Filename.Length+6)) + ToHex((UInt16)BlockSize) + ToHex(NbrBlock) + Filename;
			cmd = cmd.ToUpper();
			cmd = cmd + AddChecksum(cmd);

			return SendCommand(cmd);
		}

		public ProtocolStatus Program (byte[] data, UInt16 Index)
		{
			String cmd;

			cmd = ((char)Protocol.Program).ToString();
			cmd = cmd + ToHex(Index);

			foreach (byte b in data) {
				cmd = cmd + ToHex(b);
			}
			cmd = cmd.ToUpper();
			cmd = cmd + AddChecksum(cmd);

			return SendCommand(cmd);
		}

		public ProtocolStatus Verify (UInt32 startAddress, UInt32 endAddress, UInt16 checksum)
		{
			String cmd;

			cmd = ((char)Protocol.Checksum).ToString();
			cmd = cmd + ToHex(startAddress) + ToHex(endAddress) + ToHex(checksum);
			cmd = cmd.ToUpper();
			cmd = cmd + AddChecksum(cmd);

			return SendCommand(cmd);
		}

		public ProtocolStatus Reset ()
		{
			String cmd;

			cmd = ((char)Protocol.Reset).ToString();
			cmd = cmd.ToUpper();
			cmd = cmd + AddChecksum(cmd);

			serial.WriteLine (cmd);

			if (parameters.verbose == true)
				DebugMessages.WriteLine("Serial::write : " + cmd);
			
			return ProtocolStatus.Success;
		}

		protected ProtocolStatus SendCommand (string cmd)
		{
			ProtocolStatus status = ProtocolStatus.TransmissionError;
			byte answer;
			int retries = maxRetries;
			bool timeout;
			Stopwatch stopWatch = new Stopwatch ();
			TimeSpan ts1,ts2;

			do {
     			timeout = false;
				answer = (byte)Protocol.NotAcq;

				if (parameters.verbose == true)
					DebugMessages.WriteLine("Serial::write : " + cmd);

				stopWatch.Start ();
				serial.WriteLine (cmd);
				stopWatch.Stop ();
				ts1 = stopWatch.Elapsed;

				stopWatch.Reset();

				try {
					stopWatch.Start ();
					answer = (byte)serial.ReadByte ();
					stopWatch.Stop ();
					ts2 = stopWatch.Elapsed;
					stopWatch.Reset();

					if (parameters.verbose == true)
						DebugMessages.WriteLine("Serial::read : " + (char)answer);
					
#pragma warning disable 0168
				} catch (TimeoutException e) {
#pragma warning restore 0168
					timeout = true;
					DebugMessages.WriteLine ("Timeout ");
				}
#pragma warning disable 0168
				catch (System.IO.IOException e) {
#pragma warning restore 0168
					DebugMessages.WriteLine ("Unknown IOException ??");
				}

				if (timeout == false) {
					if (answer == (byte)Protocol.Acq) {
						status = ProtocolStatus.Success;
						retries=0;

						DebugMessages.WriteLine ("Write = "+ ts1.Milliseconds + " ms | Read = "+ ts2.Milliseconds +" ms");
					}
					else if (answer == (byte)Protocol.InvalidChecksum)
						status = ProtocolStatus.ChecksumError;
					else
						status = ProtocolStatus.TransmissionError;
				} else
					status = ProtocolStatus.TimeoutError;

				retries--;
			} while (retries>0);

			if (status == ProtocolStatus.TransmissionError) {
				if (cmd==connectionPattern) {
					status= ProtocolStatus.ConnectionError;
					DebugMessages.WriteLine("Connection error: "+answer);
				}
				else DebugMessages.WriteLine("Invalid answer: "+answer);
			}
			else if (status == ProtocolStatus.TimeoutError) DebugMessages.WriteLine("Timeout !!");
			else if (status == ProtocolStatus.ChecksumError) DebugMessages.WriteLine("Checksum error");

			return status;
		}

		public string ToHex (UInt32 val)
		{
			string str;

			str =ToHex((byte)(val>>24)) + ToHex((byte)(val>>16)) + ToHex((byte)(val>>8)) + ToHex((byte)val);
			return str;
		}

		public string ToHex (UInt16 val)
		{
			string str;

			str = ToHex((byte)(val>>8)) + ToHex((byte)val);
			return str;
		}

		public string ToHex (byte val)
		{
			string str;

			str = Convert.ToString (val, 16);
			if (val < 0x10) {
				str = '0' + str;
			}

			return str.ToUpper();
		}

		protected string AddChecksum (string str)
		{
			byte checksum = 0;
			byte val;
			int i = 0;

			foreach (char c in str) {
				val = (byte)c;
				checksum = (byte)(checksum ^ val);
				i++;
			}

			return ToHex(checksum);
		}
	}
}
	