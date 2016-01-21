using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
namespace FileFormatTest
{
    class Program
    {
        static void Main(string[] args)
        {

            FileStream fs = new FileStream("unityasset/typeTree.assetbundle", FileMode.Open,FileAccess.Read);
            DataReader br = new DataReader(fs);

            //AssetHeader header = new AssetHeader();
            //header.Read(br);
            //Console.WriteLine(header);
            //var asset = AssetFactory.CreateWithVersion(header.Version);
            //if (asset != null) {
            //    asset.Read(br);
            //    Console.WriteLine(asset);

            //} else {
            //    Console.WriteLine("尚未支持的AssetVersion:" + header.Version);
            //}

            SerializeBundle bundle  = new SerializeBundle();
            bundle.UnSerialize(br);
            Console.WriteLine(bundle);

            br.Close();
            fs.Close();
            Console.Read();
        }
    }
}
