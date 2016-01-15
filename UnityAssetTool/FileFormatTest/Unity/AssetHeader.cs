using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FileFormatTest
{
    public class AssetHeader:DataStuct
    {
        public int MetaDataSize;
        public uint FileSize;
        public int Version;

        public override void Read(DataReader br)
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
