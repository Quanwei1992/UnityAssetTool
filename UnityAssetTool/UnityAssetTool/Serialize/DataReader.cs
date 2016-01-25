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

        public bool ReadBool()
        {
            return mStream.ReadBoolean();
        }

        public uint ReadUint32()
        {
            var arr = mStream.ReadBytes(4);
            if (IsNeedReverse()) {
                Array.Reverse(arr);
            }
            return BitConverter.ToUInt32(arr, 0);
        }

        public long ReadInt64()
        {
            var arr = mStream.ReadBytes(8);
            if (IsNeedReverse()) {
                Array.Reverse(arr);
            }
            return BitConverter.ToInt64(arr, 0);
        }

        public ulong ReadUInt64()
        {
            var arr = mStream.ReadBytes(8);
            if (IsNeedReverse()) {
                Array.Reverse(arr);
            }
            return BitConverter.ToUInt64(arr, 0);
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

        public ushort ReadUInt16()
        {
            var arr = mStream.ReadBytes(2);
            if (IsNeedReverse()) {
                Array.Reverse(arr);
            }
            return BitConverter.ToUInt16(arr, 0);

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

        internal object readDouble()
        {
            throw new NotImplementedException();
        }

        internal object readFloat()
        {
            throw new NotImplementedException();
        }

        public string ReadString()
        {
            return mStream.ReadString();
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
