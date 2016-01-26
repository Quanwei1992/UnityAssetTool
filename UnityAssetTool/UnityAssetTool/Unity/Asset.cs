using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UnityAssetTool
{
    public class Asset
    {
        public int AssetVersion { get; private set; }
        public string UnityVersion { get; private set; }

        public TypeTreeDataBase TypeTreeDatabase { get; private set; }

        public AssetObjectInfo[] ObjectInfos { get; private set; }



        public Asset(SerializeDataStruct serializeAsset)
        {
            TypeTreeDatabase = SerializeUtility.GenerateTypeTreeDataBase(serializeAsset);
            if (serializeAsset is SerializeAssetV15) {
                Init(serializeAsset as SerializeAssetV15);
            } else if (serializeAsset is SerializeAssetV09) {
                Init(serializeAsset as SerializeAssetV09);
            } else {
                throw new Exception("Can't init asset with " + serializeAsset);
            }
        }

        public void Init(SerializeAssetV15 serializeAsset)
        {
            AssetVersion = serializeAsset.header.Version;
            UnityVersion = serializeAsset.UnityVersion;
            ObjectInfos = new AssetObjectInfo[serializeAsset.numOfObjects];
            for (int i = 0; i < serializeAsset.numOfObjects; i++) {
                ObjectInfos[i] = new AssetObjectInfo();
                ObjectInfos[i].PathID = (ulong)serializeAsset.objectInfos[i].PathID;
                ObjectInfos[i].classID = serializeAsset.objectInfos[i].classID;
                ObjectInfos[i].typeID = serializeAsset.objectInfos[i].typeID;
                ObjectInfos[i].isDestroyed = serializeAsset.objectInfos[i].isDestroyed == 1;
                ObjectInfos[i].data = serializeAsset.objectInfos[i].data;
            }

            
        }
        public void Init(SerializeAssetV09 serializeAsset)
        {
            AssetVersion = serializeAsset.header.Version;
            UnityVersion = serializeAsset.UnityVersion;
            ObjectInfos = new AssetObjectInfo[serializeAsset.numOfObjects];
            for (int i = 0; i < serializeAsset.numOfObjects; i++) {
                ObjectInfos[i] = new AssetObjectInfo();
                ObjectInfos[i].PathID = (ulong)serializeAsset.objectInfos[i].PathID;
                ObjectInfos[i].classID = serializeAsset.objectInfos[i].classID;
                ObjectInfos[i].typeID = serializeAsset.objectInfos[i].typeID;
                ObjectInfos[i].isDestroyed = serializeAsset.objectInfos[i].isDestroyed == 1;
                ObjectInfos[i].data = serializeAsset.objectInfos[i].data;
            }
        }
        public class AssetObjectInfo
        {
            public ulong PathID;
            // Object data size
            public ulong length;

            // Type ID, equal to classID if it's not a MonoBehaviour
            public int typeID;

            // Class ID, probably something else in asset format <=5
            public short classID;

            // set to 1 if destroyed object instances are stored?
            public bool isDestroyed;

            public byte[] data;
        }

    }
}
