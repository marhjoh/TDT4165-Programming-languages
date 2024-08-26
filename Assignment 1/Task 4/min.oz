local
   fun {Min X Y}
      if X < Y then
         X
      else
         Y
      end
   end
in
   {System.showInfo {Min 10 89}}
end
