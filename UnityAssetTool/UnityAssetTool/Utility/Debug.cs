using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UnityAssetTool
{
    public static class Debug
    {
        public static void log(object obj)
        {
            Console.WriteLine(obj);
        }
        public static void Log(string format,params object[] arg)
        {
            LogColored(ConsoleColor.White, format, arg);
        }

        public static void LogError(string format, params object[] arg)
        {
            LogColored(ConsoleColor.Red, format, arg);
        }

        public static void LogWaring(string format, params object[] arg)
        {
            LogColored(ConsoleColor.Yellow, format, arg);
        }

        public static void LogColored(ConsoleColor color, string format, params object[] arg)
        {
            Console.ForegroundColor = color;
            Console.WriteLine(format, arg);
            Console.ForegroundColor = ConsoleColor.White;
        }
    }
}
