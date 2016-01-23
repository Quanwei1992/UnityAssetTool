using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UnityAssetTool
{
    interface IAssetsExtrator
    {
        void Extract(SerializeDataStruct assets,TypeTreeDataBase typeTreeDB,string outputPath);
        ISerializeObjectExtrator GetDefaultSerializeObjectExtrator();
    }
}
