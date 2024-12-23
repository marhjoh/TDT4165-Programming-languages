/* 
This file contains a possible solution to Assignment 1 of the TDT4165 course for Autumn 2024.
Note that this is not the only possible solution, but variations may apply.
*/

/* TASK 3 */

/* a */

local X Y Z in
    Y = 300
    Z = 30
    X = Y * Z
    {System.show X}
end

/* b */

local X Y in
    X = "This is a string"
    thread {System.showInfo Y} end
    Y = X
end

/* 
- Because showInfo runs in a differen thread, and the statement is actually
  executed afterwards, when the value of Y becomes available.
- This behavior can be useful for syncronization in parallel programming
- The statement X=Y unifies the two variables, that is, makes them reference the same value
*/


/* TASK 4 */

declare Min

fun {Min X Y}
    if X < Y then
        X
    else
        Y
    end
end

local Z in 
    Z = {Min 10 89}
    {System.showInfo Z}
end

/* a */

declare Max

fun {Max Number1 Number2}
    if Number1 > Number2 then
        Number1
    else
        Number2
    end
end

/* b */

declare PrintGreater

proc {PrintGreater Number1 Number2}
    {System.showInfo {Max Number1 Number2}}
end

{PrintGreater 100 22}

/* TASK 5 */

declare Circle

proc {Circle R} D Area Circ PI in
    PI = 355.0/113.0
    D = R * 2.0
    Circ = PI * D
    Area = PI * R * R

    {System.printInfo "Circle of radius "}
    {System.printInfo R}
    {System.showInfo ":"}

    {System.printInfo "Diameter: "}
    {System.showInfo D}

    {System.printInfo "Circumference: "}
    {System.showInfo Circ}

    {System.printInfo "Area: "}
    {System.showInfo Area}
end

{Circle 1.0}

/* TASK 6 */

declare IncUntil

fun {IncUntil Start Stop} A in
    {System.showInfo ">> Pushing Start: "#Start}
    if Start < Stop then
        A = {IncUntil Start+1 Stop}
    else
        A = Stop
    end
    {System.showInfo "<< Popping Start: "#Start}
    A
end

% {System.showInfo {IncUntil 10 15}}

/* a */

declare Factorial

fun {Factorial N}
    if N==0 then
        1
    else
        N * {Factorial N-1}
    end
end

% {System.showInfo {Factorial 10}}
% {System.showInfo {Factorial 1000}}

/* TASK 7 */

/* a */

declare Length
fun {Length List}
    case List of H|T then
        1 + {Length T}
    [] nil then
        0
    end
end

% {System.showInfo {Length [a b c d e f]}}

/* b */

declare Take
fun {Take List Count} H T in
    if Count =< 0 then nil 
    else
        case List of nil then nil
        [] H|T then
            H|{Take T Count-1}
        end
    end
end

% {System.show {Take [a b c d e f] 3}}

/* c */

declare Drop
fun {Drop List Count} H T in
    if Count =< 0 then List
    else
        case List of nil then nil
        [] H|T then
            {Drop T Count-1}
        end
    end
end

% {System.show {Drop [a b c d e f] 3}}

/* d */

declare Append
fun {Append List1 List2} 
    case List1 of nil then
        List2
    [] H|T then
        H|{Append T List2}
    end
end

% {System.show {Append [a b c] [d e f]}}

/* e */

declare Member
fun {Member List Element} 
    case List of H|T then
        {Or (H==Element) {Member T Element}}
    else
        false
    end
end

% {System.show {Member [a b c d e f] a}}
% {System.show {Member [a b c d e f] d}}
% {System.show {Member [a b c d e f] f}}
% {System.show {Member [a b c d e f] h}}

/* f */

declare Position
fun {Position List Element}
    case List of nil then
        0
    [] H|T then
        if H == Element then
            1
        else
            1+{Position T Element}
        end
    end
end

% {System.show {Position [a b c d e f] d}}

/* Task 8 */

/* a */

fun {Push List Element}
    Element|List
end

/* b */

fun {Peek List} 
    case List of H|T then
        H
    else nil end
end

/* c */

fun {Pop List} 
    case List of H|T then
        T
    else nil end
end
