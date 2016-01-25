using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
namespace UnityAssetTool
{


    public enum SerializePropertyType
    {
        Unkonw,
        Base,
        Stuct,
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
        Double,
        String
    }


    public class SerializeProperty : SerializeDataStruct
    {
        public SerializeProperty parent;
        public List<SerializeProperty> children = new List<SerializeProperty>();

        public SerializePropertyType type;
        bool mIsArray = false;
        int arrayLength = 0;
        TypeTree mType;
        private object value;
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


        public string FullName
        {
            get
            {
               return  this.mType.FullName;
            }
        }

        public string Name
        {
            get
            {
                return this.mType.name;
            }
        }


        public SerializeProperty FindChild(string fullName)
        {
            if (this.FullName == fullName) return this;
            for (int i = 0; i < children.Count; i++) {
                var child = children[i].FindChild(fullName);
                if (child != null) return child;
            }
            return null;
        }



        private object readValue(TypeTree typeTree, DataReader data)
        {

            switch (typeTree.type) {
                case "bool":
                type = SerializePropertyType.Bool;
                return data.ReadBool();
                case "SInt8":
                type = SerializePropertyType.SByte;
                return data.ReadSbyte();
                case "char":
                case "UInt8":
                type = SerializePropertyType.Byte;
                return data.ReadByte();
                case "short":
                case "SInt16":
                type = SerializePropertyType.Short;
                return data.ReadInt16();
                case "unsigned short":
                case "UInt16":
                type = SerializePropertyType.UShort;
                return data.ReadUInt16();
                case "int":
                case "SInt32":
                type = SerializePropertyType.Int;
                return data.ReadInt32();
                case "unsigned int":
                case "UInt32":
                type = SerializePropertyType.UInt;
                return data.ReadUint32();
                case "long":
                case "SInt64":
                type = SerializePropertyType.Long;
                return data.ReadInt64();
                case "unsigned long":
                case "UInt64":
                type = SerializePropertyType.ULong;
                return data.ReadUInt64();
                case "float":
                type = SerializePropertyType.Float;
                return data.readFloat();
                case "double":
                type = SerializePropertyType.Double;
                return data.readDouble();
                case "string":
                type = SerializePropertyType.String;
                int strSize = data.ReadInt32();
                return UTF8Encoding.Default.GetString(data.ReadBytes(strSize));
                case "Array":
                case "TypelessData":
                arrayLength = data.ReadInt32();
                mIsArray = true;
                
                break;
                default:
                type = SerializePropertyType.Stuct;
                SerializeObject sobj = new SerializeObject(mType, data);
                return sobj;
            }
        }

        public override void DeSerialize(DataReader data)
        {
            if (mType.type == "Base") {
                var children = mType.GetChildren();
                foreach (var child in children) {
                    SerializeProperty property = new SerializeProperty(child);
                    property.DeSerialize(data);
                    AddChild(property);
                }
            } else {
                value = readValue(mType, data);
                if (((mType.metaFlag & TypeTree.FLAG_FORCE_ALIGN) != 0) || IsArray) {
                    data.Align(4);
                }
            }



        }


        #region GetValue

        public bool BoolValue
        {
            get
            {
                return BitConverter.ToBoolean(mRawdata, 0);
            }
           
        }

        public short ShortValue
        {
            get
            {
                return BitConverter.ToInt16(mRawdata, 0);
            }
            
        }

        public ushort UShortValue
        {
            get
            {
                return BitConverter.ToUInt16(mRawdata, 0);
            }
            
        }

        public int IntValue
        {
            get
            {
                return BitConverter.ToInt32(mRawdata, 0);
            }
        }

        public uint UIntValue
        {
            get
            {
                return BitConverter.ToUInt32(mRawdata, 0);
            }
        }


        public long LongValue
        {
            get
            { return BitConverter.ToInt64(mRawdata, 0); }
        }

        public ulong ULongValue
        {
            get
            { return BitConverter.ToUInt64(mRawdata, 0); }
        }

        public float FloatValue
        {
            get
            { return BitConverter.ToSingle(mRawdata, 0); }
        }

        public double DoubleValue
        {
            get
            { return BitConverter.ToDouble(mRawdata, 0); }
        }

        public byte ByteValue
        {
            get
            { return mRawdata[0]; }
        }
        public sbyte SByteValue
        {
            get
            { return (sbyte)mRawdata[0]; }
        }

        public string StringValue
        {
            get
            { return System.Text.UTF8Encoding.Default.GetString(mRawdata); }
        }

        public byte[] ByteArrayValue
        {
            get
            { return mRawdata; }
        }


        public string GetValueString()
        {
            if (mType.type == "string") {
                return StringValue;
            }
            if (mIsArray) {
                return "Array";
            }
            switch (type) {
                case SerializePropertyType.Bool:
                return BoolValue.ToString();
                case SerializePropertyType.Byte:
                return ByteValue.ToString();
                case SerializePropertyType.Double:
                return DoubleValue.ToString();
                case SerializePropertyType.Float:
                return FloatValue.ToString();
                case SerializePropertyType.Int:
                return IntValue.ToString();
                case SerializePropertyType.Long:
                return LongValue.ToString();
                case SerializePropertyType.SByte:
                return SByteValue.ToString();
                case SerializePropertyType.Short:
                return ShortValue.ToString();
                case SerializePropertyType.UInt:
                return UIntValue.ToString();
                case SerializePropertyType.ULong:
                return ULongValue.ToString();
                case SerializePropertyType.UShort:
                return UShortValue.ToString();
            }
            return "";
        }

        public override string ToString()
        {
            string finalStr = "";
            string tabStr = "";
            var it = parent;
            while (it != null) {
                tabStr += "   ";
                it = it.parent;
            }

            finalStr = mType.type + " " + Name;
            if (type != SerializePropertyType.Base) {
                finalStr += ":" + GetValueString() + "\n";
            } else {
                finalStr += "\n";
            }
            if (children.Count > 0) {
                finalStr = finalStr + tabStr + "{\n";
                for (int i = 0; i < children.Count; i++) {
                    finalStr = finalStr + tabStr + "    " + children[i].ToString();
                }
                finalStr = finalStr + tabStr + "}\n";
            }
            return finalStr;
        }

        #endregion

    }
}
