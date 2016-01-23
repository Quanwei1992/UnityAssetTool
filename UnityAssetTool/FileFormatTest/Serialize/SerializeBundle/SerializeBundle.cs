using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SevenZip.Compression;
using System.IO;

namespace FileFormatTest
{
    class SerializeBundle : SerializeDataStruct
    {
        public SerializeBundleHeader header = new SerializeBundleHeader();
        public int numOfEntryCount;
        public SerializeBundleEntry[] entrys;

        public override void DeSerialize(DataReader data)
        {
            header.DeSerialize(data);
            uint n1 = BitConverter.ToUInt32(new byte[] { 1, 0, 0, 0 }, 0);
            data.byteOrder = DataReader.ByteOrder.Little;
            //compress with lzma
            if (!header.signature.Contains("UnityRaw")) {
                SevenZip.Compression.LZMA.Decoder decoder = new SevenZip.Compression.LZMA.Decoder();
                data.position = header.headerSize;
                byte[] properties = data.ReadBytes(5);
                long uncompressFileSize = data.ReadInt64();
                decoder.SetDecoderProperties(properties);
                MemoryStream outMs = new MemoryStream((int)uncompressFileSize);
                decoder.Code(data.BaseStream,outMs,data.BaseStream.Length-header.headerSize,uncompressFileSize,null);
                data.Close();
                data = new DataReader(outMs);
                data.position = 0;
            }
            data.byteOrder = DataReader.ByteOrder.Big;
            numOfEntryCount = data.ReadInt32();
            entrys = new SerializeBundleEntry[numOfEntryCount];
            for (int i = 0; i < numOfEntryCount; i++) {
                entrys[i] = new SerializeBundleEntry();
                entrys[i].DeSerialize(data);
            }
        }




    }
}
