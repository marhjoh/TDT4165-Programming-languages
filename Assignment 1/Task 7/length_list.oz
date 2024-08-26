declare
fun {Length List}
   case List of nil then
      0
   [] _|Tail then
      1 + {Length Tail}
   end
end
{System.showInfo {Length [1 2 3 4 5]}}