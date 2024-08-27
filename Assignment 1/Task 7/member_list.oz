declare
fun {Member List Element}
   case List of
      nil then
         false 
   [] Head|Tail then
      if Head == Element then
         true 
      else
         {Member Tail Element} 
      end
   end
end

Bool = {Member [1 2 3] 2}
if Bool then
   {System.showInfo "true"}
else
   {System.showInfo "false"}
end
