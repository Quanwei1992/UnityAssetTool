using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UnityAssetTool.Unity
{
    public class ResourceManager : BaseObject
    {
        Dictionary<string, List<PptrObject>> m_Container = new Dictionary<string, List<PptrObject>>();

        public Dictionary<string, List<PptrObject>> Container
        {
            get
            {
                return m_Container;
            }
            set
            {
                m_Container=value;
            }
        }

        public override void Deserialize(SerializeProperty rootProperty)
        {
            var array = (SerializeProperty[])rootProperty.FindChild("m_Container.Array").Value;
            foreach (var data in array) {
                string path = (string)data.FindChild("path").Value;
                var assetProperty = data.FindChild("asset");
                var asset = new PptrObject();
                asset.Deserialize(assetProperty);
                List<PptrObject> list = null;
                if (!m_Container.TryGetValue(path, out list)) {
                    list = new List<PptrObject>();
                    m_Container[path] = list;
                }
                list.Add(asset);
            }
        }
    }
}
