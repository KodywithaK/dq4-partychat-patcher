#pragma endian big
#pragma loop_limit 10240

import hex.provider;
import std.array;
import std.file;
import std.io;
import std.mem;
import std.string;

//////////////////////////////////////////// Enumerator ////////////////////////////////////////////

enum File_Version : u32
{
	MPT0 = 0x4D505430,
};

enum cc08 : u8
{
	newline = 0x0A,
	space = 0x20,
	at = 0x40,
};

enum cc16 : u16
{
	nameStart = 0x4061,
	nameEnd = 0x4062,
	atC = 0x4063,
	asterisk = 0x2A3A,
	colon = 0x3A20,
};

enum cc24 : u24
{
	asterisk = 0x2A3A20,
	circled_latin_small_Letter_a = 0xE29390, // FR exclamation mark (e.g., !?)
	circled_latin_small_Letter_b = 0xE29391, // FR question mark (e.g., ???)
	circled_latin_small_Letter_f = 0xE29395, // IT left double quotation mark
	circled_latin_small_Letter_g = 0xE29396, // IT right double quotation mark
	circled_latin_small_Letter_h = 0xE29397, // EN left double quotation mark
	circled_latin_small_Letter_i = 0xE29398, // EN right double quotation mark
	circled_latin_small_Letter_o = 0xE2939E, // DE left double quotation mark
	circled_latin_small_Letter_p = 0xE2939F, // DE right double quotation mark
	circled_latin_small_Letter_q = 0xE293A0, // FR exclamation mark
	circled_latin_small_Letter_r = 0xE293A1, // FR question mark
	circled_latin_small_Letter_s = 0xE293A2, // FR colon
	circled_latin_small_Letter_v = 0xE293A5, // FR left double quotation mark
	circled_latin_small_Letter_w = 0xE293A6, // FR right double quotation mark
	left_corner_bracket = 0xE3808C,
	fullwidth_asterisk = 0xEFBC8A,
	fullwidth_colon = 0xEFBC9A,
};

enum cc32 : u32
{
	pitch_none = 0x40633040,
	pitch_high = 0x40633140,
	pitch_medium = 0x40633240,
	pitch_low = 0x40633340,
	noName = 0x40614062,
	asterisk = 0x40622A3A
};

///////////////////////////////////////////// Function /////////////////////////////////////////////

fn Add(u32 a, u32 b)
{
	return a + b;
};

fn mru1(u32 address)
{
	u8 result = std::mem::read_unsigned(address, 1, std::mem::Endian::Big);
	return result;
};

fn mru2(u32 address)
{
	u16 result = std::mem::read_unsigned(address, 2, std::mem::Endian::Big);
	return result;
};

fn mru3(u32 address)
{
	u24 result = std::mem::read_unsigned(address, 3, std::mem::Endian::Big);
	return result;
};

fn mru4(u32 address)
{
	u32 result = std::mem::read_unsigned(address, 4, std::mem::Endian::Big);
	return result;
};

fn getLanguages()
{
	str Array[9] = {"DE", "EN", "ES", "FR", "IT", "JA", "KO", "SL", "TL"};

	for (u8 j = 0, j < 9, j = j + 1)
	{
		if (std::string::contains(hex::prv::get_information("file_path"), "/" + Array[j] + "/"))
		{
			return Array[j];
		}
	}
};
// std::print("{}", getLanguages());

fn getName(u32 address)
{
	str characters;
	str name;
	u32 whileAddress = address;

	while (mru2(whileAddress) != cc16::nameEnd
		&& mru2(whileAddress) != cc16::colon
		&& mru3(whileAddress) != cc24::circled_latin_small_Letter_s
		&& mru3(whileAddress) != cc24::left_corner_bracket
		&& mru3(whileAddress) != cc24::fullwidth_colon
		&& mru4(whileAddress) != cc32::pitch_none
		&& mru4(whileAddress) != cc32::pitch_high
		&& mru4(whileAddress) != cc32::pitch_medium
		&& mru4(whileAddress) != cc32::pitch_low) // get name
	{
		characters = characters + std::mem::read_string(whileAddress, 1);
		whileAddress = whileAddress + 1;
	}
	if (mru4(whileAddress) == cc32::pitch_none
	 || mru4(whileAddress) == cc32::pitch_high
	 || mru4(whileAddress) == cc32::pitch_medium
	 || mru4(whileAddress) == cc32::pitch_low) // No name check
	{
		name = "";
	}
	else
	{
		name = characters;
	}
	return name;
};

fn getString(u32 address)
{
	str characters;
	str string;
	u32 whileAddress = address;

	while (mru4(whileAddress) != cc32::pitch_none
		&& mru4(whileAddress) != cc32::pitch_high
		&& mru4(whileAddress) != cc32::pitch_medium
		&& mru4(whileAddress) != cc32::pitch_low) //(mru1(whileAddress) != cc08::newline)
	{
		characters = characters + std::mem::read_string(whileAddress, 1);
		whileAddress = whileAddress + 1;
/*		if (mru1(whileAddress) == cc08::newline)
		{
			// whileAddress = whileAddress + 1;
		}
*/	}
	string = string + characters;
	whileAddress = whileAddress + 1;
	return string;
};

//////////////////////////////////////////// Structures ////////////////////////////////////////////

struct Header
{
	if (std::mem::read_unsigned($, 4, std::mem::Endian::Big) == File_Version::MPT0)
	{
		File_Version b_______;
		u32 file_size;
		le u32 checksum_a;
		le u32 checksum_b;
		le u32 numberOfStrings; // checksums b - a == c + 1 // number of strings
		le u32 a;
		le u32 b;
		le u32 c;			   // the sum of a + b + c == BOF
		u32 BOF = Add(a, b);   // the sum of the values at Address "a" "b" point to where the Beginning of the File is
		u32 EOF = Add(BOF, c); // the sum of the values at Address "BOF" "end" point to where the End of the File is
		le u32 d;			   // file_size - d == BOF
		u32 two;
		//        padding[while($ != BOF)];
	}
	else if (std::mem::read_unsigned($ + 5, 4, std::mem::Endian::Big) == File_Version::MPT0)
	{
		// std::print("DQ6_DS; this one is a mess, it'll take some time to sort through.");
		char ten[1];
		u32;
		char file_extension[4];
		u32;
		//		std::error(">>>>> DQ6_DS file version is not done yet. <<<<<");
		//		break;
	}
	else
	{
		std::error(">>>>> Not a recognized file version. <<<<<");
		break;
	}
}; // [[inline]];

u32 i = 1;

struct Test
{
	str Start = std::format("\"{:05d}\": {}", i, "{");
	// std::print("{}", Start);

	cc16 [[hidden]];
	if (mru2($) == cc16::nameEnd)
	{
		cc16 [[hidden]];
		char Name[std::string::length(getName($))];
		str Names = std::format("\"name\": \"{}\",", Name);
		// std::print("{}", Names);
		// std::print("{}",mru3($));
		if (mru3($) == cc24::circled_latin_small_Letter_s
		 || mru3($) == cc24::left_corner_bracket
		 || mru3($) == cc24::fullwidth_colon)
		{
			padding[3];
		}
		else if (Name != "")
		{
			padding[2];
		}
	}
	else if (mru2($) != cc16::nameEnd)
	{
		char Name[std::string::length(getName($))];
		str Names = std::format("\"name\": \"{}\",", Name);
		// std::print("{}", Names);
		cc16 [[hidden]];
	}
	char String[std::string::length(getString($))];
	// std::print("\t\"dialog\": \"{}\"",
	str Strings = std::format("\"dialog\": \"{}\"", std::string::replace(std::string::replace(std::string::replace(std::string::replace(std::string::replace(std::string::replace(std::string::replace(std::string::replace(std::string::replace(std::string::replace(std::string::replace(std::string::replace(std::string::replace(std::string::replace(
			std::string::replace(
				std::string::replace(String, "\n", "\\n"), "ⓚⓛ", "—")
			, "\r", "")
			, "ⓐ", "!")
			, "ⓑ", "?")
			, "ⓕ", "“")
			, "ⓖ", "”")
			, "ⓗ", "“")
			, "ⓘ", "”")
			, "ⓞ", "“")
			, "ⓟ", "”")
			, "ⓠ", "!")
			, "ⓡ", "?")
			, "ⓢ", ":")
			, "ⓥ", "“")
			, "ⓦ", "”")
		);
	// std::print("{}", Strings);
	cc32 [[hidden]];
	padding[while ($[$] == 0xFE)];

	str FormatPrint = std::format(" \"{:05d}\": {}\n  {}\n  {}\n{},", i, "{", Names, Strings, "}");
	str Format = std::format("\t\"{:05d}\": {}\n\t\t\"{}\": {}\n\t\t\t{}\n\t\t\t{}\n\t\t{}\n\t{},\n", i, "{", getLanguages(), "{", Names, Strings, "}", "}");
	std::print("{}", FormatPrint);
	std::file::write(f, Format);
	i = i + 1;
} [[single_color]];

/////////////////////////////////////////// Pattern Data ///////////////////////////////////////////

Header header @0x00;

// Test test[1] @ header.BOF;
// std::print("0x{:X} @ 0x{:X}", $[$], $);
// Test test[while ($ != header.EOF)] @header.BOF;

///////////////////////////////////////// Write *.txt file /////////////////////////////////////////
///*
str newfile = std::string::replace(hex::prv::get_information("file_path"), "/b", "/.json/b") + ".json";

std::file::Handle f;

f = std::file::open(newfile, std::file::Mode::Create);

std::warning("{");

std::file::write(f, "{\n");

Test test[while ($ != header.EOF)] @header.BOF[[inline]];
// Test test[5] @header.BOF[[inline]];

std::warning("}");

std::file::write(f, "}");

// StringTable stringTable[while ($ != header.EOF)] @header.BOF[[inline]];
//  StringTable stringTable[5] @header.BOF[[inline]];

std::file::close(f);
//*/