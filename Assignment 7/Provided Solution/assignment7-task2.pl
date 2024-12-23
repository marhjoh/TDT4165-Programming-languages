/* 
This file contains a possible solution to Assignment 5 of the TDT4165 course for Autumn 2024.
Note that this is not the only possible solution, but variations may apply.
*/

:- use_module(library(clpfd)).

distance(c1, c2, 10, 1). distance(c1, c3, 0, 0). distance(c1, c4, 7, 1).
distance(c1, c5, 5, 1). distance(c2, c3, 4, 1). distance(c2, c4, 12, 1).
distance(c2, c5, 20, 1). distance(c3, c4, 0, 0). distance(c3, c5, 0, 0).
distance(c4, c5, 0, 0). distance(c2, c1, 10, 1). distance(c3, c1, 0, 0).
distance(c4, c1, 7, 1). distance(c5, c1, 5, 1). distance(c3, c2, 4, 1).
distance(c4, c2, 12, 1). distance(c5, c2, 20, 1). distance(c4, c3, 0, 0).
distance(c5, c3, 0, 0). distance(c5, c4, 0, 0).

/* TASK 2 */
/* 2.1 */

plan(Cabin1, Cabin2, Path, TotalDistance):-
    planinternal(Cabin1, Cabin2, Path, TotalDistance, [], 0).

% We use an "internal" predicate in which we apply iteration
% in a similar way as with internal functions in Oz
planinternal(CAB1, CAB2, Path, TotalDistance, IterP, IterD):-
    distance(CAB1, CAB2, D, 1),
	append(IterP, [CAB1, CAB2], Path),
    TotalDistance #= IterD + D.

planinternal(CAB1, CAB2, Path, TotalDistance, IterP, IterD):-
    distance(CAB1, H, D, 1),
    not(H = CAB2),
    not(member(H, IterP)),
    
    append(IterP, [CAB1], IterPNew),
    IterDNew #= IterD + D,
    
    planinternal(H, CAB2, Path, TotalDistance, IterPNew, IterDNew).

/* 2.2 */

% The best plan is not necessaily the one with two steps
% Try it for example with "bestplan(c5, c2, P, D)".
bestplan(Cabin1, Cabin2, Path, Distance):-
    plan(Cabin1, Cabin2, Path, Distance),
    D2 #< Distance,
    not(plan(Cabin1, Cabin2, _, D2)).

