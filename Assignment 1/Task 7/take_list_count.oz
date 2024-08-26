declare
fun {Take List Count}
   case List of
      nil then
         nil  
   [] Head|Tail then
      if Count =< 0 then
         nil 
      else
         Head | {Take Tail Count-1}
      end
   end
end

{System.showInfo {Take [1 2 3] 5}}