# Esther Parallel Edition
### An English Alignment of the Hebrew and Greek Text Traditions


---

## Overview

This project presents a verse-aligned English parallel edition of the Book of Esther in its three principal textual traditions:

- The **Masoretic Text (MT)**
- The **Greek Septuagint (LXX)**
- The **Alpha Text (AT)**

The short book of Esther is quite different and substantially longer in the Greek Septuagint (LXX) compared with the Hebrew Masoretic Text (MT). Traditionally Roman Catholic and Eastern Orthodox Bibles have included the longer text of the Septuagint while Bibles used by Protestants generally have used the shorter Masoretic Text. The differences are significant. The Hebrew text is remarkable in that God is nowhere explicitly mentioned, and although his action is everywhere evident it is left to the reader to understand this. The additions in the Greek text, on the other hand, are very explicit about the hand of God.

**Other text traditions**

There is no single authoritative ``Septuagint'' since different ancient manuscripts have their own variants, mostly trivial changes of spelling or similar minor, inconsequential variations. There is, however, another significant variant of the text of Esther called the Alpha Text (or AT) that is found four medieval manuscripts. This has been published (in the original Greek) in Hanhart's {\textit Septuaginta:
Vetus Testamentum Graecum Auctoritate Academiae Scientiarum Gottingensis editum VIII.3: Esther} [Göttingen:
Vandenhoeck \& Ruprecht, 1966].

Until now the only readily available source for English speakers to access this text has been the excellent New English Translation of the Septuagint (NETS) Esther. This can be found at https://ccat.sas.upenn.edu/nets/edition/17-esther-nets.pdf. Although it is readily accessible and liberally licensed, the NETS Esther is protected by copyright meaning it cannot be freely redistributed or used to make derivative works without jumping through the hoops necessary to obtain copyright permission. For many independent scholars that is prohibitive. For this document, I have produced (with the assistance of generative AI) a new translation of the Alpha text from Hanhart's Greek text (as obtained from a Logos Bible software module) under a Creative Commons Attribution licence. You are essentially free to do whatever you like with the text. (But please let me know if you intend to create a commercial product from it.)

Discussions of the historical background of these three text traditions are beyond the scope of this work. Interested readers may wish to consult M.V. Fox. 1990. “The Alpha Text of the Greek Esther.” Textus, 15, Pp. 27-54.

This document presents these three textual traditions side by side using the World English Bible (WEB) translation for the first two columns and my own for the third. The left column translates the Hebrew MT and the right hand column the Greek LXX. The WEB translation was selected because it is in the public domain, meaning this document can also be made freely available and free to copy.

---

## Publication

The stable, citable edition is available via Zenodo:

> Prideaux, Glen. *Esther Parallel Edition: An English Alignment of
the Hebrew and Greek Text Traditions.* Zenodo, 2026.  
> 

This repository contains the source files and build system used to generate the published edition.

---

## Textual Sources

Masoretic and Septuagint traditions are represented through:

- **World English Bible (WEB)**  
  USFM digital distribution via eBible.org. Since the WEB is also available in a British English edition there are two corresponding versions of this parallel edition. 
Original USFM source files obtained from:
https://ebible.org

The Greek AT text was obtained from a Logos module of Robert Hanhart's
Göttingen Edition.

---

## Methodology

- Alignment is performed at the verse level.
- Material absent from one tradition is explicitly marked.
- No attempt is made to harmonise or reconstruct a hypothetical original text.
- The edition is documentary and comparative in purpose.

The work is intended as a research and teaching tool in:

- Textual criticism
- Septuagint studies
- Hebrew Bible literary history
- Digital humanities

---

## Repository Structure
```
sources/      → Original USFM source files
data/         → Mapping table, LXX and MT verse by verse
build/        → Generated files
scripts/      → Parsing and conversion scripts
tex/          → LaTeX sources
```
---

## Building the Edition

Requirements:

- Python 3.x
- XeLaTeX
- Make

To build:
```
make
```

---

## Citation

If you use this edition, please cite the Zenodo publication:

> Prideaux, Glen. *Esther Parallel Edition: An English Alignment of
> the Hebrew and Greek Text Traditions.* Zenodo, 2026.

---

## License

This project is licensed under:

Creative Commons Attribution 4.0 International (CC BY-NC 4.0)

You are free to share and adapt the work with attribution.

---

## Contact

Feedback, corrections, and scholarly comments are welcome via GitHub
Issues.

