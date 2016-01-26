using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UnityAssetTool.Command
{

    using CommandLine;
    using CommandLine.Parsing;
    using CommandLine.Text;

    public class FileCommand : Command
    {
        [ValueList(typeof(List<string>))]
        public IList<string> FilePaths { get; set; }
        public override void run()
        {
            foreach (var filePath in FilePaths) {
                runFile(filePath);
            }
        }
        [HelpOption]
        public string GetUsage()
        {
            return HelpText.AutoBuild(this, current => HelpText.DefaultParsingErrorsHandler(this, current));
        }
        public virtual void runFile(string path) { }
    }
}
