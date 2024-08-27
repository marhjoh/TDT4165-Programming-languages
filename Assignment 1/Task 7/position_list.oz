declare
fun {Position List Element}
   fun {PositionAux List Element Pos}
      case List of
         nil then
            nil 
      [] Head|Tail then
         if Head == Element then
            Pos 
         else
            {PositionAux Tail Element Pos+1} 
         end
      end
   end
in
   {PositionAux List Element 1} 
end
{System.showInfo {Position [1 2 3] 3}}
