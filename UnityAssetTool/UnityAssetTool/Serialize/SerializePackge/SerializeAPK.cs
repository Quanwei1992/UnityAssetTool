using System;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Collections.Generic;
using ICSharpCode.SharpZipLib.Zip;
using UnityAssetTool.Unity;

namespace UnityAssetTool
{
    public class SerializeAPK
    {
        public List<Asset> AssetList = new List<Asset>();
        public ResourceManager ResMgr = new ResourceManager();
        public int Version;

        public bool DeSerialize(string packgePath)
        {
            ZipFile zipFile = null;
            try {
                zipFile = new ZipFile(packgePath);
            } catch {
                Debug.LogError("Cant't uncomress file "+packgePath);
                return false;
            }

            //load mainData
            var mainDataEntry = zipFile.GetEntry("assets/bin/Data/mainData");
            if (mainDataEntry == null) {
                Debug.LogError("Cant't uncomress file " + packgePath);
            }

            var zipStream = zipFile.GetInputStream(mainDataEntry);
            var mainDataStream = AssetToolUtility.ZipInputStream2MemoryStream(zipStream,mainDataEntry.Size);
            zipStream.Close();
            Version = AssetToolUtility.GetAssetsFileVersion(mainDataStream);    
            Debug.Log("MainDataVersion:" + Version);
            var serializeAsset = SerializeAssetFactory.CreateWithVersion(Version);
            if (serializeAsset == null) {
                Debug.LogError("Cant't uncomress file {0},Version:",packgePath, Version);
                zipFile.Close();
                return false;
            }
            DataReader dr = new DataReader(mainDataStream);
            serializeAsset.DeSerialize(dr);
            string rootPath = "assets/bin/Data/";
            var mainDataAsset = new Asset(serializeAsset);
            foreach (var externFileIdentier in mainDataAsset.ExternalFiles) {
                string filePath = externFileIdentier.filePath;
                //fix unity default resources path
                if (filePath.StartsWith("library/") && zipFile.GetEntry(rootPath+filePath) == null) {
                    filePath = filePath.Remove(0, 8);
                }
                string path = rootPath + filePath;
                try {
                    MemoryStream externStream = new MemoryStream();
                    var externZipEntry = zipFile.GetEntry(path);
                    if (externZipEntry != null) {
                        var externZipStream = zipFile.GetInputStream(externZipEntry);
                        externStream = AssetToolUtility.ZipInputStream2MemoryStream(externZipStream, externZipEntry.Size);
                        externZipStream.Dispose();
                    } else {
                        if (zipFile.GetEntry(path + ".split0") != null) {
                            //handel split file
                            int splitIndex = 0;
                            ZipEntry splitEntry = null;
                            while ((splitEntry = zipFile.GetEntry(path + ".split" + splitIndex++)) != null) {
                                var splitZipStream = zipFile.GetInputStream(splitEntry);
                                byte[] buffer = new byte[splitEntry.Size];
                                splitZipStream.Read(buffer, 0,buffer.Length);
                                splitZipStream.Dispose();
                                externStream.Write(buffer, 0, buffer.Length);
                            }
                        } else {
                            Debug.LogError("Can't find file {0} in apk", path);
                            continue;
                        }
                    }
                    externStream.Position = 0;
                    DataReader externDataReader = new DataReader(externStream);
                    var externSerializeFile = SerializeAssetFactory.CreateWithVersion(Version);
                    externSerializeFile.DeSerialize(externDataReader);
                    externStream.Dispose();        
                    Asset externAsset = new Asset(externSerializeFile);
                    AssetList.Add(externAsset);
                    Debug.Log("Added:" +path);
                } catch {
                    Debug.LogError("Cant't deserialize asset {0},Version:", path);
                    zipFile.Close();
                    return false;
                    
                }
            }

            //load typeTreeDataBase
            var typetreedb = AssetToolUtility.LoadTypeTreeDataBase(Properties.Resources.TypeTreeDataBasePath);
            //serach resource manager
            SerializeObject resourMgrObj = null;
            foreach (var obj in mainDataAsset.ObjectInfos) {
                if (obj.classID == 147) {
                    var resmgrType = typetreedb.GetType(Version, 147);
                    if (resmgrType != null) {
                        resourMgrObj = new SerializeObject(resmgrType, obj.data);
                        ResMgr.Deserialize(resourMgrObj.RootProperty);
                    } else {
                        Debug.LogError("Can't find resource manager typetree.");
                        zipFile.Close();
                        return false;
                        
                    }
                    break;
                }
            }
            if (resourMgrObj == null) {
                Debug.LogError("Can't find resource manager in mainData.");
                zipFile.Close();
                return false;
            }
            zipFile.Close();
            return true;    
        }
    }
}
