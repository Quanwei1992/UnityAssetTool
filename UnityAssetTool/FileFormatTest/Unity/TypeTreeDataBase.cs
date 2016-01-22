using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;
using System.IO;
namespace FileFormatTest
{

    public class TypeTreeDataBase
    {
        //version,classid,type
        Dictionary<int, Dictionary<int, TypeTree>> mTypeDic = new Dictionary<int, Dictionary<int, TypeTree>>();

        public TypeTree GetType(int version, int classID)
        {
            return mTypeDic[version][classID];
        }

        public bool Contains(int version, int classID)
        {
            if (mTypeDic.ContainsKey(version)) {
                if (mTypeDic[version] != null && mTypeDic[version].ContainsKey(classID)) return true;
            }
            return false;
        }

        public void Put(int version,int classID,TypeTree type)
        {
            Dictionary<int, TypeTree> dic;
            if (!mTypeDic.TryGetValue(version, out dic)) {
                dic = new Dictionary<int, TypeTree>();
                mTypeDic[version] = dic;
            }
            dic[classID] = type;
        }

        public Dictionary<int, TypeTree> GetAllType(int version)
        {
            Dictionary<int, TypeTree> ret;
            mTypeDic.TryGetValue(version, out ret);
            if (ret == null) {
                mTypeDic = new Dictionary<int, Dictionary<int, TypeTree>>();
            }
            return ret;
        }

        public int[] GetAllVersion()
        {
            return mTypeDic.Keys.ToArray();
        }

        public TypeTreeDataBase Merage(TypeTreeDataBase dataBase)
        {
            TypeTreeDataBase ret = new TypeTreeDataBase();
            int[] allVersion = dataBase.GetAllVersion();
            foreach (int version in allVersion) {
                var allType = dataBase.GetAllType(version);
                foreach (var kv in allType) {
                    var classID = kv.Key;
                    var type = kv.Value;
                    ret.Put(version, classID, type);
                }
            }
            allVersion = GetAllVersion();
            foreach (int version in allVersion) {
                var allType = GetAllType(version);
                foreach (var kv in allType) {
                    var classID = kv.Key;
                    var type = kv.Value;
                    ret.Put(version, classID, type);
                }
            }
            return ret;
        }


        public void Serialize(Stream stream)
        {
            BinaryWriter bw = new BinaryWriter(stream);
            int curIndex = 0;
            Dictionary<TypeTree, int> typeIndexDic = new Dictionary<TypeTree, int>();
            foreach (var kvr in mTypeDic) {
                int version = kvr.Key;
                foreach (var typeDic in kvr.Value) {
                    var type = typeDic.Value;
                    typeIndexDic[type] = curIndex++;
                    var children = type.GetChildren(true);
                    foreach (var child in children) {
                        typeIndexDic[child] = curIndex++;
                    }
                }
            }

            bw.Write(typeIndexDic.Keys.Count);
            foreach (var kvr in mTypeDic) {
                int version = kvr.Key;
                foreach (var typeDic in kvr.Value) {
                    int classID = typeDic.Key;
                    var type = typeDic.Value;
                    int parentIndex = -1;
                    if (type.parent != null) {
                        parentIndex = typeIndexDic[type.parent];
                    }
                    bw.Write(version);
                    bw.Write(classID);
                    bw.Write(parentIndex);
                    bw.Write(type.type);
                    bw.Write(type.name);
                    bw.Write(type.metaFlag);
                    var children = type.GetChildren(true);
                    foreach (var child in children) {
                        parentIndex = -1;
                        if (child.parent != null) {
                            parentIndex = typeIndexDic[child.parent];
                        }
                        bw.Write(version);
                        bw.Write(classID);
                        bw.Write(parentIndex);
                        bw.Write(child.type);
                        bw.Write(child.name);
                        bw.Write(child.metaFlag);
                    }

                }
            }
        }

        public void UnSerialize(Stream stream)
        {
            BinaryReader br = new BinaryReader(stream);
            int numOfTypes = br.ReadInt32();
            TypeTree[] trees = new TypeTree[numOfTypes];
            Dictionary<TypeTree, int> typeVersionDic = new Dictionary<TypeTree, int>();
            Dictionary<TypeTree, int> typeClassIDDic = new Dictionary<TypeTree, int>();
            Dictionary<TypeTree, int> typeParentDic = new Dictionary<TypeTree, int>();
            for (int i = 0; i < numOfTypes; i++) {
                trees[i] = new TypeTree();
                typeVersionDic[trees[i]] = br.ReadInt32();
                typeClassIDDic[trees[i]] = br.ReadInt32();
                typeParentDic[trees[i]] = br.ReadInt32();
                trees[i].type = br.ReadString();
                trees[i].name = br.ReadString();
                trees[i].metaFlag = br.ReadInt32();
            }

            for (int i = 0; i < numOfTypes; i++) {
                int version = typeVersionDic[trees[i]];
                int classID = typeClassIDDic[trees[i]];
                int parentIndex = typeParentDic[trees[i]];
                if (parentIndex == -1) {
                    Put(version, classID, trees[i]);
                } else {
                    var parent = trees[parentIndex];
                    parent.AddChild(trees[i]);
                }
            }
        }
    }
}
