declare
fun {Drop List Count}
   case List of
      nil then
         nil 
   [] Head|Tail then
      if Count =< 0 then
         List 
      else
         {Drop Tail Count-1}
      end
   end
end
{System.showInfo {Drop [1 2 3 4 5] 2}}

