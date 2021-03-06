
/*
 * Computer Algebra Kit (c) 1993,98 by Comp.Alg.Objects.  All Rights Reserved.
 * $Id: osrspolc.h,v 1.6 2000/10/12 14:40:26 stes Exp $
 */

/*
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
 */

#ifndef __obj_varspsrecdegsps_polynomial_header__
#define __obj_varspsrecdegsps_polynomial_header__

#include "srspolc.h"

@interface obj_varspsrecdegsps_polynomial : varspsrecdegsps_polynomial
{
  id scalarZero;
  id termZero;
  id monomialZero;
  id terms;
}

- check;
+ new;
- _setUpScalarZero:aScalar;
+ scalarZero:aScalar;
- setterms:t;
- copy;
- deepCopy;
- clone;
- _terms:cltn;
- empty;
- scalarZero:aScalar;
- scalarZero:aScalar symbols:aCltn;
- emptyScalarZero:aZero;
- emptyVariableDense:aCltn;
- emptyVariableSparse;
- emptyExpanded;
- emptyRecursive;
- emptyDegreeSparse;
- emptyDegreeDense;
- (BOOL) isEmpty;
- (BOOL) isZero;
- (BOOL) isOne;
- (BOOL) isMinusOne;
- (BOOL) sameClass:b;
- (BOOL) isEqual:b;
- asScalar;
- asSymbol;
- (int) numTerms;
- eachTerm;
- removeTerm;
- insertTerm:aTerm;
@end

#endif /* __obj_varspsrecdegsps_polynomial_header__ */
 
