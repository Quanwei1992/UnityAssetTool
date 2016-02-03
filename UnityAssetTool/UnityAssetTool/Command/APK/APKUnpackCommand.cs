using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UnityAssetTool.Unity;
using CommandLine;
using CommandLine.Parsing;
using CommandLine.Text;
namespace UnityAssetTool.Command
{
    public class APKUnpackCommand:APKCommand
    {

        [Option('o', "output", HelpText = "Output Directory.", Required = false, DefaultValue = null)]
        public string OutputDir { get; set; }
        [Option('m', "mode", HelpText = "Extract Mode 0:Auto,1:OnlyRawBits,2:OnlyRawText,3:RawBitsOrRawText", Required = false, DefaultValue = 0)]
        public int mode { get; set; }

        AssetExtrator extrator = null;
        TypeTreeDataBase db = null;
        public override void run()
        {
            extrator = new AssetExtrator();
            db = AssetToolUtility.LoadTypeTreeDataBase(Properties.Resources.TypeTreeDataBasePath);
            base.run();
        }
        public override void runApk(SerializeAPK apk)
        {
            ResourceManager resMgr = apk.ResMgr;
            List<Asset> assetList = apk.AssetList;
            var extractMode = AssetExtrator.ExtractMode.Auto;
            if (mode == 1) {
                extractMode = AssetExtrator.ExtractMode.OnlyRawBits;
            } else if (mode == 2) {
                extractMode = AssetExtrator.ExtractMode.OnlyRawText;
            } else if (mode == 3) {
                extractMode = AssetExtrator.ExtractMode.RawTextOrRawBits;
            }
            foreach (var kvr in resMgr.Container) {
                string path = kvr.Key;
                Debug.log("Extract " + path);
                List<PptrObject> assets = kvr.Value;
                string outPath = OutputDir + "\\Resources\\" + path;
                if (assets.Count > 1) {
                    outPath += "\\";
                }
                foreach (var obj in assets) {
                    int index = obj.FileID;
                    if (apk.Version == 15) {
                        index++;
                    }
                    if (index > 0 && index < assetList.Count) {
                        var asset = assetList[index];
                        Asset.AssetObjectInfo objInfo = null;
                        foreach (var info in asset.ObjectInfos) {
                            ulong pathID = obj.PathID;
                            if (apk.Version == 15) {
                                pathID--;
                            }
                            if (info.PathID == pathID) {
                                objInfo = info;
                                break;
                            }
                        }
                        if (objInfo != null) {
                            TypeTree typeTree = db.GetType(asset.AssetVersion, objInfo.classID);
                            extrator.ExtractObjct(objInfo, typeTree, outPath, extractMode);
                        } else {
                            Debug.LogError("Can't find obj PathID:{0} in fileID {1}", obj.PathID, index);
                        }
                    } else {
                        Debug.LogError("FileID {0} out of range {1}.", obj.FileID, assetList.Count);
                    }
                }
            }
        }
    }
}
