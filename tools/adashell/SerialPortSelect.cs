//
//  SerialPortSelect.cs
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
using Gtk;

namespace adashell
{
	public partial class SerialPortSelect : Gtk.Dialog
	{
		public string PortName {
			get {
				return UpdatePortName();
			}
		}

		public bool PortNameSelected=false;

		public SerialPortSelect ()
		{
			//string[] PortNames;
			string[] fileList;

			this.Build ();

			fileList = System.IO.Directory.GetFiles ("/dev");

			if (fileList != null) {
				foreach (string i in fileList) {
					if (i.Contains("ttyUSB") || i.Contains("ttyACM")) comboboxSerialPort.AppendText(i);
				}
			}

			Gtk.TreeIter iter;
			comboboxSerialPort.Model.GetIterFirst(out iter);
			comboboxSerialPort.SetActiveIter(iter);

			this.Show ();
		}

		protected string UpdatePortName ()
		{
			string name;

			name = comboboxSerialPort.ActiveText;
			if (name == null) name = "";

			return name;
		}

		protected void OnButtonOkClicked (object sender, EventArgs e)
		{
			//UpdatePortName();
		}
	}
}

