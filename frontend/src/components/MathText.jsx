import { useMemo } from "react";
import katex from "katex";
import "katex/dist/katex.min.css";

// Explicit delimiters: $$..$$, \[..\], \(..\), $..$
const DELIMITED = /\$\$([\s\S]+?)\$\$|\\\[([\s\S]+?)\\\]|\\\(([\s\S]+?)\\\)|\$([^$\n]+?)\$/g;

// Plain-text math with no delimiters: sqrt(...), x^2, x^(n+1), x_1, \frac{..}{..}, etc.
const BARE =
  /\\[a-zA-Z]+(?:\{[^{}]*\})*|sqrt\([^()]*\)|(?:\([^()]*\)|[A-Za-z0-9]+)\^(?:\([^()]*\)|\{[^{}]*\}|-?[A-Za-z0-9]+)|\b[A-Za-z]_(?:\{[^{}]*\}|[A-Za-z0-9]+)/g;

function bareToLatex(src) {
  return src.replace(/sqrt\(([^()]*)\)/g, "\\sqrt{$1}").replace(/\^\(([^()]*)\)/g, "^{$1}");
}

function render(tex, displayMode) {
  return katex.renderToString(tex, { displayMode, throwOnError: false, output: "html" });
}

function toHtml(text) {
  const escape = (s) =>
    s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/\n/g, "<br/>");

  const renderBare = (chunk) => {
    let out = "";
    let last = 0;
    for (const m of chunk.matchAll(BARE)) {
      out += escape(chunk.slice(last, m.index)) + render(bareToLatex(m[0]), false);
      last = m.index + m[0].length;
    }
    return out + escape(chunk.slice(last));
  };

  let html = "";
  let last = 0;
  for (const m of text.matchAll(DELIMITED)) {
    html += renderBare(text.slice(last, m.index));
    const display = m[1] !== undefined || m[2] !== undefined;
    html += render((m[1] ?? m[2] ?? m[3] ?? m[4]).trim(), display);
    last = m.index + m[0].length;
  }
  return html + renderBare(text.slice(last));
}

export default function MathText({ children, className, as = "span" }) {
  const Tag = as;
  const html = useMemo(() => toHtml(String(children ?? "")), [children]);
  return <Tag className={className} dangerouslySetInnerHTML={{ __html: html }} />;
}
