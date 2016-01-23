using System.Collections.Generic;

namespace UnityAssetTool
{
    //支持V3及以上
    class SerializeBundleHeader :　SerializeDataStruct
    {
        public string signature;
        public int streamVersion;
        public string unityVersion;
        public string unityRevision;
        public uint minimumStreamedBytes;
        public int headerSize;
        public int numberOfLevelsToDownload;
        public int numberOfLevels;
        public List<KeyValuePair<uint, uint>> levelByteEnd = new List<KeyValuePair<uint, uint>>();
        public uint completeFileSize;
        public uint dataHeaderSize;
        public byte[] resvers;
        public override void DeSerialize(DataReader br)
        {
            br.byteOrder = DataReader.ByteOrder.Big;
            signature = br.ReadStringNull();
            streamVersion = br.ReadInt32();
            unityVersion = br.ReadStringNull();
            unityRevision = br.ReadStringNull();
            minimumStreamedBytes = br.ReadUInt32();
            headerSize = br.ReadInt32();

            numberOfLevelsToDownload = br.ReadInt32();
            numberOfLevels = br.ReadInt32();
            levelByteEnd.Clear();
            for (int i = 0; i < numberOfLevels; i++) {
                levelByteEnd.Add(new KeyValuePair<uint, uint>(br.ReadUInt32(), br.ReadUInt32()));
            }
            completeFileSize = br.ReadUInt32();
            dataHeaderSize = br.ReadUInt32();
            resvers = br.ReadBytes(1);
        }
    }
}
