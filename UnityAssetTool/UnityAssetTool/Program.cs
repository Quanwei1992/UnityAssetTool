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
            string path = "D:\\assettool\\全民无双.apk";

            SerializeAPK apk = new SerializeAPK();
            apk.DeSerialize(path);

            //UnityAssetTools tools = new UnityAssetTools();
            //tools.Run(args);
            Console.Write("Please enter any key to contiue..");
            Console.Read();
        }
    }
}
