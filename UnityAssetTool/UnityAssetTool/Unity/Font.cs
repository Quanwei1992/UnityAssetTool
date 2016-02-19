using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UnityAssetTool.Unity
{
    public class Font : NamedObject
    {
        int m_AsciiStartOffset;
        float m_Kerning;
        float m_LineSpacing;
        int m_CharacterSpacing;
        int m_CharacterPadding;
        int m_ConvertCase;
        PptrObject m_DefaultMaterial;
        byte[] m_FontData;

        public byte[] FontData
        {
            get
            {
                return m_FontData;
            }
        }

        public override void Deserialize(SerializeProperty rootProperty)
        {
            base.Deserialize(rootProperty);
            m_FontData = (byte[])rootProperty.FindChild("m_FontData.Array").Value;
        }

    }
}
