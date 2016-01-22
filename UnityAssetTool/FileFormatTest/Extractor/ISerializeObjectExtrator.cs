using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FileFormatTest
{
    public interface ISerializeObjectExtrator
    {
        void Extract(SerializeObject obj, string outputPath);
    }
}
