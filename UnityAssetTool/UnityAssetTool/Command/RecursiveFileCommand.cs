using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Threading.Tasks;
using CommandLine;
using CommandLine.Parsing;
using CommandLine.Text;
namespace UnityAssetTool.Command
{
    public class RecursiveFileCommand : FileCommand
    {
        [Option('r', "recursive", DefaultValue = false,HelpText = "Scan directories and sub-directories for files as well.",Required = false)]
        public bool recursive { get; set; }
        [Option('d', "recursive-depth",DefaultValue =1024, HelpText = "The maximum number of directory levels to visit.", Required = false)]
        public int maxDepth { get; set;}

        
        public override void runFile(string path)
        {
            if (!File.Exists(path) && Directory.Exists(path)) {
                //path is a directory
                if (recursive) {
                    var files = doRecursive(path);
                    foreach (var filePath in files) {
                        runFileRecursive(filePath);
                    }
                }
            } else {
                runFileRecursive(path);
            }
        }

        int mCurrentDepth = 0;
        private string[] doRecursive(string path)
        {
            List<string> fileList = new List<string>();
            var files = Directory.GetFiles(path);
            if (files != null && files.Length > 0) {
                fileList.AddRange(files);
            }
            if (mCurrentDepth < maxDepth) {
                mCurrentDepth++;
                var dirs = Directory.GetDirectories(path);
                if (dirs != null) {
                    foreach (var dir in dirs) {
                        var childFiles = doRecursive(dir);
                        if (childFiles != null) {
                            fileList.AddRange(childFiles);
                        }
                    }
                }
                mCurrentDepth--;
            }       
            return fileList.ToArray();
        }

        public virtual void runFileRecursive(string path)
        {

        }

        [HelpOption]
        public string GetUsage()
        {
            return HelpText.AutoBuild(this, current => HelpText.DefaultParsingErrorsHandler(this, current));
        }
    }
}
