# Introduzione

Questo repository contiene diversi esempi di come sommare due array di interi in ASM x86-64, usando i seguenti approcci:
* Somma degli elementi in modo seriale (e.g., classico ciclo for)
* Somma degli elementi usando i registri XMM a 128-bit
* Somma degli elementi usando i registri YMM a 256-bit
* Somma degli elementi usando i registri ZMM a 512-bit
* Somma degli elementi usando i registri ZMM a 512-bit, senza presuppore memoria allineata.

Il codice presente in questo repository è stato scritto durante le riprese del video [**CA-25-011**](https://youtu.be/BoEPaYyo8Eg) del canale YouTube [AFK](https://www.youtube.it/@valerio_afk).

* 📹 [Link al video](https://youtu.be/BoEPaYyo8Eg)

# Guida all'utilizzo

## Prerequisiti
* Computer con processore x86-64 bit.
* Sistema operativo Linux (o qualsiasi altro OS UNIX/UNIX-like che segue la System V ABI Convention).
* NASM.
* GCC (anche clang dovrebbe andare bene, anche se non testato).

## Compilazione & Esecuzione

```sh
$ nasm -f elf64 -g <nome_file>.asm -o <nome_file>.o 
$ gcc -g <nome_file>.o -no-pie -o <nome_file>
$ ./<nome_file>
```

# Contatti

Lasciate un commento al video è un ottimo modo per domande generiche. Domande specifiche sono incorragiate via e-mail, presente nella sezione `Informazioni` sul canale.

# Dati

The data used for this educational repository was taken from the [Day 1 problem proposed by Advent of Code 2024](https://adventofcode.com/2024/day/1).

# Licence Agreement

The code in this repository is released under the terms of [GNU GPLv3 Licence Agreement](https://www.gnu.org/licenses/gpl-3.0.html). A summary of this (and other FOSS licences is provided [here](https://en.wikipedia.org/wiki/Comparison_of_free_and_open-source_software_licenses)).

# Disclaimer

The code provided in this repository is provided AS IS and is intended for educational purposes only.

From the MIT License

`THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE`

![GPLv3](https://img.shields.io/badge/license-GPLv3-brightgreen) [![Instagram Profile](https://img.shields.io/badge/Instagram-%40valerio__afk-ff69b4)](https://www.instagram.com/valerio_afk/) [![YouTube Channel](https://img.shields.io/badge/YouTube-%40valerio__afk-red)](https://www.youtube.it/@valerio_afk)

