/* 
This file contains a possible solution to Assignment 5 of the TDT4165 course for Autumn 2024.
Note that this is not the only possible solution, but variations may apply.
*/

/* TASK 1 */

% Base rule: if the Sum can be achieved with the available
% amount of coins of one kind, then we use them.
payment(Sum, [coin(N,V,A)]) :- Sum #= N*V, N in 0..A.

% Recursive rule: we use (or not) the available coins of
% the first type in the list, and then we cover the rest of the
% total amount with a recursive call.
payment(Sum, [coin(N,V,A)|OtherCoins]) :-
    N in 0..A,
    Sum #= V*N + PartialAmount,
    payment(PartialAmount,OtherCoins).

