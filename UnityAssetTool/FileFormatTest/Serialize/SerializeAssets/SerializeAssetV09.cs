using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FileFormatTest
{

    public class SerializeAssetV09 : SerializeDataStruct
    {

        public SerializeAssetHeader header = new SerializeAssetHeader();

        public string UnityVersion;
        public int attributes;
        //type tree
        public bool embedded;
        public int numOfBaseClasses;
        public BaseClass[] classes;

        //object info table
        public int numOfObjects;
        public AssetObject[] objectInfos;


        public override  void UnSerialize(DataReader br)
        {

            header.UnSerialize(br);
            br.byteOrder = DataReader.ByteOrder.Little;
            UnityVersion = br.ReadStringNull();
            attributes = br.ReadInt32();
            embedded = br.ReadBool();
            numOfBaseClasses = br.ReadInt32();
            classes = new BaseClass[numOfBaseClasses];
            for (int i = 0; i < numOfBaseClasses; i++) {
                classes[i] = new BaseClass(embedded);
                classes[i].UnSerialize(br);
            }

            numOfObjects = br.ReadInt32();
            br.Align(4);
            objectInfos = new AssetObject[numOfObjects];
            for (int i = 0; i < numOfObjects; i++) {
                objectInfos[i] = new AssetObject((int)header.DataOffset);
                objectInfos[i].UnSerialize(br);
            }
        }

        #region sub classes

        public class SerializeAssetHeader : SerializeDataStruct
        {
            public int MetaDataSize;
            public uint FileSize;
            public int Version;
            public uint DataOffset;
            public byte endianness;
            public byte[] reserved;
            
            public override void UnSerialize(DataReader data)
            {
                data.byteOrder = DataReader.ByteOrder.Big;
                MetaDataSize = data.ReadInt32();
                FileSize = data.ReadUint32();
                Version = data.ReadInt32();
                DataOffset = data.ReadUint32();
                endianness = data.ReadByte();
                reserved = data.ReadBytes(3);
            }
        }



        public class BaseClass : SerializeDataStruct
        {
            public int ClassID;
            public byte[] hash;
            public byte[] oldhash;
            public int fildsCount;
            public int strTableSize;
            public BaseClassType[] types;
            public byte[] stringTable;
            private bool isEmbedded;
            public BaseClass(bool embedded)
            {
                isEmbedded = embedded;
            }

            public override void UnSerialize(DataReader br)
            {
                ClassID = br.ReadInt32();
                if (ClassID < 0) {
                    hash = br.ReadBytes(16);
                } 
                oldhash = br.ReadBytes(16);
                if (isEmbedded) {
                    fildsCount = br.ReadInt32();
                    strTableSize = br.ReadInt32();
                    types = new BaseClassType[fildsCount];
                    for (int i = 0; i < fildsCount; i++) {
                        types[i] = new BaseClassType();
                        types[i].UnSerialize(br);
                    }
                    stringTable = br.ReadBytes(strTableSize);
                }
            }
        }

        public class BaseClassType : SerializeDataStruct
        {
            public short version;
            public byte treeLevel;
            public bool isArray;
            public int typeOffset;
            public int nameOffset;
            public int size;
            public int index;
            public int metaFlag;
            public override void UnSerialize(DataReader br)
            {
                version = br.ReadInt16();
                treeLevel = br.ReadByte();
                isArray = br.ReadBool();
                typeOffset = br.ReadInt32();
                nameOffset = br.ReadInt32();
                size = br.ReadInt32();
                index = br.ReadInt32();
                metaFlag = br.ReadInt32();
            }
        }

        public class AssetObject : SerializeDataStruct
        {
            private int mDataOffset;
            public AssetObject(int dataOffet)
            {
                mDataOffset = dataOffet;
            }

            public long PathID;
            // Object data offset
            public uint offset;

            // Object data size
            public uint length;

            // Type ID, equal to classID if it's not a MonoBehaviour
            public int typeID;

            // Class ID, probably something else in asset format <=5
            public short classID;

            // set to 1 if destroyed object instances are stored?
            public short isDestroyed;

            public byte[] reserved;

            public byte [] data;

            public override void UnSerialize(DataReader br)
            {
                PathID = br.ReadInt64();
                offset = br.ReadUint32();
                length = br.ReadUint32();
                typeID = br.ReadInt32();
                classID = br.ReadInt16();
                isDestroyed = br.ReadInt16();
                reserved = br.ReadBytes(4);
                data = br.GetRangeBytes((uint)(mDataOffset + offset), length);
            }
        }

        #endregion
    }






}
