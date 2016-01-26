using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using CommandLine;
using CommandLine.Parsing;
using CommandLine.Text;
namespace UnityAssetTool.Command
{
    public class AssetCommand : RecursiveFileCommand
    {

        List<string> assetFiles = new List<string>();

        public override void run()
        {
            assetFiles.Clear();
            base.run();
            handelAssetFilePaths();
        }

        private void handelAssetFilePaths()
        {
            foreach (var path in assetFiles) {
                Console.WriteLine("Handel Asset:" + path);
               // try {
                    DeserializeAsset(path);
               // } catch {
               //     Console.WriteLine("Can't open asset file {0}.", path);
               // }
            }
        }


        private void DeserializeAsset(string path)
        {
            
            MemoryStream assetms = new MemoryStream();
            BinaryWriter bw = new BinaryWriter(assetms);
            string fileExt = Path.GetExtension(path);
            //处理Split文件
            if (fileExt.StartsWith(".split")) {
                string fileDir = Path.GetDirectoryName(path);
                string fileName = Path.GetFileNameWithoutExtension(path);
                int splitIndex = 0;
                while (true) {
                    string splitFilePath = fileDir + "/" + fileName + ".split" + splitIndex.ToString();
                    splitIndex++;
                    if (!File.Exists(splitFilePath)) {
                        break;
                    }

                    FileStream splitfs = new FileStream(splitFilePath, FileMode.Open, FileAccess.Read);
                    BinaryReader splitbr = new BinaryReader(splitfs);
                    bw.Write(splitbr.ReadBytes((int)splitbr.BaseStream.Length));
                    splitbr.Close();
                    splitfs.Dispose();
                }

            } else {
                //处理单文件
                FileStream assetfs = new FileStream(path, FileMode.Open, FileAccess.Read);
                BinaryReader assetbr = new BinaryReader(assetfs);
                bw.Write(assetbr.ReadBytes((int)assetbr.BaseStream.Length));
                assetbr.Close();
                assetfs.Dispose();
            }
            assetms.Position = 0;
            int version = SerializeUtility.GetAssetsFileVersion(assetms);
            var serializeAssets = SerializeAssetFactory.CreateWithVersion(version);
            if (serializeAssets == null) {
                assetms.Dispose();
                Console.WriteLine("Can't deserialize asset file {0}.Version:{1}", path, version);
                return;
            }
            DataReader data = new DataReader(assetms);
            serializeAssets.DeSerialize(data);
            if (serializeAssets != null) {
                var asset = new Asset(serializeAssets);
                runAssetFile(asset);
            }
            assetms.Dispose();
        }

        public override void runFileRecursive(string path)
        {

            string fileExt = Path.GetExtension(path);
            if (fileExt.StartsWith(".split")) {
                string fileDir = Path.GetDirectoryName(path);
                string fileName = Path.GetFileNameWithoutExtension(path);
                if (!assetFiles.Contains(fileDir + "\\" + fileName+".split")) {
                    assetFiles.Add(fileDir + "\\" + fileName + ".split");
                }
            } else {
                if (!assetFiles.Contains(path)) {
                    assetFiles.Add(path);
                }
            }
        }

        public virtual void runAssetFile(Asset asset)
        {

        }
    }
}
