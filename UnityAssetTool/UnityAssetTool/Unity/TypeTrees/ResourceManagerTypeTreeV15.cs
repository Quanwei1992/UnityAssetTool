using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UnityAssetTool.Unity.TypeTrees
{
    public class ResourceManagerTypeTreeV15 : TypeTree
    {
        public ResourceManagerTypeTreeV15()
        {
            this.name = "Base";
            this.type = "ResourceManager";
            var map = new TypeTree();
            map.name = "m_Container";
            map.type = "map";

            var array = new TypeTree();
            array.name = "Array";
            array.type = "Array";

            var arraySize = new TypeTree();
            arraySize.name = "size";
            arraySize.type = "int";
            array.AddChild(arraySize);

            var arrayData = new TypeTree();
            arrayData.name = "data";
            arrayData.type = "pair";

            var arrayDataPairKey = new TypeTree();
            arrayDataPairKey.name = "path";
            arrayDataPairKey.type = "string";

            arrayData.AddChild(arrayDataPairKey);

            var arrayDataPairValue = new TypeTree();
            arrayDataPairValue.name = "asset";
            arrayDataPairValue.type = "PPtr<Object>";

            var objectFileIdentInType = new TypeTree();
            objectFileIdentInType.name = "m_FileID";
            objectFileIdentInType.type = "int";

            arrayDataPairValue.AddChild(objectFileIdentInType);

            var objectUnkowFiled = new TypeTree();
            objectUnkowFiled.name = "m_PathID";
            objectUnkowFiled.type = "SInt64";

            arrayDataPairValue.AddChild(objectUnkowFiled);
            arrayData.AddChild(arrayDataPairValue);

            array.AddChild(arrayData);
            map.AddChild(array);

            AddChild(map);
        }
    }
}
