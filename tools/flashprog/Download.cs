//
//  Download.cs
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
//using System.Threading;
using System.Timers;

namespace flashprog
{
	public class Download
	{
		public enum DownloadState
		{
			None,
			Success,
			TimeoutError,
			IOError,
			InvalidProtocolError,
			CanceledByUser,
			InvalidFileError,
			CorruptedFileError,
			NoFileError,
			ConnectionError
		};

		protected SerialLink serial;
		public string filename;

		public DownloadState status=DownloadState.None;
		protected ProgressBar progressBar;

		protected int maxValue;
		protected float incrementProgressBar;
		protected float currentValue;

		public Download (string filename)
		{
			this.serial = MainClass.serial;
			this.filename = filename;
		}

		public void Run ()
		{
			IntelHex hexfile;
			IntelHexDataChunk[] dataChunk;
			UInt32 entryPoint;
			IntelHexAnalyser.IntelHexAnalyserStatus analyseStatus;
			DownloadProtocol protocol;
			DownloadProtocol.ProtocolStatus protocolStatus;
			int completeSize;

			status = DownloadState.None;
			dataChunk = new IntelHexDataChunk[1];
			int nbBlocks=0;

			/* Verifie que le port est bien ouvert */
			if (serial.IsOpen != true) {
				status = DownloadState.IOError;

				return;
			}

			/* Analyse le contenu du fichier */
			try
			{
				hexfile = new IntelHex (filename);
			}
			catch {
				status = DownloadState.NoFileError;
				return;
			}

			if (hexfile != null) {
				analyseStatus = IntelHexAnalyser.Analyse (hexfile, out dataChunk, out entryPoint);

				if (analyseStatus != IntelHexAnalyser.IntelHexAnalyserStatus.Success) {
					DebugMessages.WriteLine ("Error during file analysis: " + analyseStatus);
					SetStatus (analyseStatus);

					return;
				}
			}

			protocol = new DownloadProtocol ();
			protocolStatus = protocol.Connect ();
			if (protocolStatus != DownloadProtocol.ProtocolStatus.Success) {
				DebugMessages.WriteLine ("Unable to connect to target: " + protocolStatus);
				SetStatus (protocolStatus);

				return;
			}

			progressBar = new ProgressBar ();

			InitializeProgressBar (dataChunk.Length, 1.0f);

			foreach (IntelHexDataChunk data in dataChunk) {
				nbBlocks = nbBlocks + data.data.Length;
			}

			protocol.SetFilename ((UInt32)nbBlocks, parameters.blockSize, System.IO.Path.GetFileName (filename));

			/* efface la flash */
			completeSize = 0;

			foreach (IntelHexDataChunk data in dataChunk) {
				string eraseMsg;

				completeSize = completeSize + data.data.Length;
				eraseMsg = "Erase [0x" + protocol.ToHex ((UInt32)data.address) + 
					" - 0x" + protocol.ToHex ((UInt32)(data.address + data.data.Length - 1)) + "]";

				DebugMessages.WriteLine (eraseMsg);

				MoveProgressBar (eraseMsg, "");
				protocolStatus = protocol.Erase ((UInt32)data.address, (UInt32)(data.address + data.data.Length - 1));

				if (protocolStatus != DownloadProtocol.ProtocolStatus.Success) {
					SetStatus (protocolStatus);

					return;
				}
			}

			/* Programme la flash */
			InitializeProgressBar (completeSize, (float)parameters.blockSize);

			foreach (IntelHexDataChunk data in dataChunk) {
			
				/* Envoi l'adresse de debut de programme */
				DebugMessages.WriteLine ("Set program address to 0x" + Convert.ToString (data.address, 16).ToUpper ());
				protocolStatus = protocol.SetAddress ((UInt32)data.address);

				if (protocolStatus != DownloadProtocol.ProtocolStatus.Success) {
					SetStatus (protocolStatus);

					return;
				}

				/* Programmation de la flash */
				int index = 0;
				byte[] buffer;
				DebugMessages.WriteLine ("Programming [0x" + protocol.ToHex ((UInt32)data.address) + 
					" - 0x" + protocol.ToHex ((UInt32)(data.address + data.data.Length - 1)) + "]"
				);
				do {
					buffer = GetDataBloc (data.data, ref index);

					MoveProgressBar ("Programming flash",
					                 "Write address 0x" + protocol.ToHex ((UInt32)(data.address + index)));
					protocolStatus = protocol.Program (buffer, (UInt16)index);

					if (protocolStatus != DownloadProtocol.ProtocolStatus.Success) {
						SetStatus (protocolStatus);

						return;
					}

					/* On passe au bloc suivant */
					index = index + parameters.blockSize;

				} while (index < data.data.Length);
			}

			/* Verify checksum */
			InitializeProgressBar (dataChunk.Length, 1.0f);
			foreach (IntelHexDataChunk data in dataChunk) {
				string verifyMsg = "Verify checksum [0x" + protocol.ToHex ((UInt32)data.address) + 
					" - 0x" + protocol.ToHex ((UInt32)(data.address + data.data.Length - 1)) + "]";

				DebugMessages.WriteLine (verifyMsg);
				MoveProgressBar (verifyMsg, "");
				protocolStatus = protocol.Verify ((UInt32)data.address, 
				                                  (UInt32)(data.address + data.data.Length - 1),
				                                  ComputeChecksum (data.data));

				if (protocolStatus != DownloadProtocol.ProtocolStatus.Success) {
					SetStatus (protocolStatus);

					return;
				} 
			}

			progressBar.Erase ();

			if (parameters.resetAfterDownload == true) {
				DebugMessages.WriteLine ("Reset target");
				VerboseMessages.WriteLine ("Reset target");

				protocolStatus = protocol.Reset ();

				if (protocolStatus != DownloadProtocol.ProtocolStatus.Success) {
					SetStatus (protocolStatus);

					return;
				} 
			} else {
				DebugMessages.WriteLine ("Target not reset");
			}

			protocol = null;

			status = DownloadState.Success;
		}

		protected byte[] GetDataBloc (byte[] data, ref int index)
		{
			byte[] extract = new byte [parameters.blockSize];

			for (int i=0; i< parameters.blockSize; i++) {

				if (index+i < data.Length)	extract[i] = data[index+i];
				else extract[i]=0xFF;
			}

			return extract;
		}

		protected UInt16 ComputeChecksum (byte[] data)
		{
			UInt16 checksum = 0;

			foreach (byte b in data) {
				checksum+=b;
			}

			return checksum;
		}

		private void InitializeProgressBar (int maxValue, float increment)
		{
			progressBar.Clear();

			this.maxValue = maxValue;
			incrementProgressBar=increment;
			currentValue =0.0f;
		}

		private void MoveProgressBar (string title, string text)
		{
			int value;
			currentValue = currentValue + incrementProgressBar;

			if (currentValue>= (float)maxValue) currentValue=(float)maxValue;

			value= (int)currentValue;

			progressBar.Set(title, text, value*100/maxValue);
		}

		private void SetStatus (IntelHexAnalyser.IntelHexAnalyserStatus providedStatus)
		{
			switch (providedStatus) {
			case IntelHexAnalyser.IntelHexAnalyserStatus.Success:
				status = DownloadState.Success;
				break;
			case IntelHexAnalyser.IntelHexAnalyserStatus.InvalidFileError:
				status = DownloadState.InvalidProtocolError;
				break;
			case IntelHexAnalyser.IntelHexAnalyserStatus.FileCorruptedError:
				status = DownloadState.CorruptedFileError;
				break;
			default:
				status = DownloadState.IOError;
				break;
			}
		}

		private void SetStatus (DownloadProtocol.ProtocolStatus providedStatus)
		{
			switch (providedStatus) {
			case DownloadProtocol.ProtocolStatus.Success:
				status = DownloadState.Success;
				break;
			case DownloadProtocol.ProtocolStatus.ConnectionError:
				status = DownloadState.ConnectionError;
				break;
			case DownloadProtocol.ProtocolStatus.TimeoutError:
				status= DownloadState.TimeoutError;
				break;
			case DownloadProtocol.ProtocolStatus.TransmissionError:
				status = DownloadState.InvalidProtocolError;
				break;
			case DownloadProtocol.ProtocolStatus.ChecksumError:
				status = DownloadState.InvalidProtocolError;
				break;
			default:
				status = DownloadState.IOError;
				break;
			}
		}
	}
}
	