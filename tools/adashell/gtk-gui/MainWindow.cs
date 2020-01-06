
// This file has been generated by the GUI designer. Do not modify.

public partial class MainWindow
{
	private global::Gtk.UIManager UIManager;
	
	private global::Gtk.Action FileAction;
	
	private global::Gtk.Action HelpAction;
	
	private global::Gtk.Action SaveAction;
	
	private global::Gtk.Action ExitAction;
	
	private global::Gtk.Action ConnectionAction1;
	
	private global::Gtk.Action ConnectionAction;
	
	private global::Gtk.Action DisconnectAction;
	
	private global::Gtk.VBox vbox1;
	
	private global::Gtk.MenuBar menubar2;
	
	private global::Gtk.Statusbar StatusBar;

	protected virtual void Build ()
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
	}
}
