using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace UnityAssetTool
{
    public class SerializeObject
    {
        public SerializeProperty RootProperty { get; private set; }


        public SerializeObject(TypeTree type, byte[] rawData)
        {
            RootProperty = new SerializeProperty(type);
            MemoryStream ms = new MemoryStream(rawData);
            DataReader br = new DataReader(ms);
            RootProperty.DeSerialize(br);
            br.Close();
            ms.Close();
        }

        public SerializeObject(TypeTree type, DataReader data)
        {
            RootProperty = new SerializeProperty(type);
            RootProperty.DeSerialize(data);
        }

        public SerializeProperty FindProperty(string fullName)
        {
            if (RootProperty != null) {
                return RootProperty.FindChild("Base." + fullName);
            }
            return null;
           
        }

        public override string ToString()
        {
            return RootProperty.ToString();
        }
    }
}
