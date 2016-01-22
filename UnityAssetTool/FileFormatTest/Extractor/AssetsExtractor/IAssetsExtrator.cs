using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FileFormatTest
{
    interface IAssetsExtrator
    {
        void Extract(SerializeDataStruct assets,TypeTreeDataBase typeTreeDB,string outputPath);
    }
}
