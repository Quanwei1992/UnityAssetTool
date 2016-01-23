using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using System.Xml.Serialization;
namespace FileFormatTest
{
    class Program
    {
        static void Main(string[] args)
        {
            LearnTypeTree();
            //AssetUnserializeTest();
            Console.Read();
        }




        private static void LearnTypeTree()
        {

            FileStream ttDataBaseFs = new FileStream("res/TypeTyeeDataBase.db",FileMode.OpenOrCreate,FileAccess.ReadWrite);
            TypeTreeDataBase db = new TypeTreeDataBase();
            db.UnSerialize(ttDataBaseFs);

            FileStream fs = new FileStream("D:/typeTree.assetbundle", FileMode.Open, FileAccess.Read);
            DataReader br = new DataReader(fs);
            SerializeBundle bundle = new SerializeBundle();
            bundle.UnSerialize(br);
            foreach (var bundleEntry in bundle.entrys) {
                int version = SerializeUtility.GetAssetsFileVersion(bundleEntry.assetData);
                Console.WriteLine("Name:" + bundleEntry.name + ",Version:" + version);
                var serializeAssets = SerializeAssetFactory.CreateWithVersion(version);
                MemoryStream ms = new MemoryStream(bundleEntry.assetData);
                DataReader dr = new DataReader(ms);
                serializeAssets.UnSerialize(dr);
                var assetTypeTreeDB = SerializeUtility.GenerateTypeTreeDataBase(serializeAssets);
                dr.Close();
                ms.Close();
            }
        }

        private static void AssetUnserializeTest()
        {
            FileStream fs = new FileStream("unityasset/v9.assets", FileMode.Open, FileAccess.Read);
            DataReader br = new DataReader(fs);
            int version = SerializeUtility.GetAssetsFileVersion("unityasset/v9.assets");
            Console.WriteLine("version:" + version);
            var serializeAssets = SerializeAssetFactory.CreateWithVersion(version);
            if (serializeAssets != null) {
                serializeAssets.UnSerialize(br);
                Console.WriteLine(serializeAssets);
            }
        }


        private void AssetBundleExtractTest()
        {
            FileStream fs = new FileStream("unityasset/typeTree.assetbundle", FileMode.Open, FileAccess.Read);
            DataReader br = new DataReader(fs);

            SerializeBundle bundle = new SerializeBundle();
            bundle.UnSerialize(br);
            AssetsV15Extrator extartor = new AssetsV15Extrator();
            foreach (var bundleEntry in bundle.entrys) {
                int version = SerializeUtility.GetAssetsFileVersion(bundleEntry.assetData);
                Console.WriteLine("Name:" + bundleEntry.name + ",Version:" + version);
                var serializeAssets = SerializeAssetFactory.CreateWithVersion(version);
                MemoryStream ms = new MemoryStream(bundleEntry.assetData);
                DataReader dr = new DataReader(ms);
                serializeAssets.UnSerialize(dr);
                var asset15 = serializeAssets as SerializeAssetV15;
                var db = SerializeUtility.GenerateTypeTreeDataBase(asset15);
                extartor.Extract(asset15, db, "d://extract/");
                dr.Close();
                ms.Close();
            }

        }
    }
}
