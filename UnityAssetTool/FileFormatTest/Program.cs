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
         
            //FileStream fs = new FileStream("unityasset/typeTree.assetbundle", FileMode.Open,FileAccess.Read);
            //DataReader br = new DataReader(fs);

            ////AssetHeader header = new AssetHeader();
            ////header.Read(br);
            ////Console.WriteLine(header);
            ////var asset = AssetFactory.CreateWithVersion(header.Version);
            ////if (asset != null) {
            ////    asset.Read(br);
            ////    Console.WriteLine(asset);

            ////} else {
            ////    Console.WriteLine("尚未支持的AssetVersion:" + header.Version);
            ////}

            //SerializeBundle bundle  = new SerializeBundle();
            //bundle.UnSerialize(br);
            //Console.WriteLine(bundle);
            //TypeTreeDataBase typeDataBase = new TypeTreeDataBase();
            //foreach (var bundleEntry in bundle.entrys) {
            //    int version = SerializeUtility.GetAssetsFileVersion(bundleEntry.assetData);
            //    Console.WriteLine("Name:" + bundleEntry.name + ",Version:" + version);
            //    var serializeAssets = SerializeAssetFactory.CreateWithVersion(version);
            //    MemoryStream ms = new MemoryStream(bundleEntry.assetData);
            //    DataReader dr = new DataReader(ms);
            //    serializeAssets.UnSerialize(dr);
            //    var db = SerializeUtility.GenerateTypeTreeDataBase(serializeAssets);
            //    if (db != null) {
            //        typeDataBase = typeDataBase.Merage(db);
            //    }
            //    dr.Close();
            //    ms.Close();
            //}

            //Stream dbFS = new FileStream("d://TypeTreeDB.db", FileMode.OpenOrCreate, FileAccess.Write);
            //typeDataBase.Serialize(dbFS);
            //dbFS.Flush();
            //dbFS.Dispose();

           



            //br.Close();
            //fs.Close();
            Console.Read();

            
        }
    }
}
