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

        public int numOfTypeTrees;
        public SerializeTypeTree[] typeTrees;

        //object info table
        public int numOfObjects;
        public SerializeAssetObject[] objectInfos;

        public int numOfFileIdentifiers;
        public SerializeFileIdentifier[] fileIdentifiers;

        public override void UnSerialize(DataReader data)
        {

            header.UnSerialize(data);
            data.byteOrder = DataReader.ByteOrder.Little;
            UnityVersion = data.ReadStringNull();
            attributes = data.ReadInt32();

            numOfTypeTrees = data.ReadInt32();
            typeTrees = new SerializeTypeTree[numOfTypeTrees];
            
            for (int i = 0; i < numOfTypeTrees; i++) {
                typeTrees[i] = new SerializeTypeTree();
                typeTrees[i].UnSerialize(data);
            }
            //padding
            data.ReadInt32();

            numOfObjects = data.ReadInt32();
            objectInfos = new SerializeAssetObject[numOfObjects];
            for (int i = 0; i < numOfObjects; i++) {
                objectInfos[i] = new SerializeAssetObject((int)header.DataOffset);
                objectInfos[i].UnSerialize(data);
            }

            numOfFileIdentifiers = data.ReadInt32();
            fileIdentifiers = new SerializeFileIdentifier[numOfFileIdentifiers];
            for (int i = 0; i < numOfFileIdentifiers; i++) {
                fileIdentifiers[i] = new SerializeFileIdentifier();
                fileIdentifiers[i].UnSerialize(data);
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



        public class SerializeTypeTree : SerializeDataStruct
        {
            public int ClassID;
            public SerializeTypeTreeData rootType;

            public override void UnSerialize(DataReader data)
            {
                ClassID = data.ReadInt32();
                rootType = new SerializeTypeTreeData();
                rootType.UnSerialize(data);

            }

            private void readTypeDatas(DataReader data)
            {
                SerializeTypeTreeData node = new SerializeTypeTreeData();
                node.UnSerialize(data);
                int numOfChildren = data.ReadInt32();
                for (int i = 0; i < numOfChildren; i++) {
                    readTypeDatas(data);
                }
            }
        }

        public class SerializeTypeTreeData : SerializeDataStruct
        {
            public string type;
            public string name;
            public int size;
            public int index;
            /// <summary>
            /// 1 == true
            /// </summary>
            public int isArray;
            public int version;
            public int metaFlag;

            public int numOfChildren;
            public SerializeTypeTreeData[] children;

            public override void UnSerialize(DataReader data)
            {
                type = data.ReadStringNull();
                name = data.ReadStringNull();
                size = data.ReadInt32();
                index = data.ReadInt32();
                isArray = data.ReadInt32();
                version = data.ReadInt32();
                metaFlag = data.ReadInt32();
                numOfChildren = data.ReadInt32();
                children = new SerializeTypeTreeData[numOfChildren];
                for (int i = 0; i < numOfChildren; i++) {
                    children[i] = new SerializeTypeTreeData();
                    children[i].UnSerialize(data);
                }
            }
        }

        public class SerializeAssetObject : SerializeDataStruct
        {
            private int mDataOffset;
            public SerializeAssetObject(int dataOffet)
            {
                mDataOffset = dataOffet;
            }

            public uint PathID;
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

            public byte[] data;

            public override void UnSerialize(DataReader br)
            {
                PathID = br.ReadUint32();
                offset = br.ReadUint32();
                length = br.ReadUint32();
                typeID = br.ReadInt32();
                classID = br.ReadInt16();
                isDestroyed = br.ReadInt16();
                data = br.GetRangeBytes((uint)(mDataOffset + offset), length);
            }
        }


        public class SerializeFileIdentifier : SerializeDataStruct
        {
            public string assetPath;
            public long guidMost;
            public long guidLeast;
            public int type;
            public string filePath;

            public override void UnSerialize(DataReader data)
            {
                assetPath = data.ReadStringNull();
                var oldOrder = data.byteOrder;
                data.byteOrder = DataReader.ByteOrder.Big;
                guidMost = data.ReadInt64();
                guidLeast = data.ReadInt64();
                data.byteOrder = oldOrder;
                type = data.ReadInt32();
                filePath = data.ReadStringNull();

            }
        }
        #endregion
    }






}
