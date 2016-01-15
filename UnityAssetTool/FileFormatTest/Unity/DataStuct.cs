using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FileFormatTest
{
    public class DataStuct
    {
        public virtual void Read(DataReader br) { }

        public override string ToString()
        {
            string str = GetType().Name + ":\n{\n";
            var fields = GetType().GetFields();
            foreach (var field in fields) {
                str +="    "+ field.Name + ":" + field.GetValue(this) + "\n";
            }
            str += "}\n";
            return str;
        }

    }
}
