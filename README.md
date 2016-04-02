gbi (cboy modification)
============

Dependencies: rgbasm, rgblink, rgbfix, bash, sdl

Usage: ./gbi myfile.asm a bc de hl

## Building

As with cboy, just run ```make``` in the ```source/``` directory.

### Post-build

You can do 1 of 2 things: Either put the rgbds binaries into bin/, or install everything globally. You'll have to do it yourself. gbi by default is configured to work within the bin/ directory.


## License

It's GPLv3:

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
