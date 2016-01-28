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
            typeTreeDatabase = AssetToolUtility.LoadTypeTreeDataBase(Resources.TypeTreeDataBasePath);
            base.run();
            AssetToolUtility.SaveTypeTreeDataBase(Resources.TypeTreeDataBasePath, typeTreeDatabase);
            Console.WriteLine("TotalSize:{0} kb", totalSize / 1024.0f);
            var sortedDic = mSizeDic.OrderByDescending(x => x.Value).ToDictionary(x => x.Key, x => x.Value);
            foreach (var kvp in sortedDic) {
                string className = AssetToolUtility.ClassIDToClassName(kvp.Key);
                Console.WriteLine("{0,-30} Size:{1,-15}kb {2,-15}%", className, kvp.Value / 1024.0f, (kvp.Value / (float)totalSize) * 100);
            }
        }
        public override void runAssetFile(Asset asset)
        {
            foreach (var obj in asset.ObjectInfos) {
                ulong oldSize = 0;
                mSizeDic.TryGetValue(obj.classID, out oldSize);
                mSizeDic[obj.classID] = oldSize + obj.length;
                totalSize += obj.length;
                var typeTree = typeTreeDatabase.GetType(asset.AssetVersion, obj.classID);
                if (typeTree != null) {
                    try {
                        SerializeObject sobj = new SerializeObject(typeTree, obj.data);
                        var property = sobj.FindProperty("m_Resource.m_Size");
                        if (property != null) {
                            ulong resSize = (ulong)property.Value;
                            totalSize += resSize;
                            mSizeDic[obj.classID] += resSize;
                        }
                    } catch {
                        Debug.LogError("Can't Create SerializeObject.TypeVerion:{0},TypeClassID:{1},TypeName:{2}",
                       typeTree.version, obj.classID, typeTree.type);
                    }

                }
            }
        }
    }
}

