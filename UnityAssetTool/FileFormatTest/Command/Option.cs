using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CommandLine.Text;
using CommandLine;
using CommandLine.Parsing;
namespace UnityAssetTool.Command
{
    public class Options
    {
        public string commandName { get; set; }
        public int MaxDepth;
    }
}
