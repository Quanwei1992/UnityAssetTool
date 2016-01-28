using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UnityAssetTool.Unity
{
    public abstract class BaseObject : ISerialize
    {
        public abstract void Deserialize(SerializeObject obj);
    }
}
