using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace FileFormatTest
{



    public static class SerializeAssetFactory
    {

        public static SerializeDataStruct CreateWithVersion(int version)
        {
            switch (version) {
                case 9:
                return new SerializeAssetV09();
                case 15:
                return new SerializeAssetV15();
                default:
                return null;
            }

        }


        
    }
}
