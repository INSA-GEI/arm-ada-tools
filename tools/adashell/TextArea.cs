//
//  TextArea.cs
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

namespace adashell
{
	public class TextArea: TextView
	{
		public delegate void TextAreaKeyEvent (object sender, Gdk.EventKey Key);
		public event TextAreaKeyEvent KeyEvent;

		private int TextTagNbr;

		public TextArea ()
		{
			KeyEvent = null;
			TextTagNbr=0;
		}

		public void AddChar(char c)
		{
			this.Buffer.InsertInteractiveAtCursor(c.ToString(), true);
		}

		public void AddString (string s)
		{
			this.Buffer.InsertInteractiveAtCursor(s, true);
		}

		public void AddCharTransmitted (char c)
		{
			TextTag tagTransmitted = new TextTag("transmitted"+TextTagNbr);
			tagTransmitted.Weight = Pango.Weight.Bold;
			tagTransmitted.Foreground="Red";
			this.Buffer.TagTable.Add(tagTransmitted);

			this.Buffer.InsertInteractiveAtCursor(c.ToString(), true);

			TextIter iterStart = this.Buffer.GetIterAtOffset(this.Buffer.CursorPosition-1);
			TextIter iterend = this.Buffer.GetIterAtOffset(this.Buffer.CursorPosition);
			this.Buffer.ApplyTag(tagTransmitted, iterStart, iterend);

			TextTagNbr++;
		}

		public void AddStringTransmitted (string s)
		{
			TextTag tagTransmitted = new TextTag("transmitted"+TextTagNbr);
			tagTransmitted.Weight = Pango.Weight.Bold;
			tagTransmitted.Foreground="Red";

			this.Buffer.TagTable.Add(tagTransmitted);

			this.Buffer.InsertInteractiveAtCursor(s, true);

			TextIter iterStart = this.Buffer.GetIterAtOffset(this.Buffer.CursorPosition-s.Length);
			TextIter iterend = this.Buffer.GetIterAtOffset(this.Buffer.CursorPosition);
			this.Buffer.ApplyTag(tagTransmitted, iterStart, iterend);

			TextTagNbr++;
		}

		public void SuppressChar ()
		{
			TextIter iterStart = this.Buffer.GetIterAtOffset(this.Buffer.CursorPosition-1);
			TextIter iterend = this.Buffer.GetIterAtOffset(this.Buffer.CursorPosition);

			this.Buffer.DeleteInteractive(ref iterStart,ref iterend,true);
		}

		public void Scroll (Gdk.EventKey evnt)
		{	
			base.OnKeyPressEvent(evnt);
		}

		public void Newline ()
		{
			this.Buffer.InsertInteractiveAtCursor(System.Environment.NewLine, true);
		}

		protected override bool OnKeyPressEvent (Gdk.EventKey evnt)
		{
			if (KeyEvent != null) KeyEvent(this, evnt);
			return true;
		}

	}
}

