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
        [Option('m',"mode",HelpText ="Extract Mode 0:Auto,1:OnlyRawBits,2:OnlyRawText,3:RawBitsOrRawText",Required =false,DefaultValue = 0)]
        public int mode { get; set; }

        TypeTreeDataBase typeTreeDatabase;
        AssetExtrator extrator;
        public override void run()
        {
            extrator = new AssetExtrator();
            typeTreeDatabase = AssetToolUtility.LoadTypeTreeDataBase(Resources.TypeTreeDataBasePath);
            base.run();
            AssetToolUtility.SaveTypeTreeDataBase(Resources.TypeTreeDataBasePath, typeTreeDatabase);
        }
        public override void runAssetFile(Asset asset)
        {
            if (string.IsNullOrEmpty(OutputDir)) {
                OutputDir = Directory.GetCurrentDirectory()+"/extractObjects/";
            }
            //try {
                var assetDB = asset.TypeTreeDatabase;
            typeTreeDatabase = typeTreeDatabase.Merage(assetDB);
            var extractMode = AssetExtrator.ExtractMode.Auto;
            if (mode == 1) {
                extractMode = AssetExtrator.ExtractMode.OnlyRawBits;
            } else if (mode == 2) {
                extractMode = AssetExtrator.ExtractMode.OnlyRawText;
            } else if (mode == 3) {
                extractMode = AssetExtrator.ExtractMode.RawTextOrRawBits;
            }
            extrator.Extract(asset, typeTreeDatabase, OutputDir,extractMode);
            //} catch {
            //    Console.WriteLine("Can't extract asset {0}.",asset.GetType());
            //}
        }
    }
}
