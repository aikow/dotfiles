# vim:set et fileencoding=utf8 sts=0 sw=4 ts=4:

"""Helper methods used in UltiSnips snippets."""

import string, vim, re


def complete(tab, opts):
    """
    get options that match with tab

    :param tab: query string
    :param opts: list that needs to be completed

    :return: a string that match with tab
    """
    el = [x for x in tab]
    pat = "".join(list(map(lambda x: x + "\w*" if re.match("\w", x) else x, el)))
    try:
        opts = [x for x in opts if re.search(pat, x, re.IGNORECASE)]
    except:
        opts = [x for x in opts if x.startswith(tab)]
    if not len(opts) or str.lower(tab) in list(map(str.lower, opts)):
        return ""
    cads = "|".join(opts[:5])
    if len(opts) > 5:
        cads += "|..."
    return "({0})".format(cads)


def _parse_comments(s):
    """Parses vim's comments option to extract comment format"""
    i = iter(s.split(","))

    rv = []
    try:
        while True:
            # get the flags and text of a comment part
            flags, text = next(i).split(":", 1)

            if len(flags) == 0:
                rv.append(("OTHER", text, text, text, ""))
            # parse 3-part comment, but ignore those with O flag
            elif "s" in flags and "O" not in flags:
                ctriple = ["TRIPLE"]
                indent = ""

                if flags[-1] in string.digits:
                    indent = " " * int(flags[-1])
                ctriple.append(text)

                flags, text = next(i).split(":", 1)
                assert flags[0] == "m"
                ctriple.append(text)

                flags, text = next(i).split(":", 1)
                assert flags[0] == "e"
                ctriple.append(text)
                ctriple.append(indent)

                rv.append(ctriple)
            elif "b" in flags:
                if len(text) == 1:
                    rv.insert(0, ("SINGLE_CHAR", text, text, text, ""))
    except StopIteration:
        return rv


def get_comment_format():
    """Returns a 4-element tuple (first_line, middle_lines, end_line, indent)
    representing the comment format for the current file.

    It first looks at the 'commentstring', if that ends with %s, it uses that.
    Otherwise it parses '&comments' and prefers single character comment
    markers if there are any.
    """
    commentstring = vim.eval("&commentstring")

    # If a the comment string ends with the text, just strip the %s marker and
    # return.
    if commentstring.endswith("%s"):
        c = commentstring[:-2]
        return (c.rstrip(), c.rstrip(), c.rstrip(), "")

    # Parse the slightly more complex comment string
    comments = _parse_comments(vim.eval("&comments"))
    for c in comments:
        if c[0] == "SINGLE_CHAR":
            return c[1:]
    return comments[0][1:]


def make_box(twidth, bwidth=None):
    b, m, e, i = (s.strip() for s in get_comment_format())
    m0 = m[0] if m else ""
    bwidth_inner = bwidth - 3 - max(len(b), len(i + e)) if bwidth else twidth + 2
    line_1 = b + m + bwidth_inner * m0 + 2 * m0
    nspaces = (bwidth_inner - twidth) // 2
    line_2_start = i + m + " " + " " * nspaces
    line_2_end = " " + " " * (bwidth_inner - twidth - nspaces) + m
    line_3 = i + m + bwidth_inner * m0 + 2 * m0 + e
    return line_1, line_2_start, line_2_end, line_3


def foldmarker():
    "Return a tuple of (open fold marker, close fold marker)"
    return vim.eval("&foldmarker").split(",")


def display_width(str):
    """Return the required over-/underline length for str."""
    try:
        # Respect &ambiwidth and &tabstop, but old vim may not support this
        return vim.strdisplaywidth(str)
    except AttributeError:
        # Fallback
        from unicodedata import east_asian_width

        result = 0
        for c in str:
            result += 2 if east_asian_width(c) in ("W", "F") else 1
        return result


# http://stackoverflow.com/questions/2718196/find-all-chinese-text-in-a-string-using-python-and-regex
def has_cjk(s):
    """Detect if s contains CJK characters."""
    cjk_re = re.compile("[⺀-⺙⺛-⻳⼀-⿕々〇〡-〩〸-〺〻㐀-䶵一-鿃豈-鶴侮-頻並-龎]", re.UNICODE)

    return cjk_re.search(s) is not None
