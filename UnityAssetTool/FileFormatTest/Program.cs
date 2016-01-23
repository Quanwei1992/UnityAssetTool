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
            //LearnTypeTree();
            //AssetUnserializeTest();
            //AssetBundleExtractTest();
            AssetExtractTest();
            Console.WriteLine("Done\nPlease Enter Any Key Contiue..");
            Console.Read();
        }




   


        private static void LearnTypeTree()
        {

            FileStream ttDataBaseFs = new FileStream("res/TypeTyeeDataBase.db",FileMode.OpenOrCreate,FileAccess.ReadWrite);
            TypeTreeDataBase db = new TypeTreeDataBase();
            db.DeSerialize(ttDataBaseFs);

            FileStream fs = new FileStream("D:/typeTree.assetbundle", FileMode.Open, FileAccess.Read);
            DataReader br = new DataReader(fs);
            SerializeBundle bundle = new SerializeBundle();
            bundle.DeSerialize(br);
            foreach (var bundleEntry in bundle.entrys) {
                int version = SerializeUtility.GetAssetsFileVersion(bundleEntry.assetData);
                Console.WriteLine("Name:" + bundleEntry.name + ",Version:" + version);
                var serializeAssets = SerializeAssetFactory.CreateWithVersion(version);
                MemoryStream ms = new MemoryStream(bundleEntry.assetData);
                DataReader dr = new DataReader(ms);
                serializeAssets.DeSerialize(dr);
                var assetTypeTreeDB = SerializeUtility.GenerateTypeTreeDataBase(serializeAssets);
                db = assetTypeTreeDB.Merage(db);
                dr.Close();
                ms.Close();
            }

            db.Serialize(ttDataBaseFs);
            ttDataBaseFs.Flush();
            ttDataBaseFs.Dispose();
        }

        private static void AssetUnserializeTest()
        {
            FileStream fs = new FileStream("unityasset/v9.assets", FileMode.Open, FileAccess.Read);
            DataReader br = new DataReader(fs);
            int version = SerializeUtility.GetAssetsFileVersion("unityasset/v9.assets");
            Console.WriteLine("version:" + version);
            var serializeAssets = SerializeAssetFactory.CreateWithVersion(version);
            if (serializeAssets != null) {
                serializeAssets.DeSerialize(br);
                Console.WriteLine(serializeAssets);
            }
        }

        private static void AssetExtractTest()
        {
            var db = SerializeUtility.LoadTypeTreeDataBase("res/TypeTyeeDataBase.db");
            AssetsExtrator extartor = new AssetsExtrator();
            FileStream fs = new FileStream("unityasset/v9.assets", FileMode.Open, FileAccess.Read);
            DataReader br = new DataReader(fs);
            int version = SerializeUtility.GetAssetsFileVersion("unityasset/v9.assets");
            var serializeAssets = SerializeAssetFactory.CreateWithVersion(version);
            if (serializeAssets != null) {
                serializeAssets.DeSerialize(br);
                var assetTypeDB = SerializeUtility.GenerateTypeTreeDataBase(serializeAssets);
                db = assetTypeDB.Merage(db);
                extartor.Extract(serializeAssets, db, "d://extract/V9/");
            }
            br.Close();
            fs.Dispose();
            SerializeUtility.SaveTypeTreeDataBase("res/TypeTyeeDataBase.db", db);
        }

        private static void AssetBundleExtractTest()
        {
            FileStream fs = new FileStream("D:/typeTree.assetbundle", FileMode.Open, FileAccess.Read);
            DataReader br = new DataReader(fs);

            SerializeBundle bundle = new SerializeBundle();
            bundle.DeSerialize(br);
            AssetsExtrator extartor = new AssetsExtrator();
            foreach (var bundleEntry in bundle.entrys) {
                int version = SerializeUtility.GetAssetsFileVersion(bundleEntry.assetData);
                Console.WriteLine("Name:" + bundleEntry.name + ",Version:" + version);
                var serializeAssets = SerializeAssetFactory.CreateWithVersion(version);
                MemoryStream ms = new MemoryStream(bundleEntry.assetData);
                DataReader dr = new DataReader(ms);
                serializeAssets.DeSerialize(dr);
                var db = SerializeUtility.GenerateTypeTreeDataBase(serializeAssets);
                extartor.Extract(serializeAssets, db, "d://extract/");
                dr.Close();
                ms.Close();
            }

        }
    }
}
