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
        Property,
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
       
        public bool IsArray
        {
            get
            {
                return mIsArray;
            }
        }

        public int ArrayLength
        {
            get
            {
                return arrayLength;
            }
        }


        public object Value
        {
            get
            {
                return value;
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
            object ret = null;
            switch (typeTree.type) {
                case "bool":
                type = SerializePropertyType.Bool;
                ret = data.ReadBool();
                break;
                case "SInt8":
                type = SerializePropertyType.SByte;
                ret = data.ReadSbyte();
                break;
                case "char":
                case "UInt8":
                type = SerializePropertyType.Byte;
                ret = data.ReadByte();
                break;
                case "short":
                case "SInt16":
                type = SerializePropertyType.Short;
                ret = data.ReadInt16();
                break;
                case "unsigned short":
                case "UInt16":
                type = SerializePropertyType.UShort;
                ret = data.ReadUInt16();
                break;
                case "int":
                case "SInt32":
                type = SerializePropertyType.Int;
                ret = data.ReadInt32();
                break;
                case "unsigned int":
                case "UInt32":
                type = SerializePropertyType.UInt;
                ret = data.ReadUint32();
                break;
                case "long":
                case "SInt64":
                type = SerializePropertyType.Long;
                ret = data.ReadInt64();
                break;
                case "unsigned long":
                case "UInt64":
                type = SerializePropertyType.ULong;
                ret = data.ReadUInt64();
                break;
                case "float":
                type = SerializePropertyType.Float;
                ret = data.readFloat();
                break;
                case "double":
                type = SerializePropertyType.Double;
                ret = data.readDouble();
                break;
                case "string":
                type = SerializePropertyType.String;
                int strSize = data.ReadInt32();
                ret = UTF8Encoding.Default.GetString(data.ReadBytes(strSize));
                break;
                case "Array":
                case "TypelessData":
                arrayLength = data.ReadInt32();
                mIsArray = true;
                var elementType = typeTree.GetChildren()[1];
                object[] array = new object[arrayLength];
                for (int i = 0; i < arrayLength; i++) {
                    array[i] = readValue(elementType, data);
                }
                ret = array;
                break;
                default:
                type = SerializePropertyType.Property;
                var children = typeTree.GetChildren();
                foreach (var child in children) {
                    SerializeProperty property = new SerializeProperty(child);
                    property.DeSerialize(data);
                    AddChild(property);
                }
                ret = this;
                break;
            }

            if (((typeTree.metaFlag & TypeTree.FLAG_FORCE_ALIGN) != 0) || IsArray || type == SerializePropertyType.String) {
                data.Align(4);
            }

            return ret;
        }

        public override void DeSerialize(DataReader data)
        {
             value = readValue(mType, data);
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
            if (value == null) {
                int xxx = 45;
            }
            if (value != this) {
                if (type != SerializePropertyType.Base) {
                    finalStr += ":" + value.ToString() + "\n";
                } else {
                    finalStr += "\n";
                }
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
    }
}
