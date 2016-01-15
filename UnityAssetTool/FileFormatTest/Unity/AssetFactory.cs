using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace FileFormatTest
{



    public static class AssetFactory
    {

        public static DataStuct CreateWithVersion(int version)
        {
            switch (version) {
                case 9:
                return new Asset_V9();
                case 15:
                return new Asset_V15();
                default:
                return null;
            }

        }


        
    }
}
