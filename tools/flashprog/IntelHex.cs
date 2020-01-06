//
//  IntelHex.cs
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
using System.IO;

namespace flashprog
{
	public class IntelHexRecord
	{
		public UInt16 addr;
		public int type;
		public byte[] data;
		public int dataLen;
		public byte checksum;
		public byte calculatedChecksum;
	}

	public class IntelHex
	{
		private TextReader hexfile;

		public enum readStatus
		{
			Ok=0,
			FileCorrupted,
			InvalidChecksum,
			EOF
		};

		public enum compareChecksumStatus
		{
			Ok=0,
			NonMatching
		}

		public IntelHex (string filename)
		{
			try
			{
				hexfile = new StreamReader(filename);
			}
			catch{
				throw;
			}
		}

		private compareChecksumStatus CompareChecksum (IntelHexRecord record)
		{
			byte checksum = 0;
			byte a, b;
			byte c;

			for (int i=0; i< record.dataLen; i++) {
				checksum+=record.data[i];
			}

			checksum+=(byte)record.dataLen;
			checksum+=(byte)record.type;

			a = (byte)record.addr;
			b = (byte)(record.addr>>8);

			checksum+=a;
			checksum+=b;

			c = (byte)(~checksum);

			checksum = (byte)(0x01 + c);

			if (checksum == record.checksum) return compareChecksumStatus.Ok;
			else return compareChecksumStatus.NonMatching;
		}

		public readStatus ReadNext (out IntelHexRecord record)
		{
			record = new IntelHexRecord ();
			byte data;
			int i = 1;
			int j;

			byte length;
			UInt16 addr;
			byte type;
			byte checksum;

			string substr;
			string str;

			try {
				str = hexfile.ReadLine ();
			} 
#pragma warning disable 0168
			catch (Exception e) 
#pragma warning restore 0168
			{
				return readStatus.EOF;
			}

			if (str ==null) return readStatus.EOF;

			/* analyse de la chaine de caractere */
			if (str [0] != ':')
				return readStatus.FileCorrupted;

			substr = str.Substring(1);

			/* Verification que ce ne sont que des hexa */
			if (!System.Text.RegularExpressions.Regex.IsMatch(substr, @"^[a-zA-Z0-9]+$"))
				return readStatus.FileCorrupted;

			i = 0;
			length = 0;
			addr = 0;
			/* recuperation de la longueur */

			length = (byte)(GetHexVal(substr [i]) << 4);
			length += GetHexVal(substr [i + 1]);
			record.dataLen = length;

			/* recuperation de l'adresse */
			i += 2;
			byte a;
			UInt16 b;

			a = GetHexVal(substr [i]);
			b =(UInt16)(a<<12);
			addr+=b;

			a = GetHexVal(substr [i+1]);
			b =(UInt16)(a<<8);
			addr+=b;

			a = GetHexVal(substr [i+2]);
			b =(UInt16)(a<<4);
			addr+=b;

			a = GetHexVal(substr [i+3]);
			addr+=a;

			//addr = (byte)(GetHexVal(substr [i]) << 12);
			//addr += (byte)(GetHexVal(substr [i + 1]) << 8);
			//addr += (byte)(GetHexVal(substr [i + 2]) << 4);
			//addr += GetHexVal(substr [i + 3]);
			record.addr = addr;

			/* recuperation du type */
			i += 4;
			type = (byte)(GetHexVal(substr [i]) << 4);
			type += GetHexVal(substr [i + 1]);
			record.type = type;

			i += 2;
			record.data = new byte[record.dataLen];

			/* recuperation des data */
			for (j=0; j<length; j++) {
				data = 0;
				data = (byte)(GetHexVal(substr [i]) << 4);
				data += GetHexVal(substr [i + 1]);

				record.data [j] = data;
				i += 2;
			}

			/* recuperation du checksum */
			checksum = (byte)(GetHexVal(substr [i]) << 4);
			checksum += GetHexVal(substr [i + 1]);
			record.checksum = checksum;

			if (CompareChecksum(record)==compareChecksumStatus.NonMatching) return readStatus.InvalidChecksum;
			return readStatus.Ok;
		}

		private byte GetHexVal(char hex) 
		{
	        int val = (int)(Char.ToUpper(hex));

	        //For uppercase A-F letters:
	        val = val - (val < 58 ? 48 : 55);
			return (byte)val;
    	}
	}
}
	