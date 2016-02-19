using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using UnityAssetTool.Unity;

namespace UnityAssetTool.Extractor
{
    public class TextAssetExtrator : ISerializeObjectExtrator
    {
        public void Extract(SerializeObject obj, string outputPath)
        {
            TextAsset textAsset = new TextAsset();
            textAsset.Deserialize(obj.RootProperty);
            string name = textAsset.name;
            string script = "";
            outputPath = outputPath + "/" + name + ".txt";
            outputPath = AssetToolUtility.FixOuputPath(outputPath);
            if (!Directory.Exists(Path.GetDirectoryName(outputPath))) {
                Directory.CreateDirectory(Path.GetDirectoryName(outputPath));
            }
            var bytes = System.Text.Encoding.Unicode.GetBytes(script);
            var fs = new FileStream(outputPath, FileMode.OpenOrCreate, FileAccess.Write);
            fs.Write(bytes, 0, bytes.Length);
            fs.Flush();
            fs.Dispose();
        }
    }
}
