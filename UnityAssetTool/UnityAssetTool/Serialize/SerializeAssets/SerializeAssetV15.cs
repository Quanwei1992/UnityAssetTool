using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UnityAssetTool
{

    public class SerializeAssetV15 : SerializeDataStruct
    {


        public SerializeAssetHeader header = new SerializeAssetHeader();

        public string UnityVersion;
        public int attributes;
        //type tree
        public bool embedded;
        public int numOfBaseClasses;
        public SerializeTypeTreeData[] classes;

        //object info table
        public int numOfObjects;
        public SerializeAssetObject[] objectInfos;

        public int numOfObjectIdentifiers;
        public SerializeObjectIdentifier[] objectIdentifiers;

        public int numOfFileIdentifiers;
        public SerializeFileIdentifier[] fileIdentifiers;

       

        public override  void DeSerialize(DataReader br)
        {

            header.DeSerialize(br);
            br.byteOrder = DataReader.ByteOrder.Little;
            UnityVersion = br.ReadStringNull();
            attributes = br.ReadInt32();
            embedded = br.ReadBool();
            numOfBaseClasses = br.ReadInt32();
            classes = new SerializeTypeTreeData[numOfBaseClasses];
            for (int i = 0; i < numOfBaseClasses; i++) {
                classes[i] = new SerializeTypeTreeData(embedded);
                classes[i].DeSerialize(br);
            }

            numOfObjects = br.ReadInt32();
            objectInfos = new SerializeAssetObject[numOfObjects];
            for (int i = 0; i < numOfObjects; i++) {
                objectInfos[i] = new SerializeAssetObject((int)header.DataOffset);
                objectInfos[i].DeSerialize(br);
            }

            numOfObjectIdentifiers = br.ReadInt32();
            objectIdentifiers = new SerializeObjectIdentifier[numOfObjectIdentifiers];
            for (int i = 0; i < numOfObjectIdentifiers; i++) {
                objectIdentifiers[i] = new SerializeObjectIdentifier();
                objectIdentifiers[i].DeSerialize(br);
            }

            numOfFileIdentifiers = br.ReadInt32();
            fileIdentifiers = new SerializeFileIdentifier[numOfFileIdentifiers];
            for (int i = 0; i < numOfFileIdentifiers; i++) {
                fileIdentifiers[i] = new SerializeFileIdentifier();
                fileIdentifiers[i].DeSerialize(br);
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
            
            public override void DeSerialize(DataReader data)
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

        

        public class SerializeTypeTreeData : SerializeDataStruct
        {
            public int ClassID;
            public byte[] hash;
            public byte[] oldhash;
            public int fildsCount;
            public int strTableSize;
            public SerializeTypeData[] types;
            public byte[] stringTable;
            private bool isEmbedded;
            public SerializeTypeTreeData(bool embedded)
            {
                isEmbedded = embedded;
            }

            public override void DeSerialize(DataReader br)
            {
                ClassID = br.ReadInt32();
                if (ClassID < 0) {
                    hash = br.ReadBytes(16);
                } 
                oldhash = br.ReadBytes(16);
                if (isEmbedded) {
                    fildsCount = br.ReadInt32();
                    strTableSize = br.ReadInt32();
                    types = new SerializeTypeData[fildsCount];
                    for (int i = 0; i < fildsCount; i++) {
                        types[i] = new SerializeTypeData();
                        types[i].DeSerialize(br);
                    }
                    stringTable = br.ReadBytes(strTableSize);
                }
            }
        }

        public class SerializeTypeData : SerializeDataStruct
        {
            public short version;
            public byte treeLevel;
            public bool isArray;
            public int typeOffset;
            public int nameOffset;
            public int size;
            public int index;
            public int metaFlag;
            public override void DeSerialize(DataReader br)
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

        public class SerializeAssetObject : SerializeDataStruct
        {
            private int mDataOffset;
            public SerializeAssetObject(int dataOffet)
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

            public short scriptTypeIndex;

            public bool stripped;

            public byte [] data;

            public override void DeSerialize(DataReader br)
            {
                br.Align(4);
                PathID = br.ReadInt64();
                offset = br.ReadUint32();
                length = br.ReadUint32();
                typeID = br.ReadInt32();
                classID = br.ReadInt16();
                scriptTypeIndex = br.ReadInt16();
                stripped = br.ReadBool();
                data = br.GetRangeBytes((uint)(mDataOffset + offset), length);
            }
        }


        public class SerializeObjectIdentifier : SerializeFileIdentifier
        {
            public int serializeFileIndex;
            public long identifierInFile;
            public override void DeSerialize(DataReader data)
            {
                serializeFileIndex = data.ReadInt32();
                identifierInFile = data.ReadInt64();
                data.Align(4);
            }
        }


        public class SerializeFileIdentifier : SerializeDataStruct
        {
            public string assetPath;
            public long guidMost;
            public long guidLeast;
            public int type;
            public string filePath;

            public override void DeSerialize(DataReader data)
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
