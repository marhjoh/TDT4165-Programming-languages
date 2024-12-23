/* 
This file contains a possible solution to Assignment 3 of the TDT4165 course for Autumn 2024.
Note that this is not the only possible solution, but variations may apply.
*/

/* Task 1 */

% (a)

declare
proc {QuadraticEquation A B C ?RealSol ?X1 ?X2} Delta in
    Delta = B*B - 4.0*A*C

    if Delta < 0.0 then
        RealSol = false
    else
        RealSol = true
        X1 = (~B + {Number.pow Delta 0.5}) / (2.0*A)
        X2 = (~B - {Number.pow Delta 0.5}) / (2.0*A)
    end
end

declare R X1 X2declare
proc {QuadraticEquation A B C ?RealSol ?X1 ?X2} Delta in
    Delta = B*B - 4.0*A*C

    if Delta < 0.0 then
        RealSol = false
    else
        RealSol = true
        X1 = (~B + {Number.pow Delta 0.5}) / (2.0*A)
        X2 = (~B - {Number.pow Delta 0.5}) / (2.0*A)
    end
end 

% (b)
% 
% Procedural abstractions are useful because they make it possible to reuse code,
% make the code more modular, and easier to maintain. Also, they make it possible to
% use a higher level of abstraction, by using parameters to generalize some portion of code

% (c)
% A procedure encapsulates a statement and can be called multiple times, possibly with
% parameters. A procedure does not explicitly return values, but it can do so implicitly, 
% modifiying variables received as arguments. A function has an explicit return value, which
% is the last expression in its body. A function is equivalent to the same procedure with an
% additional (return) parameter. Since a function has a return value, calls to it can be used
% as a value to build expressions.
 
/* Task 2 */

declare
fun {Sum List}
    case List of H|Tail then
        H + {Sum Tail}
    [] nil then
        0
    end
end

/* Task 3 */

% (a)

declare
fun {RightFold List Op U}
    case List of H|Tail then
        {Op H {RightFold Tail Op U}}
    [] nil then
        U
    end
end

% (b)
%
% The RightFold applies the operation Op, recursively, to the result of applying
% RightFold to the rest of the list. When the end of the list is reached (i.e., the
% list is nil) the recursive calls start returning, and then the results of Op are
% returned, starting from the right of the list.

% (c)

declare 
fun {Length List} 
    {RightFold List fun {$ A B} 1 + B end 0}    
end

declare 
fun {Sum List} 
    {RightFold List fun {$ A B} A + B end 0}    
end

% (d)
% 
% For the Sum and Length operations they would provide the same results. 
% For Subtraction, LeftFold and RightFold would provide different results, e.g.,
% for the list [1 2 3] the right-fold would yield (1 - (2 - (3 - 0)) = 2, while the
% left-fold would yield ((1 - 2) - 3) = -4

% (e)
%
% For the product, 1 would be a good value for U, since it is the neutral value for the
% product operation, i.e., the value that does not change the result of the operation.

declare 
fun {Product List} 
    {RightFold List fun {$ A B} A * B end 1}    
end

/* Task 4 */

declare fun {Quadratic A B C} X in
    fun {$ X}
        A*X*X + B*X + C
    end
end

{System.show {{Quadratic 3 2 1} 2}}

/* Task 5 */

% (a)

declare LazyNumberGenerator
fun {LazyNumberGenerator StartValue} LazyNumber in
    fun {LazyNumber}
        {LazyNumberGenerator StartValue+1}
    end

    num(StartValue LazyNumber)
end

{Browse {{{{{{LazyNumberGenerator 0}.2}.2}.2}.2}.2}.1}

% (b) 
%
% The "LazyNumberGenerator" function returns a record of two fields: the first field
% is the actual number, while the second field is a function value that can generate
% the next number. Since the generator of the next number needs to be called explicitly,
% we are able to generate an infinite sequence of numbers, on demand.

/* Task 6 */

% (a) No, it is not tail-recursive. We can make it tail-recursive
%     by making sure that the last statement is the recursive function
%     call. The only way to be sure it is tail recursion is to use
%     the iteration pattern internally

declare
fun {Sum List} 
    fun {Iterate Accumulator Rest} NewAccumulator in
        case Rest of nil then 
            Accumulator
        [] Value|Tail then
            NewAccumulator = Accumulator + Value
            {Iterate NewAccumulator Tail} % Tail recursion call
        end
    end
in
    {Iterate 0 List}
end

{Browse {Sum [42 2 10 99]}}

% (b)
%
% Normally, activation frames (semantic statements in Oz) of nested procedure calls accumulate on
% the stack, and they can be removed only when all the nested recursive calls have returned.
% With tail recursion, activation frames can be removed from the stack as soon as the nested call 
% is executed, thus saving space (memory) on the stack and ensuring its constant size instead of
% having a linear growth. This is possible because, if the recursive call is the last statement, then
% it is ensured that no variables will be needed when the nested calls will actually return.

% (c)
%
% Not all the programs that support recursion benefit from tail recursion. To enable the memory-saving
% behavior, some optimizations must be performed with respect to the plain management of the stack.
% In particular, the removal of tail-recursive activation frames from the stack must be implemented
% (tail-call optimization).
