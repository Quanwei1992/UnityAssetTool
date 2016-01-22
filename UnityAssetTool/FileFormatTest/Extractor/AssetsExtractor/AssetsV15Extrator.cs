using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace FileFormatTest
{
    public class AssetsV15Extrator : IAssetsExtrator
    {

        private class TextAssetExtrator : ISerializeObjectExtrator
        {
            public void Extract(SerializeObject obj, string outputPath)
            {
                string name = obj.FindProperty("Base.m_Name").StringValue();
                string script = obj.FindProperty("Base.m_Script").StringValue();
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
                throw new NotImplementedException();
            }
        }


        private Dictionary<string, ISerializeObjectExtrator> mObjectExtratorDic = new Dictionary<string, ISerializeObjectExtrator>();

        public AssetsV15Extrator()
        {
            mObjectExtratorDic["TextAsset"] = new TextAssetExtrator();
        }

        public void Extract(SerializeDataStruct assets,TypeTreeDataBase typeTreeDB,string outputPath)
        {
            SerializeAssetV15 asset = assets as SerializeAssetV15;
            foreach (var objinfo in asset.objectInfos) {
                var typeTree = typeTreeDB.GetType(15, objinfo.classID);
                if (typeTree != null) {
                    
                    if (mObjectExtratorDic.ContainsKey(typeTree.type)) {
                        SerializeObject sobj = new SerializeObject(typeTree, objinfo.data);
                        var extrator = mObjectExtratorDic[typeTree.type];
                        extrator.Extract(sobj, outputPath + "/" + typeTree.type);
                    }
                }
            }
        }
    }
}
