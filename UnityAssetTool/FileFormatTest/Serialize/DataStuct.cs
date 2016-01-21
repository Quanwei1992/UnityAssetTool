using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FileFormatTest
{
    public class SerializeDataStruct
    {
        public virtual void UnSerialize(DataReader data) { }
        public override string ToString()
        {
            string str = GetType().Name + ":\n{\n";
            var fields = GetType().GetFields();
            foreach (var field in fields) {
                object value = field.GetValue(this);
                string fieldValueStr = "";
                if (value != null) {
                    if (value is Array) {
                        var array =  (Array)value;
                        fieldValueStr += "[";
                        int i = 0;
                        foreach (var obj in array) {
                            fieldValueStr += obj.ToString() + ",";
                            if (i++ >= 100) {
                                fieldValueStr += "    ...";
                                break;
                            }
                        }
                        fieldValueStr += "]\n";
                    } else {
                        fieldValueStr = field.GetValue(this).ToString();
                    }
                } else {
                    fieldValueStr = "NULL";
                }
                str +="    "+ field.Name + ":" + fieldValueStr + "\n";
            }
            str += "}\n";
            return str;
        }

    }
}
