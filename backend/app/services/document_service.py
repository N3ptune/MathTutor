import base64
import io
from dataclasses import dataclass, field

import pymupdf
from PIL import Image

MAX_UPLOAD_BYTES = 10 * 1024 * 1024
MAX_PDF_PAGES = 10
MAX_IMAGE_SIDE = 1600
# A PDF page with fewer characters than this is treated as scanned/handwritten
MIN_TEXT_CHARS_PER_PAGE = 40


class UnsupportedUpload(ValueError):
    pass


@dataclass
class ParsedUpload:
    kind: str  # "pdf" or "image"
    text: str = ""
    images_base64: list[str] = field(default_factory=list)


def detect_kind(data: bytes) -> str:
    """Identify the upload from its bytes rather than trusting the filename."""
    if data[:5] == b"%PDF-":
        return "pdf"
    if data[:8] == b"\x89PNG\r\n\x1a\n" or data[:3] == b"\xff\xd8\xff":
        return "image"
    if data[:6] in (b"GIF87a", b"GIF89a") or (data[:4] == b"RIFF" and data[8:12] == b"WEBP"):
        return "image"
    raise UnsupportedUpload("Upload must be a PDF, PNG, JPEG, GIF or WebP file")


def _encode_image(img: Image.Image) -> str:
    img = img.convert("RGB")
    img.thumbnail((MAX_IMAGE_SIDE, MAX_IMAGE_SIDE))
    buf = io.BytesIO()
    img.save(buf, format="JPEG", quality=85)
    return base64.b64encode(buf.getvalue()).decode("utf-8")


def _parse_pdf(data: bytes) -> ParsedUpload:
    result = ParsedUpload(kind="pdf")
    text_pages = []
    try:
        doc = pymupdf.open(stream=data, filetype="pdf")
    except Exception as e:
        raise UnsupportedUpload("Could not read PDF") from e

    with doc:
        if doc.needs_pass:
            raise UnsupportedUpload("Password-protected PDFs are not supported")
        if doc.page_count > MAX_PDF_PAGES:
            raise UnsupportedUpload(f"PDF has more than {MAX_PDF_PAGES} pages")

        for page in doc:
            page_text = page.get_text().strip()
            if len(page_text) >= MIN_TEXT_CHARS_PER_PAGE:
                text_pages.append(page_text)
            else:
                # Scanned or handwritten page: no usable text layer, fall back to vision
                pix = page.get_pixmap(dpi=110)
                result.images_base64.append(
                    _encode_image(Image.frombytes("RGB", (pix.width, pix.height), pix.samples))
                    if pix.n == 3
                    else _encode_image(Image.open(io.BytesIO(pix.tobytes("png"))))
                )

    result.text = "\n\n".join(text_pages)
    return result


def _parse_image(data: bytes) -> ParsedUpload:
    try:
        img = Image.open(io.BytesIO(data))
        img.load()
    except Exception as e:
        raise UnsupportedUpload("Could not read image") from e
    return ParsedUpload(kind="image", images_base64=[_encode_image(img)])


def parse_upload(data: bytes) -> ParsedUpload:
    if len(data) > MAX_UPLOAD_BYTES:
        raise UnsupportedUpload("File is too large (10 MB max)")
    kind = detect_kind(data)
    return _parse_pdf(data) if kind == "pdf" else _parse_image(data)
