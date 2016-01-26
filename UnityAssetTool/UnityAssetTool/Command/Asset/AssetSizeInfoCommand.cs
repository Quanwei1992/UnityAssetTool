using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UnityAssetTool.Command
{
    public class AssetSizeInfoCommand : AssetCommand
    {
        //classID,Size
        long totalSize = 0;
        Dictionary<int, long> mSizeDic = new Dictionary<int, long>();
        public override void run()
        {
            mSizeDic.Clear();
            base.run();
            Console.WriteLine("TotalSize:{0} kb", totalSize/1024.0f);
            var sortedDic = mSizeDic.OrderByDescending(x => x.Value).ToDictionary(x=>x.Key,x=>x.Value);
            foreach (var kvp in sortedDic) {
                Console.WriteLine("ClassID:{0} Size:{1} kb  {2}%", kvp.Key, kvp.Value/1024.0f,kvp.Value/(float)totalSize);
            }
        }
        public override void runAssetFile(SerializeDataStruct asset)
        {
            if (asset is SerializeAssetV09) {
                var asset09 = asset as SerializeAssetV09;
                foreach (var obj in asset09.objectInfos) {
                    long oldSize = 0;
                    mSizeDic.TryGetValue(obj.classID, out oldSize);
                    mSizeDic[obj.classID] = oldSize + obj.length;
                    totalSize += obj.length;
                }
            }
            if (asset is SerializeAssetV15) {
                var asset15 = asset as SerializeAssetV15;
                foreach (var obj in asset15.objectInfos) {
                    long oldSize = 0;
                    mSizeDic.TryGetValue(obj.classID, out oldSize);
                    mSizeDic[obj.classID] = oldSize + obj.length;
                    totalSize += obj.length;
                }
            }
        }
    }
}
