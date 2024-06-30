import std.io;
import std.mem;
import std.math;
import std.ptr;

fn Add(u32 a, u32 b) {
  return a + b;
};

struct header {
  char MPT0[4];
  u32 dataSize;
  u32 startString;
  u32 endString;
  u32 numberOfStrings;
  u32 start;
  u32 stop;
  //  std::print("Add = {}",Add(std::mem::read_unsigned(addressof(stop), 2, std::mem::Endian::Little),std::mem::read_unsigned(addressof(start), 2, std::mem::Endian::Little)));
  u32 offset = Add(start, stop);
  //  u32 offset = std::math::accumulate(start,stop,1);
  std::print("{}", std::math::accumulate(start, stop, 1));
};

header header @ 0x0; //[[inline]];

//fn check(char a) { 
//  if (a != 0x62) {
//  std::print("{}","a");
//  }
//};

enum controlCharacter: u8 {
  newline = 0xA
};

// @a = nameStart
// @b = nameEnd

struct stringTable {
  controlCharacter cc;
  char string[
    while ($[$] != 0xA)];
  //  char begin[while($[$] != name)];
  std::print("{}", string);
  //  std::print("{}",std::format("{:02X}\t{}",addressof(string), string));
  //  str begin[while($[$] != std::mem::read_string(header.offset,1))];
};

stringTable stringTable[header.numberOfStrings] @ header.offset; //[[inline]];
//stringTable stringTable[5] @ header.offset[[inline]];