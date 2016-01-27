using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Drawing;
using System.Drawing.Imaging;
namespace UnityAssetTool.Extractor
{
    public class Texture2DExtrator : ISerializeObjectExtrator
    {
        public void Extract(SerializeObject obj, string outputPath)
        {
            string m_Name = obj.FindProperty("m_Name").Value as string;
            int m_Width = (int)obj.FindProperty("m_Width").Value;
            int m_Height = (int)obj.FindProperty("m_Height").Value;
            int m_CompleteImageSize = (int)obj.FindProperty("m_CompleteImageSize").Value;
            int m_TextureFormat = (int)obj.FindProperty("m_TextureFormat").Value;
            byte[] data = (byte[])obj.FindProperty("image data").Value;
            Bitmap bmp = new Bitmap(m_Width, m_Height, PixelFormat.Format32bppArgb);
            var bmpData = bmp.LockBits(new Rectangle(0, 0, bmp.Width, bmp.Height), ImageLockMode.ReadWrite, PixelFormat.Format32bppArgb);
            int bytes = Math.Abs(bmpData.Stride) * bmp.Height;
            IntPtr ptr = bmpData.Scan0;
            System.Runtime.InteropServices.Marshal.Copy(data, 0, ptr, bytes);


            bmp.UnlockBits(bmpData);
            outputPath = outputPath + "/" + m_Name + ".bmp";
            outputPath = AssetToolUtility.FixOuputPath(outputPath);
            if (!Directory.Exists(Path.GetDirectoryName(outputPath))) {
                Directory.CreateDirectory(Path.GetDirectoryName(outputPath));
            }

            bmp.Save(outputPath);
        }
    }
}
