Texture-Unpacker
================
Download:
=========
You can download this tool from the repository [releases page][6]

About:
======
 This is a tool that you can use to extract json sheet made using [TexturePacker][3] made using [LÖVE][1] framework in [Lua][2].
 ![Screenshot while dropping MoveOrDie ui spritesheet into the tool][screenshot]

Features:
=========
- Supports spritesheets with trimming enabled.
- Supports PNG & JPG spritesheets, But extracts to PNG files **only**.
- **DOESN'T SUPPORT** spritesheets with rotating enabled !
- Licensed under [Apache License V2][4].
- Programmed using LÖVE V0.10.1.
- Works by dragging & dropping sheet files.
- Made spacialy for the awesome game [MoveOrDie][5].

TODO:
=====
- Add rotation support.
- Add custom error screen.
- Add Progress bar.
- ... You can suggest any other features to be include.

How to use:
===========
1. Drop the sheet image and json files into the tool window. 
 * You can drop them separately.
2. After the extraction completes, press any key to open the extracted sheet directory.
3. You can drop another sheets again, but **DON'T** drop multiple sheets.
4. Later you can repack the sheet images using TexturePacker.

[1]: http://love2d.org
[2]: http://lua.org
[3]: https://www.codeandweb.com/texturepacker
[4]: http://www.apache.org/licenses/LICENSE-2.0
[5]: http://www.moveordiegame.com/
[6]: https://github.com/RamiLego4Game/Texture-Unpacker/releases
[screenshot]: https://github.com/RamiLego4Game/Texture-Unpacker/raw/master/Screenshot.png
