
/*
 * Copyright (c) 1999 David Stes.
 *
 * This library is free software; you can redistribute it and/or modify it
 * under the terms of the GNU Library General Public License as published 
 * by the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 * $Id: funwrap.h,v 1.1.1.1 2000/06/07 21:09:26 stes Exp $
 */

typedef struct { 
  char *funname;
  id (*efun)(id);
} FUNWRAP;

extern FUNWRAP stdiofunwraps[];
extern FUNWRAP ctypefunwraps[];
extern FUNWRAP stringfunwraps[];
extern FUNWRAP stdlibfunwraps[];

@interface Funwrap : Def
{
   id funname;
   id (*efun)(id);
}

+ defwrapsfor:(FUNWRAP*)funwraps;

- (BOOL)isfundef;
- (BOOL)isextern;
- (BOOL)isstatic;
- fcall:aList;

- value;
- defval:v;

@end
 
