//
//  client.cs
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
using System.Net;
using System.IO;
using System.Net.Sockets;
using System.Text;

namespace flashprog
{
	public class ClientSocket
	{
		protected bool isServerOpened = false;
		protected int port;

		protected const string AcknowledgeCmd = "ack";
		protected const string TakeCmd = "take";
		protected const string LeaveCmd = "leave";

		protected TcpClient tcpclnt;

		public ClientSocket (int port)
		{
			this.port = port;
		}

		public void Open ()
		{
			isServerOpened = true;

			try {
				tcpclnt = new TcpClient ();
				DebugMessages.WriteLine ("Connecting.....");
	            
				IPAddress ipAd = Dns.GetHostEntry ("localhost").AddressList [0];
				tcpclnt.Connect (ipAd.ToString (), port);
				// use the ipaddress as in the server program
	            
				DebugMessages.WriteLine ("Connected");
#pragma warning disable 0168
			} catch (Exception e) {
#pragma warning restore 0168
				isServerOpened = false;
			}
		}

		public void Close ()
		{
			if (tcpclnt != null) tcpclnt.Close();
		}

		public void SendTakecmd ()
		{
			Stream stm;
			int k=0;
			byte[] bb = new byte[100];

			try {
				stm = tcpclnt.GetStream ();
				stm.ReadTimeout = 1000;

				DebugMessages.WriteLine ("Send Take command");

				ASCIIEncoding asen = new ASCIIEncoding ();
				byte[] ba = asen.GetBytes (TakeCmd);
				stm.Write (ba, 0, ba.Length);

				k = stm.Read (bb, 0, 100);
#pragma warning disable 0168
			} catch (Exception e) {
#pragma warning restore 0168
				// do nothing
			}
   
			if (k != 0) {
				if (System.Text.Encoding.ASCII.GetString(bb).Equals(AcknowledgeCmd))
				{
				}
			}
		}

		public void SendLeavecmd ()
		{
			Stream stm;
			int k=0;
			byte[] bb = new byte[100];

			try {
				stm = tcpclnt.GetStream ();
				stm.ReadTimeout = 1000;

				DebugMessages.WriteLine ("Send Leave command");

				ASCIIEncoding asen = new ASCIIEncoding ();
				byte[] ba = asen.GetBytes (LeaveCmd);
				stm.Write (ba, 0, ba.Length);

				k = stm.Read (bb, 0, 100);
#pragma warning disable 0168
			} catch (Exception e)  {
#pragma warning restore 0168
				// do nothing
			}
   
			if (k != 0) {
				if (System.Text.Encoding.ASCII.GetString(bb).Equals(AcknowledgeCmd))
				{
				}
			}
		}
	}
}

