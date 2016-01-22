using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
namespace FileFormatTest
{


    public enum SerializePropertyType
    {
        Unkonw,
        Base,
        Bool,
        SByte,
        Byte,
        Short,
        UShort,
        Int,
        UInt,
        Long,
        ULong,
        Float,
        Double
    }


    class SerializeProperty : SerializeDataStruct
    {
        public SerializeProperty parent;
        public List<SerializeProperty> children = new List<SerializeProperty>();

        public SerializePropertyType type;
        bool mIsArray = false;
        int arrayLength = 0;
        TypeTree mType;
        byte[] mRawdata;
       
        public bool IsArray
        {
            get
            {
                return mIsArray;
            }
        }

       
        public SerializeProperty(TypeTree type)
        {
            mType = type;
        }

        private void AddChild(SerializeProperty child)
        {
            child.parent = this;
            children.Add(child);
        }


        public override void UnSerialize(DataReader br)
        {
            
            int size = 0;
            string typeStr = mType.type;
            if (mType.type == "Array" || mType.type == "TypelessData") {
                var children = mType.GetChildren();
                if (children.Length == 2) {
                    typeStr = children[1].type;
                    mIsArray = true;
                }
            }
            if (mType.type == "string") {
                var children = mType.GetChildren();
                if (children.Length == 1) {
                    children = children[0].GetChildren();
                    if (children.Length == 2) {
                        typeStr = children[1].type;
                        mIsArray = true;
                    }
                }
            }
            switch (typeStr) {
                case "Base":
                size = (int)br.BaseStream.Length - (int)br.BaseStream.Position;
                type = SerializePropertyType.Base;
                break;
                case "bool":
                size = sizeof(bool);
                type = SerializePropertyType.Bool;
                break;
                case "SInt8":
                size = sizeof(sbyte);
                type = SerializePropertyType.SByte;
                break;
                case "char":
                case "UInt8":
                size = sizeof(byte);
                type = SerializePropertyType.Byte;
                break;
                case "short":
                case "SInt16":
                size = sizeof(short);
                type = SerializePropertyType.Short;
                break;
                case "unsigned short":
                case "UInt16":
                size = sizeof(ushort);
                type = SerializePropertyType.UShort;
                break;
                case "int":
                case "SInt32":
                size = sizeof(int);
                type = SerializePropertyType.Int;
                break;
                case "unsigned int":
                case "UInt32":
                size = sizeof(uint);
                type = SerializePropertyType.UInt;
                break;
                case "long":
                case "SInt64":
                size = sizeof(long);
                type = SerializePropertyType.Long;
                break;
                case "unsigned long":
                case "UInt64":
                size = sizeof(ulong);
                type = SerializePropertyType.ULong;
                break;
                case "float":
                size = sizeof(float);
                type = SerializePropertyType.Float;
                break;
                case "double":
                size = sizeof(double);
                type = SerializePropertyType.Double;
                break;
                default:
                type = SerializePropertyType.Base;
                break;
            }

            if (IsArray) {
                int length = br.ReadInt32();
                arrayLength = length;
                mRawdata = br.ReadBytes(length * size);
                br.Align(4);
                return;
            }
            mRawdata = br.ReadBytes(size);
            if ((mType.metaFlag & TypeTree.FLAG_FORCE_ALIGN) != 0) {
                br.Align(4);
            }
            if (type != SerializePropertyType.Base) return;

            var chirenType = mType.GetChildren();
            foreach (var child in chirenType) {
                SerializeProperty property = new SerializeProperty(child);
                property.UnSerialize(br);
                AddChild(property);
            }
        }


        #region GetValue


        public short ShortValue()
        {
            return BitConverter.ToInt16(mRawdata, 0);
        }

        public ushort UShortValue()
        {
            return BitConverter.ToUInt16(mRawdata, 0);
        }

        public int IntValue()
        {
            return BitConverter.ToInt32(mRawdata, 0);
        }

        public uint UIntValue()
        {
            return BitConverter.ToUInt32(mRawdata, 0);
        }


        public long LongValue()
        {
            return BitConverter.ToInt64(mRawdata, 0);
        }

        public ulong ULongValue()
        {
            return BitConverter.ToUInt64(mRawdata, 0);
        }

        public float FloatValue()
        {
            return BitConverter.ToSingle(mRawdata, 0);
        }

        public double DoubleValue()
        {
            return BitConverter.ToDouble(mRawdata, 0);
        }

        public byte ByteValue()
        {
            return mRawdata[0];
        }
        public sbyte SByteValue()
        {
            return (sbyte)mRawdata[0];
        }

        public string StringValue()
        {
            return BitConverter.ToString(mRawdata);
        }

        public byte[] ByteArrayValue()
        {
            return mRawdata;
        }
        #endregion

    }
}
