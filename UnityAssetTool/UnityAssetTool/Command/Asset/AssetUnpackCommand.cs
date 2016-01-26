using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace UnityAssetTool.Command
{
    using CommandLine;
    using CommandLine.Parsing;
    using CommandLine.Text;
    using Properties;
    public class AssetUnpackCommand : AssetCommand
    {
        [Option('o',"output",HelpText="Output Directory.",Required = false,DefaultValue = null)]
        public string OutputDir { get; set; }
        TypeTreeDataBase typeTreeDatabase;
        AssetExtrator extrator;
        public override void run()
        {
            extrator = new AssetExtrator();
            typeTreeDatabase = SerializeUtility.LoadTypeTreeDataBase(Resources.TypeTreeDataBasePath);
            base.run();
            SerializeUtility.SaveTypeTreeDataBase(Resources.TypeTreeDataBasePath, typeTreeDatabase);
        }
        public override void runAssetFile(Asset asset)
        {
            if (string.IsNullOrEmpty(OutputDir)) {
                OutputDir = Directory.GetCurrentDirectory()+"/extractObjects/";
            }
            //try {
                var assetDB = asset.TypeTreeDatabase;
                typeTreeDatabase = typeTreeDatabase.Merage(assetDB);
                extrator.Extract(asset, typeTreeDatabase, OutputDir);
            //} catch {
            //    Console.WriteLine("Can't extract asset {0}.",asset.GetType());
            //}
        }
    }
}
