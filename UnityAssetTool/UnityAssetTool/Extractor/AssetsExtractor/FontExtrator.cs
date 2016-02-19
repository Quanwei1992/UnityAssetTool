using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using UnityAssetTool.Unity;

namespace UnityAssetTool.Extractor
{
    public class FontExtrator : ISerializeObjectExtrator
    {
        public void Extract(SerializeObject obj, string outputPath)
        {
            Font font = new Font();
            font.Deserialize(obj.RootProperty);
            string name = font.name;
            outputPath = outputPath + "/" + name + ".ttf";
            outputPath = AssetToolUtility.FixOuputPath(outputPath);
            if (!Directory.Exists(Path.GetDirectoryName(outputPath))) {
                Directory.CreateDirectory(Path.GetDirectoryName(outputPath));
            }
            File.WriteAllBytes(outputPath, font.FontData);
        }
    }
}
