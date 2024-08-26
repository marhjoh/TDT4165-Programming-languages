local
   fun {Max X Y}
      if X > Y then
         X
      else
         Y
      end
   end
in
   {System.showInfo {Max 10 89}}
end
