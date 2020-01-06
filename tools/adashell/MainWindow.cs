//
//  MainWindows.cs
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
using Gtk;
using System.IO.Ports;
using System.Threading;

using adashell;

public partial class MainWindow: Gtk.Window
{	
	SerialLink serial;
	TextArea textarea;
	ScrolledWindow scrolledwin;
	SocketServer server;

	private const int serverPort = 10010;

	private bool serialPortOpen=false;
	private string serialPortName="";

	public MainWindow (): base (Gtk.WindowType.Toplevel)
	{
		//Build ();
		MyBuild();

		StatusBar.Push(1,"Not connected (use Connection menu)");

		serial = new SerialLink();
		serial.StandardDataReceivedEvent += new SerialLink.dataReceived(this.StandardDataReceived);

		server = new SocketServer(serverPort);
		server.TakeSerialPortEvent += new SocketServer.ServerEventHandler(this.OnTakeSerialPortEvent);
		server.LeaveSerialPortEvent += new SocketServer.ServerEventHandler(this.OnLeaveSerialPortEvent);
		server.Start();

		DebugMessages.Init();
	}

	private void MyBuild()
	{
	global::Stetic.Gui.Initialize (this);
		// Widget MainWindow
		this.UIManager = new global::Gtk.UIManager ();
		global::Gtk.ActionGroup w1 = new global::Gtk.ActionGroup ("Default");
		this.FileAction = new global::Gtk.Action ("FileAction", global::Mono.Unix.Catalog.GetString ("File"), null, null);
		this.FileAction.ShortLabel = global::Mono.Unix.Catalog.GetString ("File");
		w1.Add (this.FileAction, null);
		this.HelpAction = new global::Gtk.Action ("HelpAction", global::Mono.Unix.Catalog.GetString ("Help"), null, null);
		this.HelpAction.ShortLabel = global::Mono.Unix.Catalog.GetString ("Help");
		w1.Add (this.HelpAction, null);
		this.SaveAction = new global::Gtk.Action ("SaveAction", global::Mono.Unix.Catalog.GetString ("Save"), null, null);
		this.SaveAction.ShortLabel = global::Mono.Unix.Catalog.GetString ("Save");
		w1.Add (this.SaveAction, null);
		this.ExitAction = new global::Gtk.Action ("ExitAction", global::Mono.Unix.Catalog.GetString ("Exit"), null, null);
		this.ExitAction.ShortLabel = global::Mono.Unix.Catalog.GetString ("Exit");
		w1.Add (this.ExitAction, null);
		this.ConnectionAction1 = new global::Gtk.Action ("ConnectionAction1", global::Mono.Unix.Catalog.GetString ("Connection"), null, null);
		this.ConnectionAction1.ShortLabel = global::Mono.Unix.Catalog.GetString ("Connect ...");
		w1.Add (this.ConnectionAction1, null);
		this.ConnectionAction = new global::Gtk.Action ("ConnectionAction", global::Mono.Unix.Catalog.GetString ("Connection..."), null, null);
		this.ConnectionAction.ShortLabel = global::Mono.Unix.Catalog.GetString ("Connection...");
		w1.Add (this.ConnectionAction, null);
		this.DisconnectAction = new global::Gtk.Action ("DisconnectAction", global::Mono.Unix.Catalog.GetString ("Disconnect"), null, null);
		this.DisconnectAction.ShortLabel = global::Mono.Unix.Catalog.GetString ("Disconnect");
		w1.Add (this.DisconnectAction, null);
		this.UIManager.InsertActionGroup (w1, 0);
		this.AddAccelGroup (this.UIManager.AccelGroup);
		this.Name = "MainWindow";
		this.Title = global::Mono.Unix.Catalog.GetString ("Shell for Embedded ADA");
		this.WindowPosition = ((global::Gtk.WindowPosition)(4));
		// Container child MainWindow.Gtk.Container+ContainerChild
		this.vbox1 = new global::Gtk.VBox ();
		this.vbox1.Name = "vbox1";
		this.vbox1.Spacing = 6;
		// Container child vbox1.Gtk.Box+BoxChild
		this.UIManager.AddUiFromString ("<ui><menubar name='menubar2'><menu name='FileAction' action='FileAction'><menuitem name='SaveAction' action='SaveAction'/><menuitem name='ExitAction' action='ExitAction'/></menu><menu name='ConnectionAction1' action='ConnectionAction1'><menuitem name='ConnectionAction' action='ConnectionAction'/><menuitem name='DisconnectAction' action='DisconnectAction'/></menu><menu name='HelpAction' action='HelpAction'/></menubar></ui>");
		this.menubar2 = ((global::Gtk.MenuBar)(this.UIManager.GetWidget ("/menubar2")));
		this.menubar2.Name = "menubar2";
		this.vbox1.Add (this.menubar2);
		global::Gtk.Box.BoxChild w2 = ((global::Gtk.Box.BoxChild)(this.vbox1 [this.menubar2]));
		w2.Position = 0;
		w2.Expand = false;
		w2.Fill = false;
		// Container child vbox1.Gtk.Box+BoxChild
		scrolledwin = new ScrolledWindow ();
		scrolledwin.Name = "GtkScrolledWindow";
		scrolledwin.ShadowType = ((ShadowType)(1));
		// Container child GtkScrolledWindow.Gtk.Container+ContainerChild
		textarea = new TextArea();
		textarea.CanFocus = true;
		textarea.Name = "TextArea";
		scrolledwin.Add (textarea);
		this.vbox1.Add (scrolledwin);
		Box.BoxChild w4 = ((Box.BoxChild)(this.vbox1 [scrolledwin]));
		w4.Position = 1;
		// Container child vbox1.Gtk.Box+BoxChild
		this.StatusBar = new global::Gtk.Statusbar ();
		this.StatusBar.Name = "StatusBar";
		this.StatusBar.Spacing = 6;
		this.vbox1.Add (this.StatusBar);
		global::Gtk.Box.BoxChild w3 = ((global::Gtk.Box.BoxChild)(this.vbox1 [this.StatusBar]));
		w3.Position = 2;
		w3.Expand = false;
		w3.Fill = false;
		this.Add (this.vbox1);
		if ((this.Child != null)) {
			this.Child.ShowAll ();
		}
		this.DefaultWidth = 707;
		this.DefaultHeight = 392;
		this.Show ();
		this.DeleteEvent += new global::Gtk.DeleteEventHandler (this.OnDeleteEvent);
		this.HelpAction.Activated += new global::System.EventHandler (this.OnHelpActionActivated);
		this.SaveAction.Activated += new global::System.EventHandler (this.OnSaveActionActivated);
		this.ExitAction.Activated += new global::System.EventHandler (this.OnExitActionActivated);
		this.ConnectionAction.Activated += new global::System.EventHandler (this.OnConnectionActionActivated);
		this.DisconnectAction.Activated += new global::System.EventHandler (this.OnDisconnectActionActivated);
		this.textarea.KeyEvent += new TextArea.TextAreaKeyEvent(this.TextAreaKeyEvent);

		this.textarea.Sensitive=false;
	}

	protected void OnDownloadProgramActionActivated (object sender, EventArgs e)
	{
	}

	protected void OnTakeSerialPortEvent (object sender)
	{
		Console.WriteLine ("Take event received");
		server.SendAcknowledge ();

		if (serial.IsOpen) {
			serialPortOpen = true;
			serialPortName = serial.PortName;

			/* Arret du thread */
			try {
				serial.Terminate();
#pragma warning disable 0168
			} catch (Exception u) {
#pragma warning restore 0168
			}

			StatusBar.Push (1, "Flashprog is downloading");
			textarea.Sensitive=false;
		}
	}

	protected void OnLeaveSerialPortEvent (object sender)
	{
		Console.WriteLine ("Leave event received");
		server.SendAcknowledge ();

		if (serialPortOpen) {
			serialPortOpen = false;

			serial.PortName = serialPortName;

			try {
				serial.Open();
#pragma warning disable 0168
			} catch (Exception u) {
#pragma warning restore 0168
			}

			if (serial.IsOpen)
			{
				StatusBar.Push (1, "Connected to " + serial.PortName);
				textarea.Sensitive=true;
			}
			else
			{
				StatusBar.Push (1, "Not connected (use Connection menu)");
				textarea.Sensitive=false;
			}
		}
	}

	protected void OnDeleteEvent (object sender, DeleteEventArgs a)
	{
		DebugMessages.WriteLine ("Bye Bye");

		try {
			serial.Terminate ();
		} catch (Exception e) {
			DebugMessages.WriteLine ("Exception caught: "+e);
		}

		try {
			server.Stop();
		} catch (Exception e) {
			DebugMessages.WriteLine ("Exception caught: "+e);
		}

		Application.Quit ();
		a.RetVal = true;
	}

	protected void OnSaveActionActivated (object sender, EventArgs e)
	{

	}	


	protected void OnExitActionActivated (object sender, EventArgs e)
	{
		try {
			serial.Terminate ();
#pragma warning disable 0168
		} catch (Exception u) {
#pragma warning restore 0168
		}

		try {
			server.Stop();
#pragma warning disable 0168
		} catch (Exception u) {
#pragma warning restore 0168
		}
		Application.Quit ();
	}

	protected void OnHelpActionActivated (object sender, EventArgs e)
	{

	}	

	private void WriteOnTextArea (uint key)
	{
		TextBuffer buffer;

		buffer = textarea.Buffer;
		buffer.Text += key.ToString()+"u";
	}

	protected void OnConnectionActionActivated (object sender, EventArgs e)
	{
		SerialPortSelect SerialPortSelectdialog;
		ResponseType resp;
		string portName;

		SerialPortSelectdialog = new SerialPortSelect ();
		resp = (ResponseType)SerialPortSelectdialog.Run ();

		portName = SerialPortSelectdialog.PortName;

		if (resp == ResponseType.Ok) {

			/* Essai de l'ouverture du port */
			if (serial.IsOpen == true)
				serial.Close ();

			try {
				serial.PortName = portName;
				serial.mode = SerialLink.SerialLinkMode.Standard;
				serial.Open ();
		
				if (serial.IsOpen == true) {
					StatusBar.Push (1, "Connected to " + portName);
					textarea.Sensitive=true;
				}
				else {
					StatusBar.Push (1, "failed to connect to " + portName);
					textarea.Sensitive=false;
				}

			} catch (Exception ex) {
				DebugMessages.WriteLine (Convert.ToString(ex));

				textarea.Sensitive=false;

				MessageDialog md = new MessageDialog (this, DialogFlags.DestroyWithParent, 
		                                     MessageType.Error, 
		                                     ButtonsType.Close, 
		                                     "You haven't rights to open " + portName);

				md.Run ();
				md.Destroy ();
				StatusBar.Push (1, "Not connected (use Connection menu)");
			}
		} 

		SerialPortSelectdialog.Destroy ();
	}

	protected void OnDisconnectActionActivated (object sender, EventArgs e)
	{
		if (serial.IsOpen == true) {
			serial.Terminate ();
		}

		StatusBar.Push (1, "Not connected");
		textarea.Sensitive=false;
	}

	/// <summary>
	/// Event handler for standard data.
	/// </summary>
	/// <param name='sender'>
	/// Sender.
	/// </param>
	/// <param name='e'>
	/// E.
	/// </param>
	/// <remarks>
	/// This is called in a separated thread, so don't try to modify a widget directly
	/// </remarks>

	private void StandardDataReceived (object sender, SerialDataReceivedEventArgs e)
	{
		int length = serial.BytesToRead;
		int reallength;
		byte[] buffer=new byte[length];
		string str;

		reallength = serial.Read (buffer, 0, length);
		str = ByteBufferToString(buffer, reallength);

		DebugMessages.WriteLine("Add "+str);
		textarea.AddString(str);
	}

	/// <summary>
	/// Downloading thread.
	/// </summary>
	/// <param name='sender'>
	/// Sender.
	/// </param>
	/// <param name='e'>
	/// E.
	/// </param>
	/// <remarks>
	/// This is called in a separated thread, so don't try to modify a widget directly
	/// </remarks>
	 
	private string ByteBufferToString (byte[] buf, int length)
	{
		string str;
		str ="";

		for (int i=0; i<length; i++)
		{
			str += (char)buf[i];
		}

		return str;
	}

	private char TranslateKey (Gdk.EventKey key)
	{
		char value = '.';

		if ((key.KeyValue <= 32) || (key.KeyValue > 255)) {

			switch (key.Key)
			{
			case Gdk.Key.Return:
				value = (char)0x0D;
				break;
			case Gdk.Key.KP_Enter:
				value = (char)0x0D;
				break;
			case Gdk.Key.KP_0:
				value='0';
				break;
			case Gdk.Key.KP_1:
				value='1';
				break;
			case Gdk.Key.KP_2:
				value='2';
				break;
			case Gdk.Key.KP_3:
				value='3';
				break;
			case Gdk.Key.KP_4:
				value='4';
				break;
			case Gdk.Key.KP_5:
				value='5';
				break;
			case Gdk.Key.KP_6:
				value='6';
				break;
			case Gdk.Key.KP_7:
				value='7';
				break;
			case Gdk.Key.KP_8:
				value='8';
				break;
			case Gdk.Key.KP_9:
				value='9';
				break;
			case Gdk.Key.KP_Add:
				value='+';
				break;
			case Gdk.Key.KP_Divide:
				value='/';
				break;
			case Gdk.Key.KP_Subtract:
				value='-';
				break;
			case Gdk.Key.KP_Multiply:
				value='*';
				break;
			case Gdk.Key.KP_Space:
			case Gdk.Key.space:
				value= ' ';
				break;
			default:
				value = '.';
				break;
			}
		}
		else value = (char)key.KeyValue;

		return value;
	}

	private void TextAreaKeyEvent (object sender, Gdk.EventKey key)
	{
		char tmp;
		char[] toSend = new char[1];
		bool nothingToDo = false;

		tmp = TranslateKey (key);
		toSend [0] = tmp;

		switch (key.Key) {
		case Gdk.Key.Return:
		case Gdk.Key.KP_Enter:
			textarea.Newline ();
			break;
		case Gdk.Key.Up:
		case Gdk.Key.KP_Up:
		case Gdk.Key.Down:
		case Gdk.Key.KP_Down:
		case Gdk.Key.Left:
		case Gdk.Key.KP_Left:
		case Gdk.Key.Right:
		case Gdk.Key.KP_Right:
			textarea.Scroll (key);
			nothingToDo = true;
			break;
		case Gdk.Key.Shift_L:
		case Gdk.Key.Shift_R:
		case Gdk.Key.Caps_Lock:
		case Gdk.Key.Alt_L:
		case Gdk.Key.Alt_R:
		case Gdk.Key.Menu:
		case Gdk.Key.Meta_L:
		case Gdk.Key.Meta_R:
		case Gdk.Key.Home:
		case Gdk.Key.Page_Down:
		case Gdk.Key.Page_Up:
		case Gdk.Key.End:
		case Gdk.Key.Super_L:
		case Gdk.Key.Super_R:
		case Gdk.Key.Insert:
		case Gdk.Key.Scroll_Lock:
		case Gdk.Key.Pause:
		case Gdk.Key.Print:
		case Gdk.Key.ISO_Level3_Shift:
			nothingToDo = true;
			break;
		case Gdk.Key.Escape:
			textarea.AddCharTransmitted((char)0x1B);
			toSend [0] =(char)0x1B;
			break;
		case Gdk.Key.BackSpace:
		case Gdk.Key.Delete:
			textarea.SuppressChar();
			toSend [0] =(char)0x08;
			break;
		default:
			textarea.AddCharTransmitted (tmp);
			break;
		}

		if ((serial.IsOpen) && (nothingToDo == false))
			serial.Write (toSend, 0, 1);
	}

	public void ErrorMessage (string message)
	{	
		Gtk.Application.Invoke (delegate {   
								MessageDialog md = new MessageDialog (null, DialogFlags.Modal, 
		                                     MessageType.Error, 
		                                     ButtonsType.Close, 
		                                     message);

								md.Run ();
								md.Destroy ();
								});
	}
}
