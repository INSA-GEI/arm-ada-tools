//
//  BitmapConvertion.cs
//
//  Author:
//       DI MERCURIO Sebastien <dimercur@insa-toulouse.fr>
//
//  Copyright (c) 2016 INSA - GEI, Toulouse, France
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
using System.Collections.Generic;
using System.Drawing;

namespace rca
{
	/// <summary>
	/// Bitmap convertion.
	/// </summary>
	public class BitmapConvertion
	{
		/// <summary>
		/// Pixel bloc.
		/// </summary>
		public struct PixelBloc
		{
			/// <summary>
			/// 
			/// </summary>
			public Byte pixel_8b;

			/// <summary>
			/// The pixel 16b.
			/// </summary>
			public UInt16 pixel_16b;

			/// <summary>
			/// The length.
			/// </summary>
			public Byte length;
		};

		/// <summary>
		/// The pixels list.
		/// </summary>
		public List<PixelBloc> pixelsList;

		public Bitmap orgBitmap;
		public UInt16[,] bitmap16b;
		public Byte[,] bitmap8b;

		/// <summary>
		/// Gets the width.
		/// </summary>
		/// <returns>The width.</returns>
		public int GetWidth ()
		{
			if (orgBitmap != null)
				return orgBitmap.Width;
			else
				return 0;
		}

		/// <summary>
		/// Gets the height.
		/// </summary>
		/// <returns>The height.</returns>
		public int GetHeight ()
		{
			if (orgBitmap != null)
				return orgBitmap.Height;
			else
			return 0;
		}

		/// <summary>
		/// Initializes a new instance of the BitmapConvertion class.
		/// </summary>
		/// <param name="bitmap">Image a convertir</param>
		/// <param name="format">Color format</param>
		public BitmapConvertion(Bitmap bitmap, Common.ColorFormat format)
		{
			this.orgBitmap = bitmap;
			Common.colorFormat = format;

			pixelsList = new List<PixelBloc> ();
		}

		/// <summary>
		/// Convert Color to RGB16 format.
		/// </summary>
		/// <returns>Color converted to RGB16.</returns>
		/// <param name="c">Color to convert.</param>
		private UInt16 ColorToRGB16(Color c)
		{
			UInt16 RGB16=0;

			RGB16 = (UInt16)((((UInt16)c.R) >> 3) << 11);
			RGB16 += (UInt16)((((UInt16)c.G) >> 2) << 5);
			RGB16 += (UInt16)(((UInt16)c.B) >> 3);

			return RGB16;
		}

		/// <summary>
		/// Convert Color to RGB8 format
		/// </summary>
		/// <returns>Color converted to RGB8.</returns>
		/// <param name="c">Color to convert.</param>
		private Byte ColorToRGB8(Color c)
		{
			Byte RGB8=0;

			RGB8 = (Byte)((((Byte)c.R) >> 5) << 5);
			RGB8 += (Byte)((((Byte)c.G) >> 5) << 2);
			RGB8 += (Byte)(((Byte)c.B) >> 6);

			return RGB8;
		}

		/// <summary>
		/// Converts original bitmap to specified color format
		/// </summary>
		public void ConvertColorFormat()
		{
			if (Common.colorFormat == Common.ColorFormat.RGB16) {
				bitmap16b = new UInt16[orgBitmap.Width, orgBitmap.Height];
				int x, y;

				for (x = 0; x < orgBitmap.Width; x++) {
					for (y = 0; y < orgBitmap.Height; y++) {
						bitmap16b [x, y] = ColorToRGB16 (orgBitmap.GetPixel (x, y));
					}
				}
			} else {
				bitmap8b = new Byte[orgBitmap.Width,orgBitmap.Height];
				int x, y;

				for (x = 0; x < orgBitmap.Width; x++) {
					for (y = 0; y < orgBitmap.Height; y++) {
						bitmap8b [x, y] = ColorToRGB8 (orgBitmap.GetPixel (x, y));
					}
				}
			}
		}

		/// <summary>
		/// Packs the bitmap.
		/// </summary>
		public int PackBitmap()
		{
			int size;

			if (Common.colorFormat == Common.ColorFormat.RGB16) {
				size = PackRGB16 ();
			} else {
				size = PackRGB8 ();
			}

			return size;
		}

		private int PackRGB16()
		{
			int x, y;
			bool finish;
			UInt16 pixel;
			Byte count;
			PixelBloc bloc;

			x = 0;
			y = 0;
			finish = false;
			count = 0;

			pixel = bitmap16b [0, 0]; // uniquement pour supprimer des messages d'erreur

			while (finish != true) 
			{
				if (count == 0)	{
					pixel = bitmap16b[x,y];
					count = 1;
				} else {
					if (bitmap16b[x,y] == pixel)	{
						count++;

						if (count == 255) {
							bloc = new PixelBloc ();
							bloc.pixel_16b = pixel;
							bloc.length = count;

							pixelsList.Add (bloc);

							count = 0;
						}
					} else {
						bloc = new PixelBloc ();
						bloc.pixel_16b = pixel;
						bloc.length = count;

						pixelsList.Add (bloc);

						pixel=bitmap16b[x,y];
						count=1;
					}
				}

				x++;
				if (x==orgBitmap.Width)	{
					x = 0;
					y++;

					if (y==orgBitmap.Height) {
						/* Fin de l'image */
						finish =true;

						if (count != 0) {
							bloc = new PixelBloc ();
							bloc.pixel_16b = pixel;
							bloc.length = count;

							pixelsList.Add (bloc);
						}
					}
				}
			}

			return pixelsList.Count;
		}

		private int PackRGB8()
		{
			int x, y;
			bool finish;
			Byte pixel;
			Byte count;
			PixelBloc bloc;

			x = 0;
			y = 0;
			finish = false;
			count = 0;

			pixel = bitmap8b [0, 0]; // uniquement pour supprimer des messages d'erreur

			while (finish != true) 
			{
				if (count == 0)	{
					pixel = bitmap8b[x,y];
					count = 1;
				} else {
					if (bitmap8b[x,y] == pixel)	{
						count++;

						if (count == 255) {
							bloc = new PixelBloc ();
							bloc.pixel_8b = pixel;
							bloc.length = count;

							pixelsList.Add (bloc);

							count = 0;
						}
					} else {
						bloc = new PixelBloc ();
						bloc.pixel_8b = pixel;
						bloc.length = count;

						pixelsList.Add (bloc);

						pixel=bitmap8b[x,y];
						count=1;
					}
				}

				x++;
				if (x==orgBitmap.Width)	{
					x = 0;
					y++;

					if (y==orgBitmap.Height) {
						/* Fin de l'image */
						finish =true;

						if (count != 0) {
							bloc = new PixelBloc ();
							bloc.pixel_8b = pixel;
							bloc.length = count;

							pixelsList.Add (bloc);
						}
					}
				}
			}

			return pixelsList.Count;
		}
	}
}

