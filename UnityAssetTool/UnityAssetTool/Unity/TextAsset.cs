using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UnityAssetTool.Unity
{
    public class TextAsset : NamedObject
    {
        string m_Script;
        string m_PathName;
        public override void Deserialize(SerializeProperty rootProperty)
        {
            base.Deserialize(rootProperty);
            m_Script = (string)rootProperty.FindChild("m_Script").Value;
            m_PathName = (string)rootProperty.FindChild("m_PathName").Value;
        }
    }
}
