using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UnityAssetTool
{
    public class AssetsExtrator
    {
        Dictionary<Type, IAssetsExtrator> mExtratorDic = new Dictionary<Type, IAssetsExtrator>();
        public AssetsExtrator()
        {
            mExtratorDic[typeof(SerializeAssetV15)] = new AssetsV15Extrator();
            mExtratorDic[typeof(SerializeAssetV09)] = new AssetsV09Extrator();
        }

        public void Extract(SerializeDataStruct assets,TypeTreeDataBase db,string outPutPath)
        {
            var type = assets.GetType();
            if (mExtratorDic.ContainsKey(type)) {
                mExtratorDic[type].Extract(assets, db, outPutPath);
            }
        }
    }
}
