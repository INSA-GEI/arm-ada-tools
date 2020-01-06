//
//  SerialLink.cs
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
using System.IO.Ports;
using System.Threading;

namespace adashell
{
	public class SerialLink: SerialPort
	{
		public delegate void dataReceived(object sender, SerialDataReceivedEventArgs e);

		public event dataReceived StandardDataReceivedEvent;

		private Thread readThread;

		public enum SerialLinkMode
		{
			None,
			Standard,
			Download
		};

		public SerialLinkMode mode;

		public SerialLink ()
		{
			this.BaudRate = 500000;
			this.DataBits = 8;
			this.Handshake = Handshake.None;
			this.Parity = Parity.None;
			this.ReadBufferSize = 100;
			this.ReadTimeout = SerialPort.InfiniteTimeout;
			this.WriteBufferSize = 100;
			this.WriteTimeout = SerialPort.InfiniteTimeout;
			this.StopBits = StopBits.One;
			this.mode = SerialLinkMode.None;

			readThread = new Thread (new ThreadStart (ReadThread));
			if (readThread != null) {
				readThread.Name = "SerialCom thread";
			}
		}

		public new void Open ()
		{
			base.Open ();

			if (this.IsOpen) {

				if (readThread.ThreadState== ThreadState.Unstarted)
				{
					readThread.Start ();
				}
			}
		}

		public void Terminate ()
		{
			if (readThread.ThreadState != ThreadState.Unstarted) {
				readThread.Abort ();
				readThread.Join ();
			}

			base.Close ();
		}

		public void ResumeThread ()
		{
			readThread.Interrupt();
		}

		private void ReadThread ()
		{
			while (this.IsOpen)
			{
				if (mode == SerialLinkMode.Standard) 
				{
					if (this.BytesToRead >0)
					{
						DebugMessages.WriteLine ("Size to read: "+this.BytesToRead);
						if (StandardDataReceivedEvent != null) 
							StandardDataReceivedEvent(this, null);
					}

					Thread.Sleep(100);
				}
				else
				{
					try {
						DebugMessages.WriteLine ("Thread "+ Thread.CurrentThread.Name+" going to sleep infinitly");
						Thread.Sleep (Timeout.Infinite);
					}
#pragma warning disable 0168
					catch (ThreadInterruptedException e)
#pragma warning restore 0168
					{
						DebugMessages.WriteLine ("Thread "+ Thread.CurrentThread.Name+" awake");
						/* Nothing to do here */
					}
				}
			} 
		}
	}
}

