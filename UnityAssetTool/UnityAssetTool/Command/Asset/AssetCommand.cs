using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace UnityAssetTool.Command
{
    public class AssetCommand : RecursiveFileCommand
    {
        public override void runFileRecursive(string path)
        {
            try {
                int version = SerializeUtility.GetAssetsFileVersion(path);
                var serializeAssets = SerializeAssetFactory.CreateWithVersion(version);
                if (serializeAssets == null) {
                    Console.WriteLine("Can't deserialize asset file {0}.Version:{1}", path,version);
                    return;
                }

                FileStream fs = new FileStream(path, FileMode.Open, FileAccess.Read);
                DataReader data = new DataReader(fs);
                serializeAssets.DeSerialize(data);
                if (serializeAssets != null) {
                    runAssetFile(serializeAssets);
                }
            }
            catch
            {
                Console.WriteLine("Can't open asset file {0}.", path);
            }
        }

        public virtual void runAssetFile(SerializeDataStruct asset)
        {

        }
    }
}
