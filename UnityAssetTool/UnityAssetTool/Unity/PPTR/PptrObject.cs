using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UnityAssetTool.Unity
{
    public class PptrObject : BaseObject
    {
        private int m_FileID;
        private ulong m_PathID;

        public int FileID
        {
            get
            {
                return m_FileID;
            }
            set
            {
                m_FileID = value;
            }
        }

        public ulong PathID
        {
            get
            {
                return m_PathID;
            }
            set
            {
                m_PathID = value;
            }
        }

        public override void Deserialize(SerializeProperty rootProperty)
        {
            m_FileID = (int)rootProperty.FindChild("m_FileID").Value;
            var pathID = rootProperty.FindChild("m_PathID");
            if (pathID.propertyType == SerializePropertyType.Int) {
                m_PathID = (ulong)((int)pathID.Value);
            } else if(pathID.propertyType == SerializePropertyType.ULong) {
                m_PathID =(ulong)pathID.Value;
            }

        }
    }
}
