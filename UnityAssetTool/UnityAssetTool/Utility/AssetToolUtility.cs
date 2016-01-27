using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace UnityAssetTool
{
    public class AssetToolUtility
    {
        static public int GetAssetsFileVersion(string path)
        {
            var fs = new FileStream(path, FileMode.Open, FileAccess.Read);
            if (fs == null || !fs.CanRead) return -1;
            BinaryReader br = new BinaryReader(fs);
            br.ReadBytes(8);
            var arr = br.ReadBytes(4);
            Array.Reverse(arr);
            int version = BitConverter.ToInt32(arr, 0);
            br.Close();
            fs.Close();
            return version;
        }
        /// <summary>
        /// 获得AssetFile版本
        ///5 = 1.2 - 2.0
        // 6 = 2.1 - 2.6
        // 7 = 3.0 (?)
        // 8 = 3.1 - 3.4
        // 9 = 3.5 - 4.5
        // 11 = pre-5.0
        // 12 = pre-5.0
        // 13 = pre-5.0
        // 14 = 5.0
        // 15 = 5.0 (p3 and newer)
        /// </summary>
        /// <param name="fileBuff"></param>
        /// <returns></returns>

        static public int GetAssetsFileVersion(byte[] fileBuff)
        {
            MemoryStream ms = new MemoryStream(fileBuff);
            BinaryReader br = new BinaryReader(ms);
            br.ReadBytes(8);
            var arr = br.ReadBytes(4);
            Array.Reverse(arr);
            int version = BitConverter.ToInt32(arr, 0);
            br.Close();
            ms.Close();
            return version;
        }

        static public int GetAssetsFileVersion(MemoryStream ms)
        {
            long oldPos = ms.Position;
            BinaryReader br = new BinaryReader(ms);
            br.ReadBytes(8);
            var arr = br.ReadBytes(4);
            Array.Reverse(arr);
            int version = BitConverter.ToInt32(arr, 0);
            ms.Position = oldPos;
            return version;
        }


        static public bool IsBundle(string path)
        {
            try {
                FileStream fs = new FileStream(path, FileMode.Open, FileAccess.Read);
                DataReader data = new DataReader(fs);
                data.byteOrder = DataReader.ByteOrder.Big;
                string signature = data.ReadStringNull();
                data.Close();
                fs.Dispose();
                if (signature.Contains("Unity")) {
                    return true;
                }
                return false;
            } catch {
                return false;
            }
        }


        public static TypeTreeDataBase GenerateTypeTreeDataBase(SerializeDataStruct asset)
        {
            if (asset is SerializeAssetV09) {
                return GenerateTypeTreeDataBase(asset as SerializeAssetV09);
            }
            if (asset is SerializeAssetV15) {
                return GenerateTypeTreeDataBase(asset as SerializeAssetV15);
            }
            return null;
        }


        public static string FixOuputPath(string path)
        {
            string fname = Path.GetFileName(path);
            var invalidFileNameChars = Path.GetInvalidFileNameChars();
            foreach (var c in invalidFileNameChars) {
                fname = fname.Replace(c, ' ');
            }
            string finalPath = Path.GetDirectoryName(path) + "/" + fname;
            long index = 0;
            while (File.Exists(finalPath)) {
                finalPath = Path.GetDirectoryName(path) + "/" + Path.GetFileNameWithoutExtension(fname) + "(" + ++index + ")" + Path.GetExtension(fname);
            }

            return finalPath;
        }


        #region Generate TypeTree V15

        static public TypeTreeDataBase GenerateTypeTreeDataBase(SerializeAssetV15 asset)
        {

            TypeTreeDataBase DB = new TypeTreeDataBase();
            Dictionary<int, string> typeNameTable = new Dictionary<int, string>();
            //一个共享的类型字符串表
            string defaultTypeStr = Properties.Resources.ResourceManager.GetString("TypeStringTableV15");
            var typeStrArray = defaultTypeStr.Split('\n');
            int startOffset = 1 << 31;
            for (int i = 0; i < typeStrArray.Length; i++) {
                typeNameTable[startOffset] = typeStrArray[i].Substring(0, typeStrArray[i].Length-1);
                startOffset += typeStrArray[i].Length;
            }

            foreach (var baseClass in asset.classes) {
                if (baseClass.stringTable == null) continue;
                Dictionary<int, string> onwerStrTable = new Dictionary<int, string>();
                MemoryStream ms = new MemoryStream(baseClass.stringTable);
                DataReader data = new DataReader(ms);
                TypeTree rootType = new TypeTree();
                TypeTree nodePrev = null;
                
                Dictionary<TypeTree, int> typeLevelDic = new Dictionary<TypeTree, int>();
                foreach (var field in baseClass.types) {
                    string name = "";
                    string type = "";
                    if (field.nameOffset < 0) {
                        if (typeNameTable.ContainsKey(field.nameOffset)) {
                            name = typeNameTable[field.nameOffset];
                        }
                    } else {
                        data.position = field.nameOffset;
                        name = data.ReadStringNull();
                    }

                    if (field.typeOffset < 0) {
                        if (typeNameTable.ContainsKey(field.typeOffset)) {
                            type = typeNameTable[field.typeOffset];
                        }
                    } else {
                        data.position = field.typeOffset;
                        type = data.ReadStringNull();
                    }

                    if (nodePrev == null) {
                        rootType.name = name;
                        rootType.type = type;
                        rootType.metaFlag = field.metaFlag;
                        nodePrev = rootType;
                        typeLevelDic[nodePrev] = field.treeLevel;
                        continue;
                    }
                    TypeTree nodeCurr = new TypeTree();
                    nodeCurr.name = name;
                    nodeCurr.type = type;
                    nodeCurr.metaFlag = field.metaFlag;
                    typeLevelDic[nodeCurr] = field.treeLevel;
                    int levels = typeLevelDic[nodePrev] - field.treeLevel;
                    if (levels >= 0) {
                        for (int i = 0; i < levels; i++) {
                            nodePrev = nodePrev.parent;
                        }
                        nodePrev.parent.AddChild(nodeCurr);
                    } else {
                        nodePrev.AddChild(nodeCurr);
                    }
                    nodePrev = nodeCurr;
                }
                DB.Put(15, baseClass.ClassID, rootType);
                Console.Write(rootType);
                data.Close();
                ms.Close();
            }
            return DB;
        }

        #endregion

        #region Generate TypeTree V09

        static public TypeTreeDataBase GenerateTypeTreeDataBase(SerializeAssetV09 asset)
        {
            TypeTreeDataBase DB = new TypeTreeDataBase();
            foreach (var typetree in asset.typeTrees) {
                var tree = GenerateTypeTreeV9(typetree.rootType);
                DB.Put(9, typetree.ClassID, tree);
                //Console.WriteLine(tree);     
            }
            return DB;
        }

        static private TypeTree GenerateTypeTreeV9(SerializeAssetV09.SerializeTypeTreeData tree)
        {
            TypeTree root = new TypeTree();
            root.name = tree.name;
            root.type = tree.type;
            root.metaFlag = tree.metaFlag;
            foreach (var childType in tree.children) {
                var childTree = GenerateTypeTreeV9(childType);
                root.AddChild(childTree);
            }
            return root;
        }
        #endregion


        public static TypeTreeDataBase LoadTypeTreeDataBase(string path)
        {
            TypeTreeDataBase db = new TypeTreeDataBase();
            try {
                FileStream fs = new FileStream(path, FileMode.OpenOrCreate, FileAccess.Read);
                db.DeSerialize(fs);
                fs.Dispose();
            } catch (Exception e) {

            }
            return db;
        }

        public static void SaveTypeTreeDataBase(string path, TypeTreeDataBase db)
        {
            FileStream fs = new FileStream(path, FileMode.OpenOrCreate, FileAccess.Write);
            db.Serialize(fs);
            fs.Flush();
            fs.Dispose();
        }

        private static Dictionary<int,string> mClassNameMap = null;
        public static string ClassIDToClassName(int classID)
        {
            if (mClassNameMap == null) {
                initClassNameMap();
            }
            string ret = classID.ToString();
            if (mClassNameMap.ContainsKey(classID)) {
                ret = mClassNameMap[classID];
            }
            return ret;
        }

        private static void initClassNameMap()
        {
            mClassNameMap = new Dictionary<int, string>();
            string[] lines = Properties.Resources.ClassNameMap.Split('\n');
            foreach (var line in lines) {
                var kvr = line.Split(' ');
                if (kvr.Length == 2) {
                    int id;
                    if (int.TryParse(kvr[0], out id)) {
                        mClassNameMap[id] = kvr[1].Remove(kvr[1].Length-1);
                    }
                }
            }
        }

    }
}
