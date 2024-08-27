declare
fun {Append List1 List2}
   case List1 of
      nil then
         List2 
   [] Head|Tail then
         Head | {Append Tail List2}
   end
end
{System.showInfo {Append [1 2] [3 4 5]}}
