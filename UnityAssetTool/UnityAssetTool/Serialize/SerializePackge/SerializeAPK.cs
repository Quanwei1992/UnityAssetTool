using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ICSharpCode.SharpZipLib.Zip;

namespace UnityAssetTool
{
    public class SerializeAPK
    {
        public void DeSerialize(string packgePath)
        {
            ZipFile zipFile = null;
            try {
                zipFile = new ZipFile(packgePath);
            } catch {
                Debug.LogError("Cant't uncomress file "+packgePath);
                return;
            }

            var mainDataEntry = zipFile.GetEntry("assets/bin/Data/mainData");
            if (mainDataEntry == null) {
                Debug.LogError("Cant't uncomress file " + packgePath);
            }
            var mainDataStream = zipFile.GetInputStream(mainDataEntry);
            int version = AssetToolUtility.GetAssetsFileVersion(mainDataStream);
            Debug.Log("MainDataVersion:" + version);

        }
    }
}
