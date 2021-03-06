
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
 * $Id: decl.m,v 1.1.1.1 2000/06/07 21:09:25 stes Exp $
 */

#include "config.h"
#include <stdlib.h>
#include <assert.h>
#ifndef __OBJECT_INCLUDED__
#define __OBJECT_INCLUDED__
#include <stdio.h> /* FILE */
#include "Object.h" /* Stepstone Object.h assumes #import */
#endif
#include "node.h"
#include "decl.h"

@implementation Decl

- hide:sym rename:x
{
  return [self subclassResponsibility:_cmd];
}

- abstrdecl
{
  return [self subclassResponsibility:_cmd];
}

- (BOOL)isinit
{
  return NO;
}

- (BOOL)islistinit
{
  return NO;
}

- (BOOL)isfunproto
{
  return NO;
}

- (BOOL)canforward
{
  return NO;
}

- (BOOL)isscalartype
{
  return NO;
}

- (BOOL)ispointer
{
  return NO;
}

- star
{
  return nil;
}

- dot:sym
{
  return nil;
}

- funcall
{
  return nil;
}

- identifier
{
  return [self subclassResponsibility:_cmd];
}

- genabstrtype
{
  return [self gendef:nil];
}

- gendef:sym
{
  return [self subclassResponsibility:_cmd];
}

- synth
{
  return [self subclassResponsibility:_cmd];
}

- synthinits
{
  return self;
}

- st80
{
  return [self subclassResponsibility:_cmd];
}

- st80inits
{
  return self;
}

@end
 
