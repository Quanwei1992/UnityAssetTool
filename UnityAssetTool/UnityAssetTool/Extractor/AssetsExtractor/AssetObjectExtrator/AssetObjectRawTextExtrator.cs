using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace UnityAssetTool
{
    public class AssetObjectRawTextExtrator : ISerializeObjectExtrator
    {
        static int gID = 0;
        public void Extract(SerializeObject obj, string outputPath)
        {
            var nameProperty = obj.FindProperty("Base.m_Name");
            string name = "";
            if (nameProperty != null) {
                name = nameProperty.Value as string;
            }
            if (string.IsNullOrEmpty(name)) {
                name = (gID++).ToString();
            }
            outputPath += "/" + name + ".txt";
            string content = obj.ToString();
            if (!Directory.Exists(Path.GetDirectoryName(outputPath))) {
                Directory.CreateDirectory(Path.GetDirectoryName(outputPath));
            }
            var bytes = System.Text.Encoding.Unicode.GetBytes(content);
            var fs = new FileStream(outputPath, FileMode.OpenOrCreate, FileAccess.Write);
            fs.Write(bytes, 0, bytes.Length);
            fs.Flush();
            fs.Dispose();
        }
    }

}
