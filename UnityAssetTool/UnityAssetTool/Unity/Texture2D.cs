using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UnityAssetTool.Unity
{
    public class Texture2D : NamedObject
    {
        int m_Width;
        int m_Height;
        int m_CompleteImageSize;
        int m_TextureFormat;
        int m_MipCount;
        bool m_IsReadable;
        bool m_ReadAllowed;
        int m_ImageCount;
        int m_TextureDimension;

        public class GLTextureSettings
        {
            public int m_FilterMode;
            public int m_Aniso;
            public float m_MipBias;
            public int m_WrapMode;
        }
        GLTextureSettings m_TextureSettings;
        int m_lightmapFormat;
        int m_ColorSpace;
        byte[] image_data;

        public override void Deserialize(SerializeProperty rootProperty)
        {
            
        }
    }
}
