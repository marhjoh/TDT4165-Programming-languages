declare
   fun {Length List}
      case List of
         nil then 0
      [] _|Tail then 1 + {Length Tail}
      end
   end

   fun {Take List Count}
      case List of
         nil then nil
      [] Head|Tail then
         if Count =< 0 then nil
         else Head | {Take Tail Count-1}
         end
      end
   end

   fun {Drop List Count}
      case List of
         nil then nil
      [] _|Tail then
         if Count =< 0 then List
         else {Drop Tail Count-1}
         end
      end
   end

   fun {Append List1 List2}
      case List1 of
         nil then List2
      [] Head|Tail then Head | {Append Tail List2}
      end
   end

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

   fun {Position List Element}
      fun {PositionAux List Element Pos}
         case List of
            nil then nil
         [] Head|Tail then
            if Head == Element then Pos
            else {PositionAux Tail Element Pos+1}
            end
         end
      end
   in
      {PositionAux List Element 1}
   end

   fun {Push List Element}
      Element | List
   end

   fun {Pop List}
      case List of
	 nil then nil
      [] Head|Tail then
	 Tail 
      end
   end

   fun {Peek List}
      case List of
	 nil then nil 
      [] Head|Tail then
	 Head 
      end
   end