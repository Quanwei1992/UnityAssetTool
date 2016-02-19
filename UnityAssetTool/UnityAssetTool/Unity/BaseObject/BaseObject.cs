using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UnityAssetTool.Unity
{
    public class BaseObject : ISerialize
    {
        public virtual void Deserialize(SerializeProperty rootProperty)
        {

        }
        protected void bindField(string fieldName, SerializeProperty rootProperty)
        {
            var field = GetType().GetField(fieldName, System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.NonPublic
                | System.Reflection.BindingFlags.Instance);
            if (field == null) {
                Debug.LogError("Can't find field {0} in {1}.", fieldName, GetType().Name);
                return;
            }
            var property = rootProperty.FindChild(fieldName);
            if (property == null) {
                Debug.LogError("Can't find property {0} in {1}.", fieldName, GetType().Name);
                return;
            }
            field.SetValue(this, property.Value);
        }


    }
}
