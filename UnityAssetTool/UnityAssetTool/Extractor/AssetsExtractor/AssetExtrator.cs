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
            //mObjectExtratorDic["Texture2D"] = new Texture2DExtrator();
        }


        private void extractAuto(Asset.AssetObjectInfo objinfo,TypeTree typeTree, string outputPath)
        {
            if (typeTree != null) {
                SerializeObject sobj = new SerializeObject(typeTree, objinfo.data);
                ISerializeObjectExtrator extrator;
                if (mObjectExtratorDic.TryGetValue(typeTree.type, out extrator)) {
                    extrator.Extract(sobj, outputPath + "/" + typeTree.type);
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
            if (typeTree != null) {
                SerializeObject sobj = new SerializeObject(typeTree, objinfo.data);
                var nameProperty = sobj.FindProperty("m_Name");
                if (nameProperty != null) {
                    name = nameProperty.Value as string;
                }
            }
            ExtractRawBits(objinfo, outputPath, name);
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

        public void Extract(Asset asset, TypeTreeDataBase typeTreeDB, string outputPath, ExtractMode mode = ExtractMode.Auto)
        {
            foreach (var objinfo in asset.ObjectInfos) {
                string className = AssetToolUtility.ClassIDToClassName(objinfo.classID);
                var path = outputPath + "/Class " +objinfo.classID+" "+ className+"/";
                var typeTree = typeTreeDB.GetType(asset.AssetVersion, objinfo.classID);
                switch (mode) {
                    case ExtractMode.Auto:
                    extractAuto(objinfo, typeTree, path);
                    break;
                    case ExtractMode.OnlyRawBits:
                    extractOnlyRawBits(objinfo, typeTree, path);
                    break;
                    case ExtractMode.OnlyRawText:
                    extractOnlyRawText(objinfo, typeTree, path);
                    break;
                    case ExtractMode.RawTextOrRawBits:
                    extractRawTextOrRawBits(objinfo, typeTree, path);
                    break;
                }
            }
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
                        string className = AssetToolUtility.ClassIDToClassName(objinfo.classID);
                        ExtractRawBits(objinfo, outputPath + "/Class"+ objinfo.classID+" " + className + "/");
                    }
                }
            }

            if (mode == ExtractMode.OnlyRawBits) {
                foreach (var objinfo in asset.ObjectInfos) {
                    string className = AssetToolUtility.ClassIDToClassName(objinfo.classID);
                    string name = null;
                    if (typeTreeDB.Contains(asset.AssetVersion, objinfo.classID)) {
                        var typeTree = typeTreeDB.GetType(asset.AssetVersion, objinfo.classID);
                        if (typeTree != null) {
                            SerializeObject sobj = new SerializeObject(typeTree, objinfo.data);
                            var nameProperty = sobj.FindProperty("m_Name");
                            if (nameProperty != null) {
                                name = nameProperty.Value as string;
                            }
                        }
                    }
                    ExtractRawBits(objinfo, outputPath + "/Class" + objinfo.classID + " " + className + "/",name);
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
                        string className = AssetToolUtility.ClassIDToClassName(objinfo.classID);
                        ExtractRawBits(objinfo, outputPath + "/Class" + objinfo.classID + " " + className + "/");
                    }
                }
            }

        }

        int gID = 0;
        private void ExtractRawBits(Asset.AssetObjectInfo obj, string outputPath, string name = null)
        {
            if (string.IsNullOrEmpty(name)) {
                name = (gID++) + "_" + obj.PathID.ToString();
            }


            outputPath = outputPath + "/" + name + ".raw";
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
            var nameProperty = obj.FindProperty("m_Name");
            string name = "";
            if (nameProperty != null) {
                name = nameProperty.Value as string;
            }
            if (string.IsNullOrEmpty(name)) {
                name = (gID++).ToString();
            }
            outputPath += "/" + name + ".txt";
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
