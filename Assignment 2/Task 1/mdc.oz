\insert List

declare
fun {Lex Input}
   {String.tokens Input & }
end

declare
fun {Tokenize Lexemes}
   case Lexemes of
      nil then
         nil
   [] Head|Tail then
      case Head of
         "+" then operator(type:plus)
      [] "-" then operator(type:minus)
      [] "*" then operator(type:multiply)
      [] "/" then operator(type:divide)
      [] "p" then command(print)
      [] "d" then command(duplicate)
      [] "i" then command(invert)
      [] "c" then command(clear)
      else number({String.toInt Head})
      end | {Tokenize Tail}
   end
end

fun {Interpret Tokens}
   fun {InterpretHelper Stack Tokens}
      case Tokens of
         nil then
            Stack 
      [] number(Number)|T then
            {InterpretHelper {Push Stack Number} T}
      [] operator(type:Operator)|T then
            case Stack of
               Num1|Num2|Rest then
                  if Operator == plus then
                     {InterpretHelper {Push Rest (Num1 + Num2)} T} 
                  elseif Operator == minus then
                     {InterpretHelper {Push Rest (Num1 - Num2)} T} 
                  elseif Operator == multiply then
                     {InterpretHelper {Push Rest (Num1 * Num2)} T} 
                  elseif Operator == divide then
                     {InterpretHelper {Push Rest (Num1 / Num2)} T} 
                  end
            end 
      [] command(print)|T then
            {System.show Stack} 
            {InterpretHelper Stack T}  
      [] command(duplicate)|T then
            case Stack of
               Top|Rest then
                  {InterpretHelper {Push Stack Top} T}
            end 
      [] command(invert)|T then
            case Stack of
               Top|Rest then
                  {InterpretHelper {Push Rest (~Top)} T}
            end 
      [] command(clear)|T then
            {InterpretHelper nil T}
      end  
   end  
in
   {InterpretHelper nil Tokens}
end

%{System.show {Interpret {Tokenize {Lex "1 2 p 3 +"}}}}
%{System.show {Interpret {Tokenize {Lex "1 2 3 + d"}}}}
%{System.show {Interpret {Tokenize {Lex "1 2 3 + i"}}}}
{System.show {Interpret {Tokenize {Lex "1 2 3 + c"}}}}
