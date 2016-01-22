using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FileFormatTest
{
    public class TypeTree
    {
        public const int FLAG_FORCE_ALIGN = 0x4000;

        public TypeTree parent;
        List<TypeTree> childs = new List<TypeTree>();
        public string name;
        public string type;
        public int metaFlag;
        public int version;

        public TypeTree[] GetChildren(bool recursively = false)
        {
          
            if (!recursively) {
                return GetChildren();
            }
            List<TypeTree> ret = new List<TypeTree>();
            var children = GetChildren();
            ret.AddRange(children);
            foreach (var child in children) {
                ret.AddRange(child.GetChildren(true));
            }
            return ret.ToArray();
        }




        public TypeTree[] GetChildren()
        {
            return childs.ToArray();
        }

        public void AddChild(TypeTree typeTree)
        {
            if (!childs.Contains(typeTree)) {
                typeTree.parent = this;
                childs.Add(typeTree);
            }
        }

        public void RemoveChild(TypeTree typeTree)
        {
            if (childs.Contains(typeTree)) {
                typeTree.parent = null;
                childs.Remove(typeTree);
            }
        }

        public TypeTree FindTypetree(string fullName)
        {
            if (FullName == fullName) return this;
            for (int i = 0; i < childs.Count; i++) {
                var typeTree = childs[i].FindTypetree(fullName);
                if (typeTree != null) return typeTree;
            }
            return null;
        }

        public override string ToString()
        {
            string finalStr = "";
            string tabStr = "";
            var it = parent;
            while (it != null) {
                tabStr += "   ";
                it = it.parent;
            }

            finalStr = tabStr + type + " " + name + "\n";
            if (childs.Count > 0) {
                finalStr = finalStr + tabStr + "{\n";
                for (int i = 0; i < childs.Count; i++) {
                    finalStr = finalStr + tabStr + "    " + childs[i].ToString();
                }
                finalStr = finalStr + tabStr + "}\n";
            }
            return finalStr;
        }

        public string FullName
        {
            get
            {
                string fullName = this.name;
                var it = parent;
                while (it != null) {
                    fullName = it.name + "." + fullName;
                    it = it.parent;
                }
                return fullName;
            }
        }
    }

}
