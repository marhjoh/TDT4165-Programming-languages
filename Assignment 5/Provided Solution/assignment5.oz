/* 
This file contains a possible solution to Assignment 4 of the TDT4165 course for Autumn 2024.
Note that this is not the only possible solution, but variations may apply.
*/

/* Task 1 */

% (a)

% One possible sequence is the following:
% 30
% 3000
% 10
% 20
% 200
% 100
% Other sequences are possible too, as there is no syncrhonization
% between the threads. The only thing we know for sure is that
% the first number to get printed will be "30".

% (b)
%
% First, the variables A, B, and C are initialized and bound to
% their respective values. Then, the line {System.show C} will be
% executed, printing "30". The "thread...end" statements will cause
% the creation of new threads, which then progress in parallel.
% After those threads are created, at some point the statement
% {System.show C * 100} is executed, causing "3000" to be printed.
% Meanwhile, the other two threads are executing, so we do not know
% in which order the other values will be printed.

% (c)
%
% In this case we get the following sequence:
% 2
% 20
% 22

% (d)
%
% Threads are syncronized by means of dataflow variables, so the execution
% proceeds as follows. First, the variables A, B, and C are created, but they
% are not bound to any values. Then, the two new threads are created,
% when the two statements "thread...end" are executed. The main thread
% then freezes on the statement "C = A + B", since neither A nor B are 
% bound. The second of the two new threads also freezes on statement
% "B = A * 10", because A is not bound. The first of the two new threads
% is the only one that can proceed, by binding A. Then, the second thread can
% resume and binds B. Finally, the main thread also resumes and binds C.
% This is the only sequence in which these statements may be executed. However,
% the "System.show" statements are not synchronized with each other, so any
% sequence of the three numbers can be printed in practice.

/* Task 2 */

% (a)

declare Enumerate
fun {Enumerate Start End}
    fun {AllNumbers S E}
        if S =< E then
            S | {AllNumbers S+1 E}
        else
            nil
        end
    end
in
    thread {AllNumbers Start End} end
end

% (b)

declare GenerateOdd
fun {GenerateOdd Start End}
    fun {FilterOdds List}
        case List of N|Tail then
            if N mod 2 == 0 then
                {FilterOdds Tail}
            else
                N | {FilterOdds Tail}
            end
        else
            nil
        end
    end
in
    thread {FilterOdds {Enumerate Start End}} end
end

{Browse {GenerateOdd ~3 10}}
{Browse {GenerateOdd 3 3}}
{Browse {GenerateOdd 2 2}}

% (c)

% Because they are built in an asyncrhonous way, and because of how dataflow
% variables work in Oz, new values are actually appended to streams only when
% they are "needed". The function {Show} therefore just prints that the stream
% exists and it is ready to be used. To actually print the value it is necessary
% to manipulate in some ways the values of the stream, for example by using the
% List.take function, to get the first n values of the stream.

/* Task 3 */

% (a)

declare
fun {ListDivisorsOf Number} 
    fun {IsDivisorOf Div Num} 
        (Num mod Div) == 0
    end
    fun {GenerateDivisors Candidates Num}
        case Candidates of K|Tail then
            if {IsDivisorOf K Num} then
                K | {GenerateDivisors Tail Num}
            else
                {GenerateDivisors Tail Num}
            end
        [] nil then
            nil
        end
    end
in
    thread {GenerateDivisors {Enumerate 2 Number} Number} end
end

{Browse {ListDivisorsOf 100}}

% (b)

declare ListPrimesUntil
fun {ListPrimesUntil N}
    fun {FilterPrimes List}
        case List of K|Tail then
            case {ListDivisorsOf K} of [K] then
                K | {FilterPrimes Tail}
            else
                {FilterPrimes Tail}
            end
        [] nil then
            nil
        end
    end
in
    thread {FilterPrimes {Enumerate 2 N}} end
end

{Browse {ListPrimesUntil 20}}

/* Task 4 */

% (a)

declare Enumerate
fun {Enumerate}
    fun lazy {AllNumbers Next}
        Next | {AllNumbers Next+1}
    end
in
    {AllNumbers 1}
end

{Browse {Enumerate}}
{System.show {Enumerate}}
{Browse {List.take {Enumerate} 10}}

% (b)

declare Primes
fun {Primes}
    fun {IsDivisorOf Div Num} 
        (Num mod Div) == 0
    end
    fun lazy {GenerateDivisors Candidates Num}
        case Candidates of K|Tail andthen K =< (Num div 2) then
            if {IsDivisorOf K Num} then
                K | {GenerateDivisors Tail Num}
            else
                {GenerateDivisors Tail Num}
            end
        [] nil then
            nil
        else 
            nil
        end
    end
    fun lazy {FilterPrimes List}
        case List of K|Tail then
            case {GenerateDivisors {Enumerate} K} of [1 K] then
                K | {FilterPrimes Tail}
            else
                {FilterPrimes Tail}
            end
        [] nil then
            nil
        end
    end
in
    {FilterPrimes {Enumerate}}
end

{Browse {Primes}}
{Browse {List.take {Primes} 10}}

proc {ShowLazyList List}
    case List of _|Tail then
        {Browse List.1}
        thread {ShowLazyList Tail} end
    end
end

%{ShowLazyList {ListPrimes}}
