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
      else number({String.toInt Head})
      end | {Tokenize Tail}
   end
end

declare
fun {Interpret Tokens}
   fun {InterpretHelper Stack Tokens}
      case Tokens of
         nil then
            Stack 
      [] number(Number)|T then
            {InterpretHelper Number|Stack T}
      [] operator(type:Operator)|T then
            case Stack of
               Top|NextTop|Rest then
                  if Operator == plus then
                     {InterpretHelper (NextTop + Top)|Rest T} 
                  elseif Operator == minus then
                     {InterpretHelper (NextTop - Top)|Rest T} 
                  elseif Operator == multiply then
                     {InterpretHelper (NextTop * Top)|Rest T} 
                  elseif Operator == divide then
                     {InterpretHelper (NextTop / Top)|Rest T} 
                  end
            end
      [] command(print)|T then
            {System.show Stack}
            {InterpretHelper Stack T} 
      end
   end
in
   {InterpretHelper nil Tokens}
end

{System.show {Interpret {Tokenize {Lex "1 2 p 3 +"}}}}
