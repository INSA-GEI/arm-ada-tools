//
//  IntelHexAnalyser.cs
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
	public class IntelHexDataChunk
	{
		public UInt32 address;
		public byte[] data;
	}

	public static class IntelHexAnalyser
	{
		public enum IntelHexAnalyserStatus
		{
			Success,
			FileCorruptedError,
			InvalidFileError
		}

		private const int DataType=0x00;
		private const int EOFType=0x01;
		private const int ExtendedSegmentAddressType=0x02;
		private const int StartSegmentAddressType=0x03;
		private const int ExtendedLinearAddressType=0x04;
		private const int StartLinearAddressType=0x05;

		public static IntelHexAnalyserStatus Analyse (IntelHex hexfile, out IntelHexDataChunk[] dataChunk, out UInt32 entryPoint)
		{
			IntelHexRecord record;
			IntelHex.readStatus readStatus;
			IntelHexAnalyserStatus status = IntelHexAnalyserStatus.Success;

			bool endOfFile = false;
			dataChunk = new IntelHexDataChunk[1];
			dataChunk[0]= new IntelHexDataChunk();

			UInt32 currentExtendedAddr=0;

			entryPoint =0;

			while (!endOfFile) 
			{
				readStatus=hexfile.ReadNext(out record);

				if (readStatus != IntelHex.readStatus.Ok) 
				{
					endOfFile =true;
					if (readStatus == IntelHex.readStatus.FileCorrupted) status = IntelHexAnalyserStatus.FileCorruptedError;
					if (readStatus == IntelHex.readStatus.InvalidChecksum) status = IntelHexAnalyserStatus.FileCorruptedError;
				}
				else /* la lecture est bonne, analyse du contenu */
				{
					switch (record.type)
					{
					case DataType:
						int dataChunkLength=0;
						UInt32 address;
						UInt32 currentAddr;

						if (dataChunk[dataChunk.Length-1].data != null ) dataChunkLength = dataChunk[dataChunk.Length-1].data.Length;

						address =0;
						address = (UInt32)dataChunk[dataChunk.Length-1].address;
						address += (UInt32) dataChunkLength;

						currentAddr=0;
						currentAddr = currentExtendedAddr;
						currentAddr += record.addr;

						if (dataChunk[dataChunk.Length-1].data != null)
						{
							if(address != currentAddr)
							{
								/* trou dans les données => ouverture d'un nouveau chunk */
								Array.Resize(ref dataChunk, dataChunk.Length+1);
								dataChunk[dataChunk.Length-1] = new IntelHexDataChunk();

								dataChunk[dataChunk.Length-1].address= (UInt32)(currentExtendedAddr + (UInt32)record.addr);
							}
						}

						if (dataChunk[dataChunk.Length-1].data == null)
						{
							dataChunk[dataChunk.Length-1].data = new byte[record.dataLen];
							dataChunk[dataChunk.Length-1].address = currentAddr;
							record.data.CopyTo(dataChunk[dataChunk.Length-1].data, 0);
						}
						else
						{
							var z = new byte [dataChunk[dataChunk.Length-1].data.Length + record.dataLen];

							dataChunk[dataChunk.Length-1].data.CopyTo(z, 0);
							record.data.CopyTo(z, dataChunk[dataChunk.Length-1].data.Length);
							dataChunk[dataChunk.Length-1].data = z;

							z=null;
						}
			
						break;
					case EOFType:
						endOfFile =true;
						break;
					case ExtendedSegmentAddressType:
						endOfFile =true;
						status = IntelHexAnalyserStatus.InvalidFileError;
						break;
					case StartSegmentAddressType:
						endOfFile =true;
						status = IntelHexAnalyserStatus.InvalidFileError;
						break;
					case ExtendedLinearAddressType:
						UInt32 a,b;
						a = (UInt32)record.data[0];
						b = (UInt32)record.data[1];

						currentExtendedAddr = (a<<24) + (b<<16);

						/* creation d'un nouveau chunk, si le dernier n'est pas vide */
						if (dataChunk[dataChunk.Length-1].data != null)
						{
							Array.Resize(ref dataChunk, dataChunk.Length+1);
							dataChunk[dataChunk.Length-1] = new IntelHexDataChunk();
						}

						dataChunk[dataChunk.Length-1].address= currentExtendedAddr;
						break;
					case StartLinearAddressType:
						entryPoint = (UInt32)(
							                  (((UInt32)record.data[0])<<24) + 
							                  (((UInt32)record.data[1])<<16) +
											  (((UInt32)record.data[2])<<8) + 
							                  ((UInt32)record.data[3])
							                 );
						break;
					default:
						endOfFile =true;
						status = IntelHexAnalyserStatus.FileCorruptedError;
						break;
					}
				}
			}

			return status;
		}
	}
}
	