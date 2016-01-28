using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UnityAssetTool.Unity
{
    public class NamedObject : BaseObject
    {
        string m_Name;
        public string name
        {
            get
            {
                return m_Name;
            }
            set
            {
                m_Name = value;
            }
        }

        public override void Deserialize(SerializeObject obj)
        {
            m_Name = (string)obj.FindProperty("m_Name").Value;
        }
    }
}
