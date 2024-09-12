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
      else number({String.toInt Head})
      end | {Tokenize Tail}
   end
end

{Show {Tokenize ["1" "2" "+" "3" "*"]}}
