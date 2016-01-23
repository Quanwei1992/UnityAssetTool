using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace FileFormatTest
{
    public class SerializeObject
    {
        private SerializeProperty rootProperty;

        public SerializeObject(TypeTree type, byte[] rawData)
        {
            rootProperty = new SerializeProperty(type);
            MemoryStream ms = new MemoryStream(rawData);
            DataReader br = new DataReader(ms);
            rootProperty.DeSerialize(br);
            br.Close();
            ms.Close();
        }

        public SerializeProperty FindProperty(string fullName)
        {
            return rootProperty.FindChild(fullName);
        }

        public override string ToString()
        {
            return rootProperty.ToString();
        }
    }
}
