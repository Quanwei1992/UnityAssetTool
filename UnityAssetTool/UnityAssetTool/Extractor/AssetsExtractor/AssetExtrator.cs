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
    public class AssetExtrator
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
        private AssetObjectRawBitsExtrator rawBitsExtrator = new AssetObjectRawBitsExtrator();
        private AssetObjectRawTextExtrator rawTextExtrator = new AssetObjectRawTextExtrator();
        public enum ExtractMode
        {
            Auto,
            OnlyRawText,
            OnlyRawBits,
            RawTextOrRawBits
        }
        public AssetExtrator()
        {
            mObjectExtratorDic["TextAsset"] = new TextAssetExtrator();
            mObjectExtratorDic["Texture2D"] = new Texture2DExtrator();
        }

        public void Extract(Asset asset, TypeTreeDataBase typeTreeDB, string outputPath, ExtractMode mode = ExtractMode.Auto)
        {
            if (mode == ExtractMode.Auto) {
                foreach (var objinfo in asset.ObjectInfos) {
                    if (typeTreeDB.Contains(asset.AssetVersion, objinfo.classID)) {
                        var typeTree = typeTreeDB.GetType(asset.AssetVersion, objinfo.classID);
                        if (typeTree != null) {
                            SerializeObject sobj = new SerializeObject(typeTree, objinfo.data);
                            ISerializeObjectExtrator extrator;
                            if (mObjectExtratorDic.TryGetValue(typeTree.type, out extrator)) {
                                extrator.Extract(sobj, outputPath + "/" + typeTree.type);
                            } else {
                                ExtractRawText(sobj, outputPath + "/" + typeTree.type);
                            }

                        }
                    } else {
                        string className = SerializeUtility.ClassIDToClassName(objinfo.classID);
                        ExtractRawBits(objinfo, outputPath + "/Class" + className + "/");
                    }
                }
            }

            if (mode == ExtractMode.OnlyRawBits) {
                foreach (var objinfo in asset.ObjectInfos) {
                    string className = SerializeUtility.ClassIDToClassName(objinfo.classID);
                    ExtractRawBits(objinfo, outputPath + "/Class" + className + "/");
                }
            }

            if (mode == ExtractMode.OnlyRawText) {
                foreach (var objinfo in asset.ObjectInfos) {
                    if (typeTreeDB.Contains(asset.AssetVersion, objinfo.classID)) {
                        var typeTree = typeTreeDB.GetType(asset.AssetVersion, objinfo.classID);
                        if (typeTree != null) {
                            SerializeObject sobj = new SerializeObject(typeTree, objinfo.data);
                            ExtractRawText(sobj, outputPath + "/" + typeTree.type);
                        }
                    }
                }
            }

            if (mode == ExtractMode.RawTextOrRawBits) {
                foreach (var objinfo in asset.ObjectInfos) {
                    if (typeTreeDB.Contains(asset.AssetVersion, objinfo.classID)) {
                        var typeTree = typeTreeDB.GetType(asset.AssetVersion, objinfo.classID);
                        if (typeTree != null) {
                            SerializeObject sobj = new SerializeObject(typeTree, objinfo.data);
                            ExtractRawText(sobj, outputPath + "/" + typeTree.type);                            
                        }
                    } else {
                        string className = SerializeUtility.ClassIDToClassName(objinfo.classID);
                        ExtractRawBits(objinfo, outputPath + "/Class" + className + "/");
                    }
                }
            }



        }

        int gID = 0;
        private void ExtractRawBits(Asset.AssetObjectInfo obj,string outputPath)
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

        public void ExtractRawText(SerializeObject obj, string outputPath)
        {
            var nameProperty = obj.FindProperty("Base.m_Name");
            string name = "";
            if (nameProperty != null) {
                name = nameProperty.Value as string;
            }
            if (string.IsNullOrEmpty(name)) {
                name = (gID++).ToString();
            }
            outputPath += "/" + name + ".txt";
            string content = obj.ToString();
            if (!Directory.Exists(Path.GetDirectoryName(outputPath))) {
                Directory.CreateDirectory(Path.GetDirectoryName(outputPath));
            }
            var bytes = System.Text.Encoding.Unicode.GetBytes(content);
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
