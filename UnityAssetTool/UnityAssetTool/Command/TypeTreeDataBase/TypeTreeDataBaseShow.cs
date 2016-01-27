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
    using Properties;
    public class TypeTreeDataBaseShow : Command
    {
        [Option('v',"version",HelpText ="TypeVersion",Required = false,DefaultValue =-1)]
        public int version { get; set;}
        [Option('c', "classID", HelpText = "TypeVersion", Required = false, DefaultValue = -1)]
        public int classID {get;set;}

        public override void run()
        {
            
            TypeTreeDataBase typeTreeDatabase = AssetToolUtility.LoadTypeTreeDataBase(Resources.TypeTreeDataBasePath);
            var allVertions = typeTreeDatabase.GetAllVersion();
            if (version != -1) {
                if (classID != -1) {
                    if (typeTreeDatabase.Contains(version, classID)) {
                        var typeTree = typeTreeDatabase.GetType(version, classID);
                        Console.WriteLine("Version:{0},ClassID:{1},Type:{2}:\n{3}", version, classID, typeTree.type, typeTree);
                    } else {
                        Console.WriteLine("No Found TypeTree.");
                    }
                } else {
                    var allTypes = typeTreeDatabase.GetAllType(version);
                    Console.WriteLine("Version:{0} has {1}  typetree {2}", version, allVertions.Length, classID);
                    foreach (var kvr in allTypes) {
                        Console.WriteLine("Version:{0},ClassID:{1},Type:{2}:\n{3}", version, kvr.Key, kvr.Value.type, kvr.Value);
                    }

                }
            } else {
                if (classID != -1) {
                    foreach (var version in allVertions) {
                        if (typeTreeDatabase.Contains(version, classID)) {
                            var typeTree = typeTreeDatabase.GetType(version, classID);
                            Console.WriteLine("Version:{0},ClassID:{1},Type:{2}:\n{3}", version, classID, typeTree.type, typeTree);
                        }
                    }
                } else {
                    foreach (var version in allVertions) {
                        var allTypes = typeTreeDatabase.GetAllType(version);
                        Console.WriteLine("Version:{0} has {1}  typetree", version, allVertions.Length);
                        foreach (var kvr in allTypes) {
                            Console.WriteLine("Version:{0},ClassID:{1},Type:{2}:\n{3}", version, kvr.Key, kvr.Value.type, kvr.Value);
                        }
                    }
                }
            }
        }
    }
}
