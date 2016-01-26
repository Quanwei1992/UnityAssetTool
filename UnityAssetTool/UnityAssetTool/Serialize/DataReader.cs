using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;

namespace UnityAssetTool
{
    public class DataReader
    {

        public ByteOrder byteOrder = ByteOrder.Little;
        public enum ByteOrder
        {
            Little,//小段字节序
            Big//大端字节序
        }

        BinaryReader mStream;
        public DataReader(Stream stream)
        {
            mStream = new BinaryReader(stream);
            if (!BitConverter.IsLittleEndian) {
                byteOrder = ByteOrder.Big;
            }
        }


        public Stream BaseStream
        {
            get
            {
                return mStream.BaseStream;
            }
        }

        public int ReadInt32()
        {
            var arr = mStream.ReadBytes(4);
            if (IsNeedReverse()) {
                Array.Reverse(arr);
            }
            return BitConverter.ToInt32(arr, 0);
        }

        public int[] ReadInt32(int count)
        {
            int[] array = new int[count];
            for (int i = 0; i < count; i++) {
                array[i] = ReadInt32();
            }
            return array;
        }

        public bool ReadBool()
        {
            return mStream.ReadBoolean();
        }

        public bool[] ReadBool(int count)
        {
            bool[] array = new bool[count];
            for (int i = 0; i < count; i++) {
                array[i] = ReadBool();
            }
            return array;
        }

        public uint ReadUint32()
        {
            var arr = mStream.ReadBytes(4);
            if (IsNeedReverse()) {
                Array.Reverse(arr);
            }
            return BitConverter.ToUInt32(arr, 0);
        }

        public uint[] ReadUint32(int count)
        {
            uint[] array = new uint[count];
            for (int i = 0; i < count; i++) {
                array[i] = ReadUint32();
            }
            return array;
        }

        public long ReadInt64()
        {
            var arr = mStream.ReadBytes(8);
            if (IsNeedReverse()) {
                Array.Reverse(arr);
            }
            return BitConverter.ToInt64(arr, 0);
        }

        public long[] ReadInt64(int count)
        {
            long[] array = new long[count];
            for (int i = 0; i < count; i++) {
                array[i] = ReadInt64();
            }
            return array;
        }

        public ulong ReadUInt64()
        {
            var arr = mStream.ReadBytes(8);
            if (IsNeedReverse()) {
                Array.Reverse(arr);
            }
            return BitConverter.ToUInt64(arr, 0);
        }
        public ulong[] ReadUInt64(int count)
        {
            ulong[] array = new ulong[count];
            for (int i = 0; i < count; i++) {
                array[i] = ReadUInt64();
            }
            return array;
        }

        public byte ReadByte()
        {
            return mStream.ReadByte();
        }

        public char ReadChar()
        {
            return mStream.ReadChar();
        }

        public short ReadInt16()
        {
            var arr = mStream.ReadBytes(2);
            if (IsNeedReverse()) {
                Array.Reverse(arr);
            }
            return BitConverter.ToInt16(arr, 0);
        }
        public short[] ReadInt16(int count)
        {
            short[] array = new short[count];
            for (int i = 0; i < count; i++) {
                array[i] = ReadInt16();
            }
            return array;
        }

        public ushort ReadUInt16()
        {
            var arr = mStream.ReadBytes(2);
            if (IsNeedReverse()) {
                Array.Reverse(arr);
            }
            return BitConverter.ToUInt16(arr, 0);

        }

        public ushort[] ReadUInt16(int count)
        {
            ushort[] array = new ushort[count];
            for (int i = 0; i < count; i++) {
                array[i] = ReadUInt16();
            }
            return array;
        }

        public object ReadSbyte()
        {
            return mStream.ReadSByte();
        }

        public uint ReadUInt32()
        {
            var arr = mStream.ReadBytes(4);
            if (IsNeedReverse()) {
                Array.Reverse(arr);
            }
            return BitConverter.ToUInt32(arr, 0);

        }
        public uint[] ReadUInt32(int count)
        {
            uint[] array = new uint[count];
            for (int i = 0; i < count; i++) {
                array[i] = ReadUInt32();
            }
            return array;
        }

        public long position
        {
            get
            {
                return mStream.BaseStream.Position;
            }
            set
            {
                mStream.BaseStream.Position = value;
            }
        }


        public void Align(int align)
        {
            long pos = mStream.BaseStream.Position;
            long rem = pos % align;
            if (rem != 0L) {
                mStream.BaseStream.Position = pos + align - rem;
            }
        }


        public byte[] GetRangeBytes(uint startIndex, uint size)
        {
            var oldPos = this.position;
            this.position = startIndex;
            var ret = ReadBytes((int)size);
            this.position = oldPos;
            return ret;
        }

        public byte[] ReadBytes(int count)
        {
            return mStream.ReadBytes(count);
        }

        public sbyte[] ReadSbytes(int count)
        {
            sbyte[] sbytes = new sbyte[count];
            for (int i = 0; i < sbytes.Length; i++) {
                sbytes[i] = mStream.ReadSByte();
            }
            return sbytes;

        }

        public double ReadDouble()
        {
            return mStream.ReadDouble();
        }

        public double[] ReadDouble(int count)
        {
            double[] array = new double[count];
            for (int i = 0; i < count; i++) {
                array[i] = ReadDouble();
            }
            return array;
        }

        public float ReadFloat()
        {
            return mStream.ReadSingle();
        }

        public float[] ReadFloat(int count)
        {
            float[] array = new float[count];
            for (int i = 0; i < count; i++) {
                array[i] = ReadFloat();
            }
            return array;
        }
        public string ReadString()
        {
            return mStream.ReadString();
        }

        public string[] ReadString(int count)
        {
            string[] array = new string[count];
            for (int i = 0; i < count; i++) {
                array[i] = ReadString();
            }
            return array;
        }

        public char[] ReadChars(int count)
        {
            return mStream.ReadChars(count);
        }

        public string ReadStringNull()
        {
            List<char> buff = new List<char>();
            char ch;
            while ((ch = ReadChar()) != 0) {
                buff.Add(ch);
            }
            return new string(buff.ToArray(), 0, buff.Count);
            //return ReadStringNull(256);
        }

        public string ReadStringNull(int limit)
        {
            char[] buff = new char[limit];
            char ch;
            int i = 0;
            while ((ch = ReadChar()) != 0) {
                if (i < limit) {
                    buff[i] = ch;
                }
                i++;
            }
            return new string(buff, 0, limit);
        }

        public string[] ReadStringNullArray(int count)
        {
            string[] array = new string[count];
            for (int i = 0; i < count; i++) {
                array[i] = ReadStringNull();
            }
            return array;
        }

        public void Close()
        {
            mStream.Close();
        }

        private bool IsNeedReverse()
        {
            if (GetLocalEndianMode() != byteOrder) {
                return true;
            }
            return false;
        }

        private ByteOrder GetLocalEndianMode()
        {
            if (BitConverter.IsLittleEndian) {
                return ByteOrder.Little;
            }
            return ByteOrder.Big;
        }


    }
}
