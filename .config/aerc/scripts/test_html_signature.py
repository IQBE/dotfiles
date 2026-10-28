import subprocess
import sys
import unittest
from pathlib import Path

import html_signature as hs

SCRIPT = Path(__file__).with_name("html_signature.py")


def body_with_signature(text: str, signoff: str = "Met vriendelijke groeten,\nIlya") -> str:
    card = "\n".join(hs.CARD)
    return f"{text}\n\n{signoff}\n\n{card}\n"


class PlainSignatureTest(unittest.TestCase):
    def test_has_no_delimiter_and_uses_full_email(self):
        sig = hs.plain_signature()
        self.assertNotIn("-- ", sig)
        self.assertIn("ilya.quateau@humansintheloop.be", sig)
        self.assertNotIn("\nilya@humansintheloop.be", sig)

    def test_cli_plain_matches_function(self):
        out = subprocess.run(
            [sys.executable, str(SCRIPT), "--plain"], capture_output=True, text=True, check=True
        ).stdout
        self.assertEqual(out, hs.plain_signature() + "\n")


class ConvertTest(unittest.TestCase):
    def test_signature_replaced_by_html_table(self):
        out = hs.convert(body_with_signature("Dag Stijn,\n\nAlles ok."))
        self.assertIn('data-smartmail="gmail_signature"', out)
        self.assertIn('href="mailto:ilya.quateau@humansintheloop.be"', out)
        self.assertIn(">ilya.quateau@humansintheloop.be</a>", out)
        self.assertIn("mark.jpg", out)
        self.assertNotIn("Ilya Quateau<br>", out)  # plain card is gone
        self.assertNotIn("-- ", out)

    def test_signoff_moved_into_table(self):
        out = hs.convert(body_with_signature("Hi,", signoff="Kind regards,\nIlya"))
        self.assertIn("<td>Kind regards,<br>Ilya<br><br><img", out)
        self.assertEqual(out.count("Kind regards,"), 1)

    def test_paragraph_not_ending_in_name_stays_in_body(self):
        card = "\n".join(hs.CARD)
        out = hs.convert(f"Some text\nmore text\n\n{card}\n")
        self.assertIn("Some text<br>", out)
        self.assertIn("<td><img", out)

    def test_body_escaped_and_linkified(self):
        out = hs.convert(body_with_signature("a < b & see https://example.com/x?a=1&b=2."))
        self.assertIn("a &lt; b &amp; see", out)
        self.assertIn('<a href="https://example.com/x?a=1&amp;b=2">', out)
        self.assertIn("</a>.<br>", out)

    def test_quote_after_signature_becomes_blockquote(self):
        body = body_with_signature("Reply text") + "On Mon, Stijn wrote:\n> hello\n> > older\n"
        out = hs.convert(body)
        sig_end = out.index("</table></div>")
        self.assertGreater(out.index("On Mon, Stijn wrote:"), sig_end)
        self.assertEqual(out.count('class="gmail_quote"'), 2)
        self.assertEqual(out.count("</blockquote>"), 2)
        self.assertIn("hello<br>", out)
        self.assertIn("older<br>", out)

    def test_quoted_signature_is_not_replaced(self):
        quoted = "\n".join("> " + line if line else ">" for line in hs.CARD)
        out = hs.convert(f"Text\n\n{quoted}\n")
        self.assertNotIn("gmail_signature", out)

    def test_without_signature_plain_conversion(self):
        out = hs.convert("Just text\n")
        self.assertIn("Just text<br>", out)
        self.assertNotIn("gmail_signature", out)

    def test_crlf_input(self):
        out = hs.convert(body_with_signature("Hi").replace("\n", "\r\n"))
        self.assertIn("gmail_signature", out)


if __name__ == "__main__":
    unittest.main()
