using System;
using System.IO;
using CommandLine;
using CommandLine.Parsing;
using CommandLine.Text;
using UnityAssetTool.Command;
using System.IO.Compression;
using ICSharpCode.SharpZipLib.Zip;
namespace UnityAssetTool
{
    class Program
    {

        static void Main(string[] args)
        {
            UnityAssetTools tools = new UnityAssetTools();
            tools.Run(args);
            Console.Write("Please enter any key to contiue..");
            Console.Read();
        }
    }
}
