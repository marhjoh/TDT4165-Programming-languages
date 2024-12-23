/* 
This file contains a possible solution to Assignment 2 of the TDT4165 course for Autumn 2024.
Note that this is not the only possible solution, but variations may apply.
*/

% Modify with full path on your machine if needed. 
% This file reuses some functions from Assignment 1
\insert './assignment1.oz'

% Alternatively, uncomment the following code 
%
% /* Task 8 */
%
% /* a */
%
% fun {Pop S} 
%     case S of H|T then
%         T
%     else nil end
% end
%
% /* b */
%
% fun {Push S E}
%     E|S
% end
%
% /* c */
%
% fun {Peek S} 
%     case S of H|T then
%         H
%     else nil end
% end

/* Task 1 */

/* a */

declare
fun {Lex Input}
    {String.tokens Input & }
end

/* b (including d/e/f/g) */

declare
fun {Tokenize Lexemes}
    case Lexemes of H|T then
        local TOK in
            case H of "+" then
                TOK = operator(type:plus)
            [] "-" then
                TOK = operator(type:minus)
            [] "*" then
                TOK = operator(type:multiply)
            [] "/" then
                TOK = operator(type:divide)
            [] "p" then
                TOK = command(print)
            [] "d" then
                TOK = command(duplicate)
            [] "i" then
                TOK = command(flip)
            [] "c" then
                TOK = command(clear)
            else
                TOK = number({String.toInt H})
            end
            TOK|{Tokenize T}
        end
    else
        nil
    end
end

{System.show {Tokenize {Lex "1 2 + 3 *"}}}

/* c (including d/e/f/g) */

declare
fun {Interpret Tokens}
    % Anonymous functions that represent the possible operators
    % Recall: functions (procedures) are values, record features have a key and a value
    Operators = operators(
        plus: fun {$ X Y} X + Y end
        minus: fun {$ X Y} X - Y end
        multiply: fun {$ X Y} X * Y end
        divide: fun{$ X Y} X div Y end
    )
    Commands = commands(
        print: fun {$ S} {System.printInfo "Stack: "} {System.show S} S end
        duplicate: fun {$ S} S.1 | S end
        flip: fun {$ S} (~S.1) | S.2 end
        clear: fun {$ S} nil end
    )

    fun {ProcessTokens S T} 
        case T of Head|Tail then
            case Head of number(K) then
                {ProcessTokens {Push S K} Tail}
            [] operator(type:O) then
                {ProcessTokens {ApplyOperator S Operators.O} Tail}
            [] command(C) then
                {ProcessTokens {RunCommand S Commands.C} Tail}
            end
        else
            S
        end
    end
    fun {ApplyOperator S Op}
        case S of Operand2 | Operand1 | Rest then
            {Push Rest {Op Operand1 Operand2}}
        else
            raise "Tokens are invalid" end
        end
    end
    fun {RunCommand S Com}
        {Com S}
    end
in
    {ProcessTokens nil Tokens}
end

{System.show {Interpret {Tokenize {Lex "1 2 + 9 9 /"}}}}

{System.show {Interpret {Tokenize {Lex "1 2 3 +"}}}}


/* Task 2 */

/* a/b */

fun {ExpressionTree Tokens} 
    fun {ExpressionTreeInternal Tokens ExpressionStack}
        case Tokens of H|T then
            {ExpressionTreeInternal T {UpdateStack H ExpressionStack}}
        else
            {Peek ExpressionStack}
        end 
    end
    fun {UpdateStack T Stack}
        case T of operator(type:O) then
            local X|Y|Tail = {Take Stack 2} in
                {Push {Drop Stack 2} O(X Y) }
            end
        [] number(T) then
            {Push Stack T}
        else
            raise "Invalid token" end
        end
    end
in
    {ExpressionTreeInternal Tokens nil}
end

{Browse {ExpressionTree {Tokenize {Lex "1 2 + 9 9"}}}}

{Browse {ExpressionTree [number(2) number(3) operator(type:plus) number(5) operator(type:divide)]}}

{Browse {ExpressionTree {Tokenize {Lex "3 10 9 * - 7 +"}}}}

/* Task 3 */

/* a */

% The exercise was asking to define the grammar using the formal notation as seen 
% in the lecture slides. Note that it is the grammar that defines _individual_ lexemes
% that is, the lanugage is the language where words are inidividual lexemes.
% 
% V = { LEX, OP, CMD, NUM }
% S = { 0,1,2,3,4,5,6,7,8,9,+,*,-,/,p,d,i,c }
% R = { (LEX,OP), (LEX,CMD), (LEX,NUM), (OP,'+'), (OP,'*'), (OP,'-'), (OP,'/'),
%       (CMD,'p'), (CMD,'d'), (CMD,'i'), (CMD,'c'), (NUM,'1'NUM), (NUM,'2'NUM),
%       (NUM,'3'NUM), (NUM,'4'NUM), (NUM,'5'NUM), (NUM,'6'NUM), (NUM,'7'NUM),
%       (NUM,'8'NUM), (NUM,'9'NUM), (NUM,'0'), (NUM,'') 
%     }
% vs = LEX
% 
% For reference, the same grammar using the EBNF notation is as follows:
%
% <LEX> ::= <OP> | <CMD> | <NUM> 
% <OP>  ::= '+' | '*' | '/' | '-'
% <CMD> ::= 'p' | 'd' | 'i' | 'c'
% <NUM> ::= '1'<NUM> | '2'<NUM> | '3'<NUM> | '4'<NUM> | '5'<NUM> |
%           '6'<NUM> | '7'<NUM> | '8'<NUM> | '9'<NUM> | '0' | '' 
%
% where '' is the empty string (usually denoted with the greek letter epsilon)
%

/* b */

% <EXTREE>   ::= <OPERATOR> '(' <EXTREE> <EXTREE> ')' | <NUM>
% <OPERATOR> ::= 'plus' | 'multiply' | 'minus' | 'divide'
% <NUM>      ::= '1'<NUM> | '2'<NUM> | '3'<NUM> | '4'<NUM> | '5'<NUM> |
%                '6'<NUM> | '7'<NUM> | '8'<NUM> | '9'<NUM> | '0' | '' 

/* c */

% The grammar of step a) is a regular grammar.
% The grammar of step b) is a context-free grammar.
