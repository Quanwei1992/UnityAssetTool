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
    public class UnityAssetTools
    {
        [VerbOption("ttdb-learn", HelpText = "learn typetree form asset bundle or asset file.")]
        public TypeTreeDataBaseLearn TypeTreeDatabase_Learn { get; set; }

        [VerbOption("ttdb-show",HelpText ="show typetree info")]
        public TypeTreeDataBaseShow TypeTreeDatabase_show { get; set; }

        [VerbOption("asset-unpack",HelpText ="extract asset objects.")]
        public AssetUnpackCommand asset_unpack { get; set; }

        [VerbOption("asset-sizeinfo", HelpText = "display assets size info.")]
        public AssetSizeInfoCommand asset_sizeinfo { get; set; }

        public void Run(string[] args)
        {
            Parser.Default.ParseArguments(args, this, (cmdName, cmdIns) => {
                if (cmdIns != null) {
                    Command cmd = cmdIns as Command;
                    if (cmd != null) {
                        cmd.run();
                    }
                }
            });
        }
    }
}
