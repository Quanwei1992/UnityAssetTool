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
        String,
        Array
    }


    public class SerializeProperty : SerializeDataStruct
    {
        public SerializeProperty parent;
        public List<SerializeProperty> children = new List<SerializeProperty>();

        public SerializePropertyType propertyType;
        public SerializePropertyType arrayElementType;
        int arrayLength = 0;
        TypeTree mType;

        private object value;
       
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


        public SerializeProperty FindChild(string name)
        {
            string[] names = name.Split('.');
            if (names.Length > 0) {
                string childName = names[0];
                string subName = "";
                if (names.Length > 1) {
                    subName = name.Remove(0, names[0].Length + 1);
                }
                
                foreach (var child in children) {
                    if (child.Name == childName) {
                        if (string.IsNullOrEmpty(subName)) {
                            return child;
                        } else {
                            return child.FindChild(subName);
                        }
                    }
                }
            }
            return null;
        }



        private static SerializePropertyType typeStr2PropertyType(string typeStr)
        {
            switch (typeStr) {
                case "bool":
                return SerializePropertyType.Bool;
                case "SInt8":
                return SerializePropertyType.SByte;
                case "char":
                case "UInt8":
                return SerializePropertyType.Byte;
                case "short":
                case "SInt16":
                return SerializePropertyType.Short;
                case "unsigned short":
                case "UInt16":
                return SerializePropertyType.UShort;
                case "int":
                case "SInt32":
                return SerializePropertyType.Int;
                case "unsigned int":
                case "UInt32":
                return SerializePropertyType.UInt;
                case "long":
                case "SInt64":
                return SerializePropertyType.Long;
                case "unsigned long":
                case "UInt64":
                return SerializePropertyType.ULong;
                case "float":
                return SerializePropertyType.Float;
                case "double":
                return SerializePropertyType.Double;           
                case "string":
                return SerializePropertyType.String;
                case "Array":
                case "TypelessData":
                return SerializePropertyType.Array;
                default:
                return SerializePropertyType.Property;
            }
        }

        private object readValue(SerializePropertyType ptype,TypeTree typeTree, DataReader data)
        {
            
            object ret = null;
            switch (ptype) {
                case SerializePropertyType.Bool:
                ret = data.ReadBool();
                break;
                case SerializePropertyType.SByte:
                ret = data.ReadSbyte();
                break;
                case SerializePropertyType.Byte:
                ret = data.ReadByte();
                break;
                case SerializePropertyType.Short:
                ret = data.ReadInt16();
                break;
                case SerializePropertyType.UShort:
                ret = data.ReadUInt16();
                break;
                case SerializePropertyType.Int:
                ret = data.ReadInt32();
                break;
                case SerializePropertyType.UInt:
                ret = data.ReadUint32();
                break;
                case SerializePropertyType.Long:
                ret = data.ReadInt64();
                break;
                case SerializePropertyType.ULong:
                ret = data.ReadUInt64();
                break;
                case SerializePropertyType.Float:
                ret = data.ReadFloat();
                break;
                case SerializePropertyType.Double:
                ret = data.ReadDouble();
                break;
                case SerializePropertyType.String:
                int strSize = data.ReadInt32();
                ret = UnicodeEncoding.UTF8.GetString(data.ReadBytes(strSize));
                //ret = UTF8Encoding.Default.GetString();
                break;
                default:
                break;
            }

            if (((typeTree.metaFlag & TypeTree.FLAG_FORCE_ALIGN) != 0)  || propertyType == SerializePropertyType.String) {
                data.Align(4);
            }

            return ret;
        }


        public object readArrayValue(TypeTree typeTree, DataReader data)
        {            
            var elementType = typeTree.GetChildren()[1];
            arrayLength = data.ReadInt32();
            arrayElementType = typeStr2PropertyType(elementType.type);
            object ret = null;
            switch (arrayElementType) {
                case SerializePropertyType.Bool:
                ret = data.ReadBool(arrayLength);
                break;
                case SerializePropertyType.Byte:
                ret = data.ReadBytes(arrayLength);
                break;
                case SerializePropertyType.Double:
                ret = data.ReadDouble(arrayLength);
                break;
                case SerializePropertyType.Float:
                ret = data.ReadFloat(arrayLength);
                break;
                case SerializePropertyType.Int:
                ret = data.ReadInt32(arrayLength);
                break;
                case SerializePropertyType.Long:
                ret = data.ReadInt64(arrayLength);
                break;
                case SerializePropertyType.SByte:
                ret = data.ReadSbytes(arrayLength);
                break;
                case SerializePropertyType.Short:
                ret = data.ReadInt16(arrayLength);
                break;
                case SerializePropertyType.String:
                ret = data.ReadStringNullArray(arrayLength);
                break;
                case SerializePropertyType.UInt:
                ret = data.ReadUint32(arrayLength);
                break;
                case SerializePropertyType.ULong:
                ret = data.ReadUInt64(arrayLength);
                break;
                case SerializePropertyType.UShort:
                ret = data.ReadUInt16(arrayLength);
                break;
                default:
                SerializeProperty[] properArray = new SerializeProperty[arrayLength];
                for (int i = 0; i < arrayLength; i++) {
                    SerializeProperty value = null;
                    if (arrayElementType == SerializePropertyType.Property || arrayElementType == SerializePropertyType.Array) {
                        var sp = new SerializeProperty(elementType);
                        sp.DeSerialize(data);
                        value = sp;
                    }
                    properArray[i] = value;
                }
                ret = properArray;
                break;
            }

            data.Align(4);
            return ret;
        }

        public override void DeSerialize(DataReader data)
        {
            propertyType = typeStr2PropertyType(mType.type);
            if (propertyType == SerializePropertyType.Property) {
                var children = mType.GetChildren();
                foreach (var child in children) {
                    SerializeProperty childProperty = new SerializeProperty(child);
                    childProperty.DeSerialize(data);
                    this.AddChild(childProperty);
                }
            } else if (propertyType == SerializePropertyType.Array) {
                value = readArrayValue(mType,data);
            } else {
                value = readValue(propertyType,mType, data);
            }

        }

        public override string ToString()
        {
            string finalStr = "";
            string tabStr = "";
            var it = mType.parent;
            while (it != null) {
                tabStr += "   ";
                it = it.parent;
            }

            finalStr = mType.type + " " + Name;
            if (propertyType != SerializePropertyType.Property) {
                if (propertyType == SerializePropertyType.Array) {
                    var array = value as Array;
                    finalStr += " Size:" + array.Length + "\n" + tabStr + "[\n";
                    int index = 0;
                    if (value is byte[]) {
                        finalStr += tabStr + "    ByteArray\n";
                    } else {
                        foreach (var obj in array) {
                            finalStr += tabStr + "    [" + index++ + "]" + obj.ToString() + tabStr + "    " + ",\n";
                        }
                    }
                  
                    finalStr += tabStr + "]\n";
                } else {
                    finalStr += ":" + value.ToString() + "\n";
                }
                
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
    }
}
