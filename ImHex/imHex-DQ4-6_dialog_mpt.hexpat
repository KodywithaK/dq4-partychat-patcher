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
	asterisk = 0x2A3A
};

enum cc24 : u24
{
	asterisk = 0x2A3A20,
	fullwidth_asterisk = 0xEFBC8A,
	left_corner_bracket = 0xE3808C,
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

fn newlineSeparate(str input)
{
	str output = input + "\n";
	return output;
};

fn tabSeparate(str input)
{
	str output = "\t" + input;
	return output;
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

fn getName(u32 address)
{
	str characters;
	str name;
	u32 whileAddress = address;

	while (mru2(whileAddress) != cc16::nameEnd)
	{
		characters = characters + std::mem::read_string(whileAddress, 1);
		whileAddress = whileAddress + 1;
	}
	name = characters;
	return name;
};

fn getString(u32 address)
{
	str characters;
	str string;
	u32 whileAddress = address;

	while (mru1(whileAddress) != cc08::newline)
	{
		characters = characters + std::mem::read_string(whileAddress, 1);
		whileAddress = whileAddress + 1;
		if (mru1(whileAddress) == cc08::newline)
		{
			// whileAddress = whileAddress + 1;
		}
	}
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
		le u32 checksum_c; // checksums b - a == c + 1 // number of strings
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
		std::error(">>>>> DQ6_DS file version is not done yet. <<<<<");
		break;
	}
	else
	{
		std::error(">>>>> Not a recognized file version. <<<<<");
		break;
	}
}; // [[inline]];

struct Test
{
	cc16;
	u16 U16 = mru2($);
	//    std::print("0x{:X}",U16);
	////////////////////////////////////////////////////////////////////////////////////////////////////
	if (mru2($) == cc16::nameEnd
		&& mru4($) != cc32::asterisk)
	{
		//        std::print("Y1");
		cc16;
		char String1[std::string::length(getString($))];
		cc08 [[hidden]];
		if (mru4($) == cc32::pitch_none
			|| mru4($) == cc32::pitch_high
			|| mru4($) == cc32::pitch_medium
			|| mru4($) == cc32::pitch_low)
		{
			std::print("~ " + String1 + " ~");
			std::file::write(f, "~ " + String1 + " ~" + "\n");
		}
		else
		{
			char String2[std::string::length(getString($))];
			cc08 [[hidden]];
			if (mru4($) == cc32::pitch_none
				|| mru4($) == cc32::pitch_high
				|| mru4($) == cc32::pitch_medium
				|| mru4($) == cc32::pitch_low)
			{
				std::print("~ " + String1 + " ~");
				std::file::write(f, "~ " + String1 + " ~" + "\n");
				std::print("~ " + String2 + " ~");
				std::file::write(f, "~ " + String2 + " ~" + "\n");
			}
			else
			{
				char String3[std::string::length(getString($))];
				cc08 [[hidden]];
				if (mru4($) == cc32::pitch_none
					|| mru4($) == cc32::pitch_high
					|| mru4($) == cc32::pitch_medium
					|| mru4($) == cc32::pitch_low)
				{
					std::print("~ " + String1 + " ~");
					std::file::write(f, "~ " + String1 + " ~" + "\n");
					std::print("~ " + String2 + " ~");
					std::file::write(f, "~ " + String2 + " ~" + "\n");
					std::print("~ " + String3 + " ~");
					std::file::write(f, "~ " + String3 + " ~" + "\n");
				}
				else
				{
					char String4[std::string::length(getString($))];
					cc08 [[hidden]];
					if (mru4($) == cc32::pitch_none
						|| mru4($) == cc32::pitch_high
						|| mru4($) == cc32::pitch_medium
						|| mru4($) == cc32::pitch_low)
					{
						std::print("~ " + String1 + " ~");
						std::file::write(f, "~ " + String1 + " ~" + "\n");
						std::print("~ " + String2 + " ~");
						std::file::write(f, "~ " + String2 + " ~" + "\n");
						std::print("~ " + String3 + " ~");
						std::file::write(f, "~ " + String3 + " ~" + "\n");
						std::print("~ " + String4 + " ~");
						std::file::write(f, "~ " + String4 + " ~" + "\n");
					}
					/*else
					{
						char String4[std::string::length(getString($))];
						// std::print("String3 = {}", String3);
						cc08 [[hidden]];
					}*/
				}
			}
		}
		////////////////////////////////////////////////////////////////////////////////////////////////////
		cc32;
		padding[while ($[$] == 0xFE)];
	}
	////////////////////////////////////////////////////////////////////////////////////////////////////
	else if (mru4($) == cc32::asterisk)
	{
		cc16;
		char Name[3];
		std::print(Name);
		std::file::write(f, Name + "\n");
		char String1[std::string::length(getString($))];
		cc08 [[hidden]];
		if (mru4($) == cc32::pitch_none
			|| mru4($) == cc32::pitch_high
			|| mru4($) == cc32::pitch_medium
			|| mru4($) == cc32::pitch_low)
		{
			std::print("\t" + String1);
			std::file::write(f, "\t" + String1 + "\n");
		}
		else
		{
			//            std::warning("String2");
			char String2[std::string::length(getString($))];
			//            std::print("String2 = {}",String2);
			cc08 [[hidden]];
			if (mru4($) == cc32::pitch_none
				|| mru4($) == cc32::pitch_high
				|| mru4($) == cc32::pitch_medium
				|| mru4($) == cc32::pitch_low)
			{
				std::print("\t" + String1);
				std::file::write(f, "\t" + String1 + "\n");
				std::print("\t" + String2);
				std::file::write(f, "\t" + String2 + "\n");
			}
			else
			{
				//            std::warning("String3");
				char String3[std::string::length(getString($))];
				//            std::print("String3 = {}",String3);
				std::print("\t" + String1);
				std::file::write(f, "\t" + String1 + "\n");
				std::print("\t" + String2);
				std::file::write(f, "\t" + String2 + "\n");
				std::print("\t" + String3);
				std::file::write(f, "\t" + String3 + "\n");
				cc08 [[hidden]];
			}
			////////////////////////////////////////////////////////////////////////////////////////////////////
		}
		cc32;
		padding[while ($[$] == 0xFE)];
	}
	////////////////////////////////////////////////////////////////////////////////////////////////////
	else // Named speaker
	{
		//        std::print("N1");
		char Name[std::string::length(getName($))];
		std::print(Name);
		std::file::write(f, Name + "\n");
		cc16;
		char String1[std::string::length(getString($))];
		cc08 [[hidden]];
		if (mru4($) == cc32::pitch_none
			|| mru4($) == cc32::pitch_high
			|| mru4($) == cc32::pitch_medium
			|| mru4($) == cc32::pitch_low)
		{
			std::print("\t" + String1);
			std::file::write(f, "\t" + String1 + "\n");
		}
		else
		{
			//            std::warning("String2");
			char String2[std::string::length(getString($))];
			//            std::print("String2 = {}",String2);
			std::print("\t" + String2);
			cc08 [[hidden]];
			if (mru4($) == cc32::pitch_none
				|| mru4($) == cc32::pitch_high
				|| mru4($) == cc32::pitch_medium
				|| mru4($) == cc32::pitch_low)
			{
				std::print("\t" + String1);
				std::file::write(f, "\t" + String1 + "\n");
				std::print("\t" + String2);
				std::file::write(f, "\t" + String2 + "\n");
			}
			else
			{
				//            std::warning("String3");
				char String3[std::string::length(getString($))];
				//            std::print("String3 = {}",String3);
				std::print("\t" + String3);
				cc08 [[hidden]];
				if (mru4($) == cc32::pitch_none
					|| mru4($) == cc32::pitch_high
					|| mru4($) == cc32::pitch_medium
					|| mru4($) == cc32::pitch_low)
				{
					std::print("\t" + String1);
					std::file::write(f, "\t" + String1 + "\n");
					std::print("\t" + String2);
					std::file::write(f, "\t" + String2 + "\n");
					std::print("\t" + String3);
					std::file::write(f, "\t" + String3 + "\n");
				}
				else
				{
					//            std::warning("String4");
					char String4[std::string::length(getString($))];
					//            std::print("String4 = {}",String4);
					std::print("\t" + String4);
					cc08 [[hidden]];
				}
			}
		}
		cc32;
		padding[while ($[$] == 0xFE)];
	}
	////////////////////////////////////////////////////////////////////////////////////////////////////
} [[single_color]];

/////////////////////////////////////////// Pattern Data ///////////////////////////////////////////

Header header @0x00;

// Test test[295] @header.BOF;
// std::print("0x{:X} @ 0x{:X}", $[$], $);
// Test test[while ($ != header.EOF)] @header.BOF;

///////////////////////////////////////// Write *.txt file /////////////////////////////////////////
///*
str newfile = hex::prv::get_information("file_path") + ".txt";

std::file::Handle f;

f = std::file::open(newfile, std::file::Mode::Create);

Test test[while ($ != header.EOF)] @header.BOF[[inline]];
// Test test[5] @header.BOF[[inline]];

// StringTable stringTable[while ($ != header.EOF)] @header.BOF[[inline]];
//  StringTable stringTable[5] @header.BOF[[inline]];

std::file::close(f);
//*/