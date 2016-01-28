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
        public override void Deserialize(SerializeObject obj)
        {
            base.Deserialize(obj);
            m_Script = (string)obj.FindProperty("m_Script").Value;
            m_PathName = (string)obj.FindProperty("m_PathName").Value;
        }
    }
}
