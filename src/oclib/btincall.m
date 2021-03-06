
/*
 * Copyright (c) 1998 David Stes.
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
 * $Id: btincall.m,v 1.1.1.1 2000/06/07 21:09:25 stes Exp $
 */

#include "config.h"
#include <stdlib.h>
#include <assert.h>
#ifndef __OBJECT_INCLUDED__
#define __OBJECT_INCLUDED__
#include <stdio.h> /* FILE */
#include "Object.h" /* Stepstone Object.h assumes #import */
#endif
#include <ordcltn.h>
#include "node.h"
#include "expr.h"
#include "btincall.h"
#include "type.h"

@implementation BuiltinCall

- funname:aRcvr
{
  funname = aRcvr;
  return self;
}

- funargs:args
{
  funargs = args;
  return self;
}

- (int)lineno
{
  return [funname lineno];
}

- filename
{
  return [funname filename];
}

- gen
{
  [funname gen];
  gc('(');
  if (funargs)
    gcommalist(funargs);
  gc(')');
  return self;
}

- typesynth
{
  type = t_int;
  return self;
}

- synth
{
  [funname synth];
  if (funargs)
    [funargs elementsPerform:_cmd];
  return self;
}

@end
 
