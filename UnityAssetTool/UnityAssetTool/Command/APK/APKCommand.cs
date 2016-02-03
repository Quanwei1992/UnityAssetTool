using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UnityAssetTool.Command
{
    public class APKCommand : RecursiveFileCommand
    {
        public override void runFileRecursive(string path)
        {
            SerializeAPK apk = new SerializeAPK();
            if (apk.DeSerialize(path)) {
                runApk(apk);
            }
        }

        public virtual void runApk(SerializeAPK apk)
        {

        }
    }
}
