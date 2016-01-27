using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UnityAssetTool.Unity
{
    public class NamedObject : BaseObject
    {
        public string m_Name;
        public NamedObject(SerializeObject obj) : base(obj)
        {
            m_Name = (string)obj.FindProperty("m_Name").Value;
        }
    }
}
