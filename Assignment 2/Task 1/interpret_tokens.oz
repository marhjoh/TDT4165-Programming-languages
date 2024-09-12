declare
fun {Interpret Tokens}
   fun {Interpret Stack Tokens}
      case Tokens
      of nil then
         Stack
      [] number(Number)|T then
         {Interpret number(Number)|Stack T}
      [] operator(type:Operator)|T then
         if Operator == plus then
            Top|NextTop|Rest = Stack in
            {Interpret number(Top.1 + NextTop.1)|Rest T}
         elseif Operator == minus then
            Top|NextTop|Rest = Stack in
            {Interpret number(Top.1 - NextTop.1)|Rest T}
         elseif Operator == multiply then
            Top|NextTop|Rest = Stack in
            {Interpret number(Top.1 * NextTop.1)|Rest T}
         elseif Operator == divide then
            Top|NextTop|Rest = Stack in
            {Interpret number(Top.1 / NextTop.1)|Rest T}
         end
      [] command(Command)|T then
         if Command == print then
            {System.showInfo Stack.1.1}
            {Interpret Stack T}
         elseif Command == duplicate then
            {Interpret Stack.1|Stack T}
         elseif Command == negate then
            Top|Rest = Stack in
            {Interpret number(~Top.1)|Rest T}
         elseif Command == invert then
            Top|Rest = Stack in
            {Interpret number(1.0 / Top.1)|Rest T}
         end
      end
   end
   in {Interpret nil Tokens}
end

{Show {Interpret [number(1) number(2) number(3) operator(type:plus)]}}