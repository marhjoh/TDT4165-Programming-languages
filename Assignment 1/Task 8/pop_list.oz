declare
fun {Pop List}
   case List of
      nil then nil
   [] Head|Tail then
      Tail 
   end
end

NewList = {Pop [1 2 3]}
{System.showInfo NewList}
