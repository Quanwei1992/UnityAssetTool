using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Drawing;
using System.Drawing.Imaging;
using UnityAssetTool.Extractor;
namespace UnityAssetTool
{
    public class AssetExtrator
    {
        private Dictionary<string, ISerializeObjectExtrator> mObjectExtratorDic = new Dictionary<string, ISerializeObjectExtrator>();

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
            mObjectExtratorDic["Font"] = new FontExtrator();
            //mObjectExtratorDic["Texture2D"] = new Texture2DExtrator();
        }


        private void ExtractAuto(Asset.AssetObjectInfo objinfo,TypeTree typeTree, string outputPath)
        {
            if (typeTree != null) {
                SerializeObject sobj = new SerializeObject(typeTree, objinfo.data);
                ISerializeObjectExtrator extrator;
                if (mObjectExtratorDic.TryGetValue(typeTree.type, out extrator)) {
                    extrator.Extract(sobj, outputPath);
                } else {
                    extractOnlyRawText(objinfo, typeTree, outputPath);
                }
            } else {
                extractOnlyRawBits(objinfo, typeTree, outputPath);
            }
        }
        private void extractOnlyRawBits(Asset.AssetObjectInfo objinfo, TypeTree typeTree, string outputPath)
        {
            string name = "";
            if (typeTree != null && Path.GetFileName(outputPath) == "") {           
                try {
                    SerializeObject sobj  = new SerializeObject(typeTree, objinfo.data);
                   var nameProperty = sobj.FindProperty("m_Name");              
                    if (nameProperty != null) {
                        name = nameProperty.Value as string;
                        outputPath += "/" + name;
                    }
                } catch {
                    Debug.LogError("Can't Create SerializeObject.TypeVerion:{0},TypeClassID:{1},TypeName:{2}",
                        typeTree.version, objinfo.classID, typeTree.type);
                }
            }
            ExtractRawBits(objinfo, outputPath);
        }

        private void extractOnlyRawText(Asset.AssetObjectInfo objinfo, TypeTree typeTree, string outputPath)
        {
            if (typeTree != null) {
                SerializeObject sobj = new SerializeObject(typeTree, objinfo.data);
                ExtractRawText(sobj,outputPath);
            }
        }

        private void extractRawTextOrRawBits(Asset.AssetObjectInfo objinfo, TypeTree typeTree, string outputPath)
        {
            if (typeTree != null) {
                extractOnlyRawText(objinfo, typeTree, outputPath);
            } else {
                extractOnlyRawBits(objinfo,typeTree,outputPath);
            }

        }



        public void ExtractObjct(Asset.AssetObjectInfo obj, TypeTree typeTree, string outputPath, ExtractMode mode = ExtractMode.Auto)
        {
            outputPath = outputPath + "\\" + AssetToolUtility.ClassIDToClassName(obj.classID) + "\\";
            switch (mode) {
                case ExtractMode.Auto:
                ExtractAuto(obj, typeTree, outputPath);
                break;
                case ExtractMode.OnlyRawBits:
                extractOnlyRawBits(obj, typeTree, outputPath);
                break;
                case ExtractMode.OnlyRawText:
                extractOnlyRawText(obj, typeTree, outputPath);
                break;
                case ExtractMode.RawTextOrRawBits:
                extractRawTextOrRawBits(obj, typeTree, outputPath);
                break;
            }
        }

        public void Extract(Asset asset, TypeTreeDataBase typeTreeDB, string outputPath, ExtractMode mode = ExtractMode.Auto)
        {
            foreach (var objinfo in asset.ObjectInfos) {
                string className = AssetToolUtility.ClassIDToClassName(objinfo.classID);
                var path = outputPath + "/Class " +objinfo.classID+" "+ className+"/";
                var typeTree = typeTreeDB.GetType(asset.AssetVersion, objinfo.classID);
                ExtractObjct(objinfo, typeTree, outputPath, mode);
            }     
        }

        int gID = 0;
        private void ExtractRawBits(Asset.AssetObjectInfo obj, string outputPath)
        {

            if (Path.GetFileName(outputPath) == "") {
                string name = (gID++) + "_" + obj.PathID.ToString();
                outputPath = outputPath + "/" + name;
            }
            if (Path.GetExtension(outputPath) == "") {
                outputPath += ".raw";
            }
          


            outputPath = AssetToolUtility.FixOuputPath(outputPath);
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

            if (Path.GetFileName(outputPath) == "") {
                var nameProperty = obj.FindProperty("m_Name");
                string name = "";
                if (nameProperty != null) {
                    name = nameProperty.Value as string;
                }
                if (string.IsNullOrEmpty(name)) {
                    name = (gID++).ToString();
                }
                outputPath += "/" + name;
            }
            if (Path.GetExtension(outputPath) == "") {
                outputPath += ".txt";
            }     
            outputPath = AssetToolUtility.FixOuputPath(outputPath);
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
