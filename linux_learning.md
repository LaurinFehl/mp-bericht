# Linux Learning Log

Commands and shell concepts, logged on first use in this project.

---

## `cd`
**What it does:** Changes the current directory.
**Example:** `cd /home/laurin/Dokumente/bericht`
**First used:** 2026-11-10, switching into the report folder before searching for the new LED markdown file.

## `find`
**What it does:** Searches for files in a directory tree.
- `-iname "*led_sil*"`: match the name, case-insensitive, `*` is a wildcard
- `-not -path "./.git/*"`: skip everything inside `.git`
- `-exec cmd {} \;`: run `cmd` on every match, `{}` is replaced by the file path, `\;` ends the command
**Example:** `find . -iname "*led_sil*" -not -path "./.git/*" -exec ls -la {} \;`
**First used:** 2026-11-10, locating the updated `LED_SIL_Erklaerung.md`.

## `ls`
**What it does:** Lists files.
- `-l`: long format (permissions, size, date)
- `-a`: also show hidden files
- `--time-style=long-iso`: dates as `2026-11-10 18:51`
**Example:** `ls -la --time-style=long-iso LED_SIL_Erklaerung.md`
**First used:** 2026-11-10, checking size and date of the new markdown file.

## `||` (OR operator)
**What it does:** Runs the right-hand command only if the left one **failed**.
**Example:** `ls linux_learning.md || echo "no learning log yet"`
**First used:** 2026-11-10, checking whether this log already existed.

## `&&` (AND operator)
**What it does:** Runs the right-hand command only if the left one **succeeded**.
**Example:** `cd /some/folder && ls`
**First used:** 2026-11-10, only searching after `cd` into the project worked.

## `;` (command separator)
**What it does:** Runs commands one after another, no matter if the previous one failed.
**Example:** `latexmk ... ; echo "exit $?"`
**First used:** 2026-11-10, printing the exit code after the LaTeX build.

## `$?`
**What it does:** Holds the exit code of the last command (`0` = success, anything else = error).
**Example:** `latexmk -pdf thesis.tex; echo "exit $?"`
**First used:** 2026-11-10, checking whether the PDF build succeeded.

## `2>/dev/null`
**What it does:** Throws away error messages. `2` is the error output, `/dev/null` is a "black hole" file.
**Example:** `ls linux_learning.md 2>/dev/null`
**First used:** 2026-11-10, hiding the "file not found" message when checking for this log.

## `>` and `2>&1` (redirects)
**What it does:** `>` writes the normal output into a file (overwriting it). `2>&1` sends the error output to the same place as the normal output.
**Example:** `latexmk -pdf thesis.tex > build.log 2>&1`
**First used:** 2026-11-10, saving the whole LaTeX build output into a log file.

## `|` (pipe)
**What it does:** Passes the output of the left command as input to the right command.
**Example:** `grep -rn "cite" TeXFiles/ | cut -c1-120`
**First used:** 2026-11-10, shortening long search results.

## `grep`
**What it does:** Searches text for a pattern.
- `-n`: show line numbers
- `-r`: search all files in a folder recursively
- `-A3`: also show 3 lines **after** each match
- `-E`: extended regex, so `a|b` means "a or b"
- `-i`: ignore upper/lower case
- `-c`: only count matches
- `-q`: quiet, print nothing, only set the exit code (`0` = found), handy in `if`/`&&`
- `-a`: treat the file as text even if grep thinks it is binary (e.g. a LaTeX log in ISO-8859 with umlauts; without `-a` grep silently printed nothing), added 2026-11-16
**Example:** `grep -n -A3 "item24signale\|ws2812btds" bibliography.bib`
**First used:** 2026-11-10, checking whether the bib entries from the markdown file exist.

## `cut`
**What it does:** Cuts out parts of each line. `-c1-120` keeps only characters 1 to 120.
**Example:** `grep -rn "cite" TeXFiles/ | cut -c1-120`
**First used:** 2026-11-10, keeping long LaTeX lines readable in the terminal.

## `tail`
**What it does:** Shows the end of a file.
- `-n 5`: the last 5 lines
- `-n +138`: everything **from** line 138 on
**Example:** `tail -n 5 TeXFiles/400_EntwickelteMethoden.tex`
**First used:** 2026-11-10, checking that nothing follows the LED section in the chapter file.

## `echo`
**What it does:** Prints text.
**Example:** `echo "--- end of chapter file:"`
**First used:** 2026-11-10, adding headings between outputs of several commands.

## `diff -u` and `<( ... )` (process substitution)
**What it does:** `diff -u a b` shows the differences between two files (`-` = only in a, `+` = only in b). `<(cmd)` lets you use a command's output as if it were a file.
**Example:** `diff -u old.tex <(tail -n +138 TeXFiles/400_EntwickelteMethoden.tex)`
**First used:** 2026-11-10, trying to find my own edits in the LED section (the old copy was gone).

## `awk`
**What it does:** Processes text line by line. `NR` is the current line number, `$0` the whole line.
**Example:** `awk 'NR>=138 {print NR": "$0}' file.tex` (print all lines from 138 on, with line numbers)
**First used:** 2026-11-10, listing only the LED section to search it for `\cite` and TODOs.

## `sed -n 'Np'`
**What it does:** Prints exactly line N. `-n` = print nothing by default, `p` = print this line.
**Example:** `sed -n '155p' TeXFiles/400_EntwickelteMethoden.tex`
**First used:** 2026-11-10, reading the color paragraph I had written myself in full.

## `python3 - <<'E' ... E` (heredoc)
**What it does:** A heredoc passes several lines of text as input to a command. Here the lines between `<<'E'` and `E` are a Python script, and `-` tells Python to read the script from that input. The quotes around `'E'` stop the shell from changing `$` or `\` inside.
**Example:**
```bash
python3 - <<'E'
print("hello")
E
```
**First used:** 2026-11-10, replacing the whole LED section in the chapter file.

## `rm -rf` and `mkdir -p`
**What it does:** `rm -rf folder` deletes a folder with all contents, without asking (careful!). `mkdir -p folder` creates a folder, including missing parent folders, and doesn't complain if it already exists.
**Example:** `rm -rf out && mkdir -p out`
**First used:** 2026-11-10, starting with an empty build folder in the scratchpad.

## `latexmk`
**What it does:** Builds a LaTeX document and automatically runs pdflatex, biber etc. as often as needed.
- `-pdf`: build a PDF with pdflatex
- `-interaction=nonstopmode`: don't stop and wait for input on errors
- `-file-line-error`: show errors as `file:line: message`
- `-outdir=folder`: write all output there instead of the project folder
**Example:** `latexmk -pdf -interaction=nonstopmode -outdir=/tmp/out thesis.tex`
**First used:** 2026-11-10, test-building the report without colliding with the VS Code build.

## `pdfinfo`
**What it does:** Shows information about a PDF (pages, size, ...).
**Example:** `pdfinfo thesis.pdf | grep Pages`
**First used:** 2026-11-10, checking the page count after the build.

## `pdftotext`
**What it does:** Extracts the text from a PDF. `-f N -l N` = only page N, `-` at the end = print to the terminal.
**Example:** `pdftotext -f 23 -l 23 thesis.pdf -`
**First used:** 2026-11-10, finding which pages contain the LED section.

## `pdftoppm`
**What it does:** Renders PDF pages as images.
- `-f 23 -l 34`: first and last page
- `-r 45`: resolution in dpi
- `-png`: PNG format
**Example:** `pdftoppm -f 23 -l 34 -r 45 -png thesis.pdf page`
**First used:** 2026-11-10, rendering the LED pages for a visual check.

## `magick montage`
**What it does:** ImageMagick tool that puts several images together into one grid image.
- `-tile 6x2`: 6 columns, 2 rows (if there are more images, it creates several files)
- `-geometry +4+4`: 4 px gap between images
**Example:** `magick montage page-*.png -tile 6x2 -geometry +4+4 overview.png`
**First used:** 2026-11-10, making an overview of all LED pages.

## `$( ... )` and `set --`
**What it does:** `$(cmd)` inserts the output of a command. `set -- $R` splits the text in `R` into the positional variables `$1`, `$2`, ...
**Example:** `R=$(echo "23 34"); set -- $R; echo $1` prints `23`
**First used:** 2026-11-10, passing the first and last LED page from Python to `pdftoppm`.

## `for ... in ...; do ...; done` (loop)
**What it does:** Repeats commands once for every value in a list. The current value is in the loop variable (here `$p`).
**Example:** `for p in "SK6812" "Lauflicht"; do grep -c "$p" file.tex; done`
**First used:** 2026-11-10, counting several old and new text markers after a save conflict in VS Code.

## `printf`
**What it does:** Prints formatted text, similar to `echo` but with placeholders. `%s` is replaced by a string, `%-40s` pads it to 40 characters (left-aligned), `\n` is a line break.
**Example:** `printf "%-40s %s\n" "Lauflicht" "7"`
**First used:** 2026-11-10, printing the marker counts as aligned columns.

## `$(( ... ))` (arithmetic)
**What it does:** Calculates integers in the shell.
**Example:** `echo $(( 33 + 1 ))` prints `34`
**First used:** 2026-11-10, rendering one extra page after the LED section.

## `head`
**What it does:** Shows the beginning of a file or of a command's output. `-n 5` or just `head` (default: 10 lines). The counterpart of `tail`.
**Example:** `grep -n "label" file.tex | head`
**First used:** 2026-11-11, keeping the search output short while checking the build log for chapter 5.

## `seq`
**What it does:** Prints a sequence of numbers, one per line. `seq 1 43` prints 1 to 43. Often used in a `for` loop together with `$( )`.
**Example:** `for i in $(seq 1 $N); do pdftotext -f $i -l $i thesis.pdf - | grep -q "sil reset" && echo "Seite $i"; done`
**First used:** 2026-11-11, finding the PDF page with the LED test matrix by searching every page.

## `which`
**What it does:** Shows the full path of a program, i.e. checks whether a command is installed and where it lives. Prints nothing (and fails) if the command is not found.
**Example:** `which makeglossaries` prints `/usr/bin/makeglossaries`
**First used:** 2026-11-11, checking whether the tool for the list of acronyms is installed.

## `tr`
**What it does:** Translates (replaces) characters. `tr '\n' ' '` replaces every line break with a space, so a multi-line output becomes one line.
**Example:** `pdftotext -f 7 -l 7 thesis.pdf - | head -3 | tr '\n' ' '`
**First used:** 2026-11-11, printing the first lines of each PDF page on a single line to see where the list of acronyms appears.

## `file`
**What it does:** Looks at the content of a file (not its name) and says what type it really is, e.g. `PNG image data, 563 x 615`. Useful when an extension like `.png` might be wrong.
**Example:** `file Figures/000-misc/platzhalter.png`
**First used:** 2026-11-13, checking that the placeholder image is a real PNG before using it for the figures in chapter 6.

## `sed -i 'N{/muster/d}'`
**What it does:** Edits a file directly ("in place", `-i`) instead of only printing the result. `32{...}` limits the command to line 32, `/muster/` checks that the line contains the pattern, and `d` deletes the line. So the line is only deleted if it is really the expected one.
**Example:** `sed -i '32{/FIgures\/400-em\/dronecad_arme/d}' TeXFiles/004_Figures.tex`
**First used:** 2026-11-16, removing a duplicate `\dronearme` definition with a wrong path that broke the build.

## `magick` (resize, crop, identify, append)
**What it does:** ImageMagick's main command for editing images.
- `magick in.jpg -auto-orient -resize 700x700 out.jpg`: turns the image upright using its EXIF rotation info, then shrinks it to fit into 700x700 px
- `-crop 360x110+1430+425 +repage`: cuts out a 360x110 px rectangle starting at x=1430, y=425; `+repage` forgets the old canvas position
- `-gravity NorthEast -crop 38%x50%+0+0`: crops relative to the top right corner, sizes in percent
- `magick a.png b.png -append out.png`: stacks images vertically (`+append` = side by side)
- `magick identify -format "%f %wx%h orient=%[EXIF:Orientation]\n" *.jpg`: prints file name, size and EXIF rotation (`6` = must be turned 90° clockwise)
**Example:** `magick identify -format "%f %wx%h\n" Figures/600-erg/*.png`
**First used:** 2026-11-16, previewing the new photos for chapter 6, reading the slicer masses and finding out why the phone photos appeared sideways in the PDF.

## `sed 's/alt/neu/'` with groups
**What it does:** Replaces text. `\(...\)` remembers a part of the match, `\1` inserts it again in the replacement. With `-i` the file is changed directly.
**Example:** `sed -i 's/{\\falltest\([ABC]\)}/[angle=-90]{\\falltest\1}/' file.tex` (works for A, B and C in one go)
**First used:** 2026-11-16, adding the rotation option to the three drop-test photos at once.

## `cat -n`
**What it does:** Prints a whole file. `-n` adds line numbers in front of every line.
**Example:** `cat -n TeXFiles/500_Evaluation.tex`
**First used:** 2026-11-16, reading every chapter with line numbers for the correction list.

## `wc -l`
**What it does:** Counts lines (`wc` = word count, `-l` = only lines). With several files it also prints a total.
**Example:** `wc -l thesis.tex TeXFiles/*.tex`
**First used:** 2026-11-16, checking how long each chapter file is before reading the whole report.

## `sort` and `uniq -c`
**What it does:** `sort` sorts lines alphabetically (`-u` drops duplicates, `-rn` sorts by number, largest first). `uniq -c` merges identical neighbouring lines and counts them, so it is almost always used after `sort`.
**Example:** `grep -rhoE "\\cite\{[^}]+\}" TeXFiles | sort | uniq -c`
**First used:** 2026-11-16, counting how often each source is cited.

## `cmp`
**What it does:** Compares two files byte by byte. Prints nothing and exits with `0` if they are identical, so it works well with `&&`.
**Example:** `cmp a.md b.md && echo "identisch"`
**First used:** 2026-11-16, checking whether two copies of `report_agent.md` were the same.

## `git status --short` and `git branch`
**What it does:** `git status --short` lists changed (`M`) and new (`??`) files in a compact form. `git branch` lists all branches, the current one has a `*`.
**Example:** `git status --short; git branch`
**First used:** 2026-11-16, checking that the work happens on the new branch `korrektur`.

## `grep -o` and `grep -h`
**What it does:** `-o` prints only the matching part of a line instead of the whole line. `-h` hides the file name in front of each match when searching several files.
**Example:** `grep -rhoE "\\label\{fig:[^}]+\}" TeXFiles`
**First used:** 2026-11-16, collecting all figure labels to find ones that are never referenced.

## `mv -n`
**What it does:** Moves or renames a file. `-n` (no-clobber) never overwrites an existing target file, so nothing gets lost by accident.
**Example:** `mv -n Figures/000-misc/frost_logo_neu Figures/000-misc/frost_logo_neu.png`
**First used:** 2026-11-16, adding the missing `.png` extension to the FRoST logo so LaTeX recognises the file type.
