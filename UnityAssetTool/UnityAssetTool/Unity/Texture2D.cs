using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Drawing.Drawing2D;

namespace UnityAssetTool.Unity
{
    public class Texture2D : NamedObject
    {
        int m_Width;
        int m_Height;
        int m_CompleteImageSize;
        public int m_TextureFormat;
        int m_MipCount;
        bool m_IsReadable;
        bool m_ReadAllowed;
        int m_ImageCount;
        int m_TextureDimension;

        public class GLTextureSettings : BaseObject
        {
            public int m_FilterMode;
            public int m_Aniso;
            public float m_MipBias;
            public int m_WrapMode;
            public override void Deserialize(SerializeProperty rootProperty)
            {
                base.Deserialize(rootProperty);
                bindField("m_FilterMode", rootProperty);
                bindField("m_Aniso", rootProperty);
                bindField("m_MipBias", rootProperty);
                bindField("m_WrapMode", rootProperty);
            }
        }
        GLTextureSettings m_TextureSettings = new GLTextureSettings();
        int m_LightmapFormat;
        int m_ColorSpace;
        public byte[] image_data;

        public override void Deserialize(SerializeProperty rootProperty)
        {
            base.Deserialize(rootProperty);
            bindField("m_Width", rootProperty);
            bindField("m_Height", rootProperty);
            bindField("m_CompleteImageSize", rootProperty);
            bindField("m_TextureFormat", rootProperty);
            bindField("m_MipCount", rootProperty);
            bindField("m_IsReadable", rootProperty);
            bindField("m_ReadAllowed", rootProperty);
            bindField("m_ImageCount", rootProperty);
            bindField("m_TextureDimension", rootProperty);
            m_TextureSettings.Deserialize(rootProperty.FindChild("m_TextureSettings"));
            bindField("m_LightmapFormat", rootProperty);
            bindField("m_ColorSpace", rootProperty);
            image_data = (byte[])rootProperty.FindChild("image data").Value;
        }
    }
}
