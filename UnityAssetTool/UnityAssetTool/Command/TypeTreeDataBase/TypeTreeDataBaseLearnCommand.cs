using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CommandLine;
using CommandLine.Parsing;
using CommandLine.Text;
namespace UnityAssetTool.Command
{
    using Properties;
    using System.IO;
    public class TypeTreeDataBaseLearn : RecursiveFileCommand
    {
        TypeTreeDataBase typeTreeDatabase;
        public override void run()
        {
            typeTreeDatabase = SerializeUtility.LoadTypeTreeDataBase(Resources.TypeTreeDataBasePath);
            base.run();
            SerializeUtility.SaveTypeTreeDataBase(Resources.TypeTreeDataBasePath, typeTreeDatabase);
        }
        public override void runFileRecursive(string path)
        {
            if (SerializeUtility.IsBundle(path)) {
                try {
                    learnFormAssetBundle(path);
                } catch {
                    Console.WriteLine("Can't open asset bundle " + path);
                }
            } else {
                try {
                    learnFormAssetFile(path);
                } catch {
                    Console.WriteLine("Can't open asset file " + path);
                }
            }
        }


        private void learnFormAssetBundle(string path)
        {
            FileStream fs = new FileStream(path, FileMode.Open, FileAccess.Read);
            DataReader br = new DataReader(fs);
            SerializeBundle bundle = new SerializeBundle();
            bundle.DeSerialize(br);
            foreach (var bundleEntry in bundle.entrys) {
                int version = SerializeUtility.GetAssetsFileVersion(bundleEntry.assetData);
                var serializeAssets = SerializeAssetFactory.CreateWithVersion(version);
                MemoryStream ms = new MemoryStream(bundleEntry.assetData);
                DataReader dr = new DataReader(ms);
                serializeAssets.DeSerialize(dr);
                var assetTypeTreeDB = SerializeUtility.GenerateTypeTreeDataBase(serializeAssets);
                if (assetTypeTreeDB != null) {
                    var allType = assetTypeTreeDB.GetAllType(version);
                    foreach (var type in allType) {
                        Console.WriteLine("AddType:Version:{0},ClassID{1},Name:{2}", version, type.Key, type.Value.type);
                    }
                }
                typeTreeDatabase = assetTypeTreeDB.Merage(typeTreeDatabase);
                dr.Close();
                fs.Dispose();
            }
        }

        private void learnFormAssetFile(string path)
        {
            FileStream fs = new FileStream(path, FileMode.Open, FileAccess.Read);
            DataReader dr = new DataReader(fs);
            int version = SerializeUtility.GetAssetsFileVersion(path);
            var serializeAssets = SerializeAssetFactory.CreateWithVersion(version);
            serializeAssets.DeSerialize(dr);
            var assetTypeTreeDB = SerializeUtility.GenerateTypeTreeDataBase(serializeAssets);
            typeTreeDatabase = assetTypeTreeDB.Merage(typeTreeDatabase);
            dr.Close();
            fs.Dispose();

        }
    }
}
