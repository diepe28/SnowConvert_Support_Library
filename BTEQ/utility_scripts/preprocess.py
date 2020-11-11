import sys
import re
from os import getenv
from dotenv import load_dotenv

passed_variables = {}

def get_from_args_or_environment(arg_pos, env_variable_name, args):
    if (arg_pos < len(args)):
        return args[arg_pos]
    env_value = getenv(env_variable_name)
    return env_value

def get_argkey(astr):
     if astr.startswith('--param-'):
         astr = astr[8:astr.index('=')]
     return astr

def get_argvalue(astr):
     if astr.startswith('--param-'):
         astr = astr[astr.index('=')+1:]
     return astr

def read_param_args(args):
    script_args = [item for item  in args if item.startswith("--param-")]
    dictionary = {}
    if len(script_args) > 0:
        dictionary = { get_argkey(x) : get_argvalue(x) for x in args}
        if len(dictionary) != 0:
            has_passed_variables = True
            print("Using variables")
            print(dictionary)
    return dictionary
    


def expandvars(path, params, skip_escaped=False):
    """Expand environment variables of form $var and ${var}.
       If parameter 'skip_escaped' is True, all escaped variable references
       (i.e. preceded by backslashes) are skipped.
       Unknown variables are set to 'default'. If 'default' is None,
       they are left unchanged.
    """
    def replace_var(m):
        return "done"
    def replace_var(m):
        varname = m.group(3) or m.group(2)
        passvalue = params.get(varname, None)
        if passvalue is None:
            return "/*@PRESTART "+varname+"*/" + getenv(varname, m.group(0)) + "/*@PREEND*/"
        else:
            return passvalue
    reVar = (r'(?<!\)' if skip_escaped else '') + r'(\$|\&)(\w+|\{([^}]*)\})'
    return re.sub(reVar, replace_var, path)



def expandvar(str):
    return expandvars(str,passed_variables)

filename = sys.argv[1]
outfilename = filename + ".preprocess.bteq" 
contents = open(filename, "r").read()
# load env vars from .env file
load_dotenv()
newcontents = expandvars(contents,{})
with open(outfilename,"w") as f:
    f.write(newcontents)

