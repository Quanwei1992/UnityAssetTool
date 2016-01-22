using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace FileFormatTest
{
    class SerializeUtility
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

        static public TypeTreeDataBase GenerateTypeTreeDataBase(SerializeAssetV09 asset)
        {
            return null;
        }
    }
}
