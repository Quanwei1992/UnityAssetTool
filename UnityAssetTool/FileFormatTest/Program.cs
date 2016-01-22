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

            FileStream fs = new FileStream("unityasset/typeTree.assetbundle", FileMode.Open, FileAccess.Read);
            DataReader br = new DataReader(fs);

            SerializeBundle bundle = new SerializeBundle();
            bundle.UnSerialize(br);
            //TypeTreeDataBase typeDataBase = new TypeTreeDataBase();
            //FileStream dbFs = new FileStream("d://TypeTreeDB.db", FileMode.Open, FileAccess.Read);
            //typeDataBase.UnSerialize(dbFs);
            //dbFs.Dispose();

            foreach (var bundleEntry in bundle.entrys) {
                int version = SerializeUtility.GetAssetsFileVersion(bundleEntry.assetData);
                Console.WriteLine("Name:" + bundleEntry.name + ",Version:" + version);
                var serializeAssets = SerializeAssetFactory.CreateWithVersion(version);
                MemoryStream ms = new MemoryStream(bundleEntry.assetData);
                DataReader dr = new DataReader(ms);
                serializeAssets.UnSerialize(dr);
                var asset15 = serializeAssets as SerializeAssetV15;
                var db = SerializeUtility.GenerateTypeTreeDataBase(asset15);
                foreach (var objInfo in asset15.objectInfos) {
                    var typeTree = db.GetType(15, objInfo.classID);
                    if (typeTree != null) {
                        SerializeObject sobj = new SerializeObject(typeTree, objInfo.data);
                    } else {
                        Console.WriteLine("未找到Type:" + objInfo.classID);
                    }
                }
                dr.Close();
                ms.Close();
            }


            //br.Close();
            //fs.Close();
            Console.Read();

            
        }
    }
}
