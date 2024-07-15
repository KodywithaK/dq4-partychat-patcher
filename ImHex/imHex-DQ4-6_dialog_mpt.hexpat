import hex.provider;
import std.file;
import std.io;

/////////////// Defining Functions ///////////////

fn Add(u32 a, u32 b)
{
  return a + b;
};

fn newlineSeparate(str input)
{
  str output = input + "\n";
  return output;
};

fn tabSeparate(str input)
{
  str output = "\t" + input + "\n";
  return output;
};

////////////// Defining Enumerators //////////////

enum controlCharacterU8 : u8
{
  newline = 0x0A,
  idk = 0xFE
};

enum controlCharacterU16 : u16
{
  nameStart = 0x6140,
  nameEnd = 0x6240,
  anonymous = 0x3A2A
};

enum controlCharacterU24 : u24
{
  nameEnd = 0xEC828C,
};

enum charU24 : u24
{
  nameEnd = 0xEC828C,
};

enum controlCharacterU32 : u32
{
  endString = 0x63404030,
};

//////////////// Defining Structs ////////////////

struct header
{
  char MPT0[4];
  u32 dataSize;
  u32 startStrings;
  u32 endStrings;
  u32 numberOfStrings; // it seems like this is accurate *most* of the time, but not always
  u32 start;
  u32 stop;
  u32 end;
  u32 BOF = Add(start, stop); // the sum of the values at Address "start" "stop" point to where the Beginning of the File is
  u32 EOF = Add(BOF, end);// the sum of the values at Address "BOF" "end" point to where the End of the File is
  char idk_yet[while ($ != BOF)];
};

struct string
{
// std::print("\nCurrent Value @ 0x{:X} = 0x{:X}", $, $[$]);

  controlCharacterU16 [[hidden]]; // in our case 0x6140 aka "nameStart"

////////////////// Latin Script //////////////////

  if ($[$] != 0x40) // if not "@", then...
  {
    char name[while ($[$] != 0x40)];
    std::print("{}", name);
    std::file::write(f, newlineSeparate(name));
  }

  controlCharacterU16 [[hidden]]; // in our case 0x6240 aka "nameEnd"

  if ($[$] == 0x2A) // if "*", then...
  {
    char name[3]; // catches 3 characters, in our case "*: "
    std::print("{}", name);
    std::file::write(f, newlineSeparate(name));
  }

//////////////////// Japanese ////////////////////
  else if ($[$] >= 0xE3)
  {
//    std::print("0x{:X}{:X}{:X}",$[$],$[$+1],$[$+2]);
    char name[while ($[$ + 2] != 0x8C)]; // catches all characters until 0x8C, in our case "「"
//    std::print("{}", name);
    std::warning(name);
    std::file::write(f, newlineSeparate(name));
    controlCharacterU24;
  }
//////////////////////////////////////////////////

  char line1[while ($[$] != 0xA)]; // catches all characters until hitting 0xA aka "newline"
  std::print("\t{}", line1);
  std::file::write(f, tabSeparate(line1));
  controlCharacterU8 [[hidden]];
  if ($[$] != 0x40) // if not "@", then...
  {
    char line2[while ($[$] != 0xA)]; // catches all characters until hitting 0xA aka "newline"
    std::print("\t{}", line2);
    std::file::write(f, tabSeparate(line2));
    controlCharacterU8 [[hidden]];
    if ($[$] != 0x40) // if not "@", then...
    {
      char line3[while ($[$] != 0xA)]; // catches all characters until hitting 0xA aka "newline"
      std::print("\t{}", line3);
      std::file::write(f, tabSeparate(line3));
      controlCharacterU8 [[hidden]];
    }
  }
  controlCharacterU32 [[hidden]];
  padding[while ($[$] == 0xFE)];
};

struct stringTable
{
  string string[[ inline, single_color ]];
};

////////////////// Pattern Data //////////////////

header header @0x0; //[[ inline ]]; // Highlights in `Hex Editor` and fills in `Pattern Data` panels

// stringTable stringTable[while ($ != header.EOF)] @header.BOF[[ inline ]];

//////////////// Write *.txt file ////////////////

str newfile = hex::prv::get_information("file_path") + ".txt";

std::file::Handle f;

f = std::file::open(newfile, std::file::Mode::Create);

// stringTable stringTable[5] @header.BOF[[ inline ]];
stringTable stringTable[while ($ != header.EOF)] @header.BOF[[inline]];

std::file::close(f);