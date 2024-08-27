declare
fun {Peek List}
   case List of
      nil then nil 
   [] Head|Tail then
      Head 
   end
end

FirstElement = {Peek [1 2 3]}
{System.showInfo FirstElement}
