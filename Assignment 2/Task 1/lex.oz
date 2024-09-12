declare
fun {Lex Input}
   {String.tokens Input & }
end

{Show {Lex "1 2 + 3 *"}}
