import sys
import re
from os import getenv
from dotenv import load_dotenv


def undopreprocess(path):
    def replace_var(m):
        varname = m.group(1)
        return "${" + varname + "}"
    regex = r"\/\*@PRESTART (.*?)\*\/.*?@PREEND\*\/"
    return re.sub(regex, replace_var, path)

filename = sys.argv[1]
outfilename = filename.replace(".preprocess_BTEQ.py",".done.py")
contents = open(filename, "r").read()
# load env vars from .env file
load_dotenv()
newcontents = undopreprocess(contents)
with open(outfilename,"w") as f:
    f.write(newcontents)

