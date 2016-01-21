using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FileFormatTest
{
    public class AssetHeader:SerializeDataStruct
    {
        public int MetaDataSize;
        public uint FileSize;
        public int Version;

        public override void UnSerialize(DataReader br)
        {
            var oldOrder = br.byteOrder;
            br.byteOrder = DataReader.ByteOrder.Big;
            MetaDataSize = br.ReadInt32();
            FileSize = br.ReadUint32();
            Version = br.ReadInt32();
            br.byteOrder = oldOrder;
        }
    }
}
