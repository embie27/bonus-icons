import fontforge
import os

font = fontforge.font()
used_unicodes = []
for file in os.listdir("./svgs"):
    if not file.endswith("svg"):
        raise Exception(f"error: {file} is not an svg file")

    unicode = ""
    name = ""
    try:
        unicode, name = file[:-4].split("%%")
    except ValueError:
        raise Exception(f"error: {file} does not specify unicode codepoint and name seperated by '%%'")
    try:
        unicode = int(unicode)
    except ValueError:
        raise Exception(f"error: {file} does not specify a valid unicode codepoint")
    
    if unicode in used_unicodes:
        raise Exception(f"error: unicode codepoint {unicode} used multiple times")
    used_unicodes.append(unicode)

    font.createChar(unicode, name).importOutlines(f"svgs/{file}")
    
font.generate("bonus-icons.ttf")
