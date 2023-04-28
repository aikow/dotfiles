#!/usr/bin/env python

import re
import sys
from pprint import pprint

import yaml

with open("scripts/colormap.yaml") as file:
    colormap = yaml.safe_load(file)

pprint(colormap)

compiled = [(re.compile(rf"\b{src}\b"), tgt) for src, tgt in colormap.items()]


for colorscheme in sys.argv:
    print(colorscheme)
    with open(colorscheme, "r") as file:
        lines = file.readlines()

    fixed = []
    for line in lines:
        for pat, rep in compiled:
            line = pat.sub(rep, line)
        fixed.append(line)

    with open(colorscheme, "w") as file:
        file.writelines(fixed)