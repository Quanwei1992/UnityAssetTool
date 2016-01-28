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

        public override void Deserialize(SerializeProperty rootProperty)
        {
            m_Name = (string)rootProperty.FindChild("m_Name").Value;
        }
    }
}
