using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CommandLine;
using CommandLine.Parsing;
using CommandLine.Text;
namespace UnityAssetTool.Command
{
    using Properties;
    public class AssetSizeInfoCommand : AssetCommand
    {

        //classID,Size
        ulong totalSize = 0;
        Dictionary<int, ulong> mSizeDic = new Dictionary<int, ulong>();
        TypeTreeDataBase typeTreeDatabase;
        public override void run()
        {
            mSizeDic.Clear();
            typeTreeDatabase = SerializeUtility.LoadTypeTreeDataBase(Resources.TypeTreeDataBasePath);
            base.run();
            SerializeUtility.SaveTypeTreeDataBase(Resources.TypeTreeDataBasePath, typeTreeDatabase);
            Console.WriteLine("TotalSize:{0} kb", totalSize / 1024.0f);
            var sortedDic = mSizeDic.OrderByDescending(x => x.Value).ToDictionary(x => x.Key, x => x.Value);
            foreach (var kvp in sortedDic) {
                string className = SerializeUtility.ClassIDToClassName(kvp.Key);
                Console.WriteLine("{0,-30} Size:{1,-15}kb {2,-15}%", className, kvp.Value / 1024.0f, (kvp.Value / (float)totalSize) * 100);
            }
        }
        public override void runAssetFile(SerializeDataStruct asset)
        {
            if (asset is SerializeAssetV09) {
                var asset09 = asset as SerializeAssetV09;
                foreach (var obj in asset09.objectInfos) {
                    ulong oldSize = 0;
                    mSizeDic.TryGetValue(obj.classID, out oldSize);
                    mSizeDic[obj.classID] = oldSize + obj.length;
                    totalSize += obj.length;
                    var typeTree = typeTreeDatabase.GetType(9, obj.classID);
                    if (typeTree != null) {
                        SerializeObject sobj = new SerializeObject(typeTree, obj.data);
                        var property = sobj.FindProperty("Base.m_Resource.m_Size");
                        if (property != null) {
                            ulong resSize = (ulong)property.Value;
                            totalSize += resSize;
                            mSizeDic[obj.classID] += resSize;
                        }
                    }
                }
            }
            if (asset is SerializeAssetV15) {
                var asset15 = asset as SerializeAssetV15;
                foreach (var obj in asset15.objectInfos) {
                    ulong oldSize = 0;
                    mSizeDic.TryGetValue(obj.classID, out oldSize);
                    mSizeDic[obj.classID] = oldSize + obj.length;
                    totalSize += obj.length;
                    var typeTree = typeTreeDatabase.GetType(15, obj.classID);
                    if (typeTree != null) {
                        SerializeObject sobj = new SerializeObject(typeTree, obj.data);
                        var property = sobj.FindProperty("Base.m_Resource.m_Size");
                        if (property != null) {
                            ulong resSize = (ulong)property.Value;
                            totalSize += resSize;
                            mSizeDic[obj.classID] += resSize;
                        }
                    }
                }
            }
        }
    }
}

