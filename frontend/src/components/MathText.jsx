import { useMemo } from "react";
import katex from "katex";
import "katex/dist/katex.min.css";

// Explicit delimiters: $$..$$, \[..\], \(..\), $..$
const DELIMITED = /\$\$([\s\S]+?)\$\$|\\\[([\s\S]+?)\\\]|\\\(([\s\S]+?)\\\)|\$([^$\n]+?)\$/g;

// Plain-text math with no delimiters, e.g. "lim_{x->0} (sin(3x) - 3x) / x^3", "x^2 + 3x = 4".
// Only single letters, numbers, parenthesised groups and known function names count as
// terms, so ordinary words never match; a run must also contain an operator or script.
const PAREN = String.raw`\((?:[^()]|\([^()]*\))*\)`;
const SCRIPT = String.raw`(?:\^(?:\{[^{}]*\}|${PAREN}|-?[A-Za-z0-9]+)|_(?:\{[^{}]*\}|[A-Za-z0-9]+))`;
const FUNCS = "arcsin|arccos|arctan|sinh|cosh|tanh|sin|cos|tan|sec|csc|cot|log|ln|exp|sqrt";
const TERM = String.raw`(?:\\[a-zA-Z]+(?:\{[^{}]*\})*|lim(?![A-Za-z])(?:_\{[^{}]*\})?|(?:${FUNCS})${PAREN}|${PAREN}|\d+(?:\.\d+)?[A-Za-z]?|[A-Za-z](?![A-Za-z]))${SCRIPT}*`;
const OP = String.raw`\s*(?:->|<=|>=|[-+*/=<>])\s*`;
const BARE = new RegExp(String.raw`(?<![A-Za-z0-9_\\.])${TERM}(?:(?:${OP}|\s*(?=\())${TERM})*`, "g");
const HAS_MATH = new RegExp(String.raw`[\^_=+*/<>\\-]|lim(?![A-Za-z])|(?:${FUNCS})\(`);

const FRAC_SIDE = String.raw`((?:(?:${FUNCS})\s*)?${PAREN}|[A-Za-z0-9.]+${SCRIPT}*)`;
const FRAC = new RegExp(String.raw`${FRAC_SIDE}\s*/\s*${FRAC_SIDE}`, "g");
const FUNC_NAME = new RegExp(String.raw`(?<!\\)\b(${FUNCS}|lim)(?![A-Za-z])`, "g");

const unwrap = (g) => (g.startsWith("(") && g.endsWith(")") ? g.slice(1, -1) : g);

function bareToLatex(src) {
  return src
    .replace(FRAC, (_, n, d) => "\\frac{" + unwrap(n) + "}{" + unwrap(d) + "}")
    .replace(/sqrt\(((?:[^()]|\([^()]*\))*)\)/g, "\\sqrt{$1}")
    .replace(FUNC_NAME, "\\$1 ")
    .replace(/->/g, "\\to ")
    .replace(/<=/g, "\\le ")
    .replace(/>=/g, "\\ge ")
    .replace(/\*/g, "\\cdot ")
    .replace(/\^\(([^()]*)\)/g, "^{$1}");
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
      if (!HAS_MATH.test(m[0])) continue;
      out += escape(chunk.slice(last, m.index)) + render(bareToLatex(m[0].trim()), false);
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
