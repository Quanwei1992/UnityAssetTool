using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Drawing;
using System.Drawing.Imaging;
namespace UnityAssetTool
{
    public class AssetsV09Extrator : IAssetsExtrator
    {

        


        private class TextAssetExtrator : ISerializeObjectExtrator
        {
            public void Extract(SerializeObject obj, string outputPath)
            {
                string name = obj.FindProperty("Base.m_Name").Value as string;
                string script = obj.FindProperty("Base.m_Script").Value as string;
                outputPath = outputPath + "/" + name + ".txt";
                if (!Directory.Exists(Path.GetDirectoryName(outputPath))) {
                    Directory.CreateDirectory(Path.GetDirectoryName(outputPath));
                }
                var bytes = System.Text.Encoding.Unicode.GetBytes(script);
                var fs = new FileStream(outputPath, FileMode.OpenOrCreate, FileAccess.Write);
                fs.Write(bytes, 0, bytes.Length);
                fs.Flush();
                fs.Dispose();
            }
        }

        private class Texture2DExtrator : ISerializeObjectExtrator
        {
            public void Extract(SerializeObject obj, string outputPath)
            {
                string m_Name = obj.FindProperty("Base.m_Name").Value as string;
                int m_Width = (int)obj.FindProperty("Base.m_Width").Value;
                int m_Height = (int)obj.FindProperty("Base.m_Height").Value;
                int m_CompleteImageSize = (int)obj.FindProperty("Base.m_CompleteImageSize").Value;
                int m_TextureFormat = (int)obj.FindProperty("Base.m_TextureFormat").Value;
                byte[] data =  (byte[])obj.FindProperty("Base.image data").Value;
                Bitmap bmp = new Bitmap(m_Width, m_Height,PixelFormat.Format32bppArgb);
                var bmpData = bmp.LockBits(new Rectangle(0, 0, bmp.Width, bmp.Height), ImageLockMode.ReadWrite, PixelFormat.Format32bppArgb);
                int bytes = Math.Abs(bmpData.Stride) * bmp.Height;
                IntPtr ptr = bmpData.Scan0;
                System.Runtime.InteropServices.Marshal.Copy(data, 0, ptr, bytes);


                bmp.UnlockBits(bmpData);
                outputPath = outputPath + "/" + m_Name + ".bmp";
                if (!Directory.Exists(Path.GetDirectoryName(outputPath))) {
                    Directory.CreateDirectory(Path.GetDirectoryName(outputPath));
                }
                bmp.Save(outputPath);
            }
        }


        private Dictionary<string, ISerializeObjectExtrator> mObjectExtratorDic = new Dictionary<string, ISerializeObjectExtrator>();

        public AssetsV09Extrator()
        {
            mObjectExtratorDic["Default"] = new DefaultAssetExtrator();
            mObjectExtratorDic["TextAsset"] = new TextAssetExtrator();
            mObjectExtratorDic["Texture2D"] = new Texture2DExtrator();
        }

        public void Extract(SerializeDataStruct assets,TypeTreeDataBase typeTreeDB,string outputPath)
        {
            SerializeAssetV09 asset = assets as SerializeAssetV09;
            foreach (var objinfo in asset.objectInfos) {
                ExtractRawData(objinfo, outputPath + "/Class" + objinfo.classID + "/");
                continue;
                if (typeTreeDB.Contains(9, objinfo.classID)) {
                    try {
                        var typeTree = typeTreeDB.GetType(9, objinfo.classID);
                        if (typeTree != null) {
                            if (objinfo.classID != 21) continue;
                            SerializeObject sobj = new SerializeObject(typeTree, objinfo.data);                            
                            Console.WriteLine(sobj);
                            ISerializeObjectExtrator extrator;
                            if (!mObjectExtratorDic.TryGetValue(typeTree.type, out extrator)) {
                                extrator = this.GetDefaultSerializeObjectExtrator();
                            }
                            
                            extrator.Extract(sobj, outputPath + "/" + typeTree.type);
                        }
                    } catch {
                        ExtractRawData(objinfo, outputPath + "/Class" + objinfo.classID + "/");
                    }

                } else {
                    ExtractRawData(objinfo, outputPath + "/Class" + objinfo.classID + "/");
                }

            }
        }

        int gID = 0;
        private void ExtractRawData(SerializeAssetV09.SerializeAssetObject obj,string outputPath)
        {
            string name = (gID++)+"_"+ obj.PathID.ToString()+".raw";
            outputPath = outputPath + "/" + name;
            if (!Directory.Exists(Path.GetDirectoryName(outputPath))) {
                Directory.CreateDirectory(Path.GetDirectoryName(outputPath));
            }
            var bytes = obj.data;
            var fs = new FileStream(outputPath, FileMode.OpenOrCreate, FileAccess.Write);
            fs.Write(bytes, 0, bytes.Length);
            fs.Flush();
            fs.Dispose();
        }

        public ISerializeObjectExtrator GetDefaultSerializeObjectExtrator()
        {
            return mObjectExtratorDic["Default"];
        }
    }
}
