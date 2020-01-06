//
//  SocketServer.cs
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
using System.Threading;
using System.Net;
using System.Net.Sockets;
using System.Text;

namespace adashell
{
	public class SocketServer
	{
		protected bool isServerStarted=false;

		public enum ServerState
		{
			Started,
			Failed
		}

		public delegate void ServerEventHandler(object sender);
		public event ServerEventHandler TakeSerialPortEvent;
		public event ServerEventHandler LeaveSerialPortEvent;

		protected int port;
		protected TcpListener myList;
		protected Socket s;

		protected Thread serverThread;

		protected const string AcknowledgeCmd = "ack";
		protected const string TakeCmd = "take";
		protected const string LeaveCmd = "leave";

		public SocketServer (int port)
		{
			this.port =port;
		}

		public ServerState Start ()
		{
			ServerState state = ServerState.Started;

			try {
				IPAddress ipAd = Dns.GetHostEntry ("localhost").AddressList [0];
				// use local m/c IP address, and 
				// use the same in the client

				/* Initializes the Listener */
				myList = new TcpListener (ipAd, port);

				/* Start Listeneting at the specified port */        
				myList.Start ();

				serverThread = new Thread (new ThreadStart (ServerThread));
				if (serverThread!=null)
				{
					serverThread.Start();
				}
#pragma warning disable 0168
			} catch (Exception e) {
#pragma warning restore 0168
				isServerStarted = false;
				state = ServerState.Failed;
			} 

			return state;
		}

		public void Stop ()
		{
			if (serverThread != null) {
				if (serverThread.ThreadState != ThreadState.Unstarted) {
					/* Stop thread */
					serverThread.Abort ();
					serverThread.Join ();
				}
			}

			/* clean up */            
			if (s!=null) s.Close();
			if (myList!=null) myList.Stop();
		}

		protected void ServerThread ()
		{
			while (true) {
				//DebugMessages.WriteLine ("Waiting for a connection.....");
	        
				s = myList.AcceptSocket ();
				//DebugMessages.WriteLine ("Connection accepted");

				byte[] b = new byte[100];
				int k = s.Receive (b);

				if (BytetoString(b,k).Equals(TakeCmd))
				{
					RaiseTakeEvent();
				}

				if (BytetoString(b,k).Equals(LeaveCmd))
				{
					RaiseLeaveEvent();
				}
			}
		}

		public void SendAcknowledge()
		{
			ASCIIEncoding asen = new ASCIIEncoding ();

			s.Send (asen.GetBytes ("ack"));
			//DebugMessages.WriteLine ("Sent Acknowledgement");
		}

		protected void RaiseTakeEvent ()
		{
			if (TakeSerialPortEvent != null) {
				TakeSerialPortEvent(this);
			}
		}

		protected void RaiseLeaveEvent ()
		{
			if (LeaveSerialPortEvent != null) {
				LeaveSerialPortEvent(this);
			}
		}

		protected string BytetoString (byte[] b, int length)
		{
			char[] c = new char[length];

			for (int i=0; i<length; i++) {
				c[i]=Convert.ToChar(b[i]);
			}

			string str = new string(c);
			return str;
		}
	}
}

