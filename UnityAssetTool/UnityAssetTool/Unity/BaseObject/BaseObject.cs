using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UnityAssetTool.Unity
{
    public class BaseObject
    {
        protected SerializeObject mSerializeObj;
        public BaseObject(SerializeObject obj)
        {
            mSerializeObj = obj;
        }
    }
}
