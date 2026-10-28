#!/usr/bin/env python3
"""aerc multipart converter: plain-text body -> HTML with the Gmail HTML signature.

Usage:
    html_signature.py           read a text/plain body on stdin, print text/html
    html_signature.py --plain   print the plain-text signature (used by templates)

The plain-text signature card (name .. website) is located in the body and
replaced by the HTML signature table. A sign-off paragraph directly above it
that ends with the first name (e.g. "Met vriendelijke groeten,\\nIlya") is
moved into the table, like the Gmail signature does.
"""

import html
import re
import sys

FIRST_NAME = "Ilya"
EMAIL = "ilya.quateau@humansintheloop.be"
WEBSITE = "humansintheloop.be"
DEFAULT_SIGNOFF = ["Met vriendelijke groeten,", FIRST_NAME]
CARD = [
    "Ilya Quateau",
    "AI Engineer",
    EMAIL,
    "",
    "Humans In The Loop",
    WEBSITE,
]

SIGNATURE_HTML = """<div data-smartmail="gmail_signature"><table>
    <tbody><tr>
        <td>{signoff}<img src="https://humansintheloop.be/assets/ems/mark.jpg" width="48px" height="46px" alt="Humans In The Loop Logo" style="width:48px;height:46px;max-width:48px">
        </td>
    </tr>
    <tr>
        <td style="height:24px"> </td>
    </tr>
    <tr>
        <td style="font-size:16px;font-weight:600;font-family:verdana,sans-serif">Ilya Quateau</td>
    </tr>
    <tr>
        <td style="color:rgb(0,0,0);font-size:12px;font-family:verdana,sans-serif">AI Engineer</td>
    </tr>
    <tr>
        <td style="color:rgb(0,0,0);font-size:12px;font-family:verdana,sans-serif"><a href="mailto:{email}" target="_blank">{email}</a></td>
    </tr>
    <tr>
        <td style="height:24px"> </td>
    </tr>
    <tr>
        <td style="color:rgb(0,0,0);font-size:12px;font-family:verdana,sans-serif;font-weight:800">Humans In The Loop</td>
    </tr>
    <tr>
        <td style="font-size:12px;font-family:verdana,sans-serif">
            <a style="color:rgb(0,0,0);font-size:12px;font-family:verdana,sans-serif" href="https://{website}" target="_blank">{website}</a>
        </td>
    </tr>
</tbody></table></div>"""

BLOCKQUOTE_OPEN = (
    '<blockquote class="gmail_quote" '
    'style="margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">'
)

LINK_RE = re.compile(
    r"(?P<url>https?://[^\s<>\"]+[^\s<>\".,;:!?)\]])"
    r"|(?P<email>[\w.+-]+@[\w-]+(?:\.[\w-]+)+)"
)
QUOTE_RE = re.compile(r"^((?:> ?)+)")


def plain_signature() -> str:
    return "\n".join(DEFAULT_SIGNOFF + [""] + CARD)


def linkify(escaped: str) -> str:
    def repl(m: re.Match) -> str:
        if m.group("url"):
            return f'<a href="{m.group("url")}">{m.group("url")}</a>'
        return f'<a href="mailto:{m.group("email")}">{m.group("email")}</a>'

    return LINK_RE.sub(repl, escaped)


def text_to_html(lines: list[str]) -> str:
    """Render plain-text lines, turning '>' quoted lines into nested blockquotes."""
    out = []
    depth = 0
    for line in lines:
        m = QUOTE_RE.match(line)
        level = m.group(1).count(">") if m else 0
        content = line[m.end():] if m else line
        while depth < level:
            out.append(BLOCKQUOTE_OPEN)
            depth += 1
        while depth > level:
            out.append("</blockquote>")
            depth -= 1
        out.append(linkify(html.escape(content, quote=False)) + "<br>")
    out.extend("</blockquote>" for _ in range(depth))
    return "\n".join(out)


def find_card(lines: list[str]) -> int:
    """Index of the first unquoted signature card in lines, or -1."""
    n = len(CARD)
    for i in range(len(lines) - n + 1):
        if [line.rstrip() for line in lines[i:i + n]] == CARD:
            return i
    return -1


def split_signoff(before: list[str]) -> tuple[list[str], list[str]]:
    """Split off the sign-off paragraph (ending in the first name) above the card."""
    end = len(before)
    while end and not before[end - 1].strip():
        end -= 1
    start = end
    while start and before[start - 1].strip():
        start -= 1
    paragraph = before[start:end]
    if paragraph and paragraph[-1].strip() == FIRST_NAME:
        return before[:start], paragraph
    return before, []


def signature_html(signoff: list[str]) -> str:
    rendered = "".join(html.escape(line.strip(), quote=False) + "<br>" for line in signoff)
    if rendered:
        rendered += "<br>"
    return SIGNATURE_HTML.format(signoff=rendered, email=EMAIL, website=WEBSITE)


def convert(body: str) -> str:
    lines = body.replace("\r\n", "\n").split("\n")
    if lines and lines[-1] == "":
        lines.pop()
    idx = find_card(lines)
    if idx == -1:
        content = text_to_html(lines)
    else:
        before, signoff = split_signoff(lines[:idx])
        after = lines[idx + len(CARD):]
        while before and not before[-1].strip():
            before.pop()
        parts = []
        if before:
            parts.append(text_to_html(before) + "\n<br>")
        parts.append(signature_html(signoff))
        if after:
            parts.append(text_to_html(after))
        content = "\n".join(parts)
    return (
        '<html><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8">'
        f'</head><body><div dir="ltr">\n{content}\n</div></body></html>\n'
    )


def main() -> None:
    if sys.argv[1:] == ["--plain"]:
        print(plain_signature())
        return
    sys.stdout.write(convert(sys.stdin.read()))


if __name__ == "__main__":
    main()
