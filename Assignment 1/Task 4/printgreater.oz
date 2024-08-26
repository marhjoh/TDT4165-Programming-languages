local
   proc {PrintGreater Number1 Number2}
      if Number1 > Number2 then
         {System.showInfo Number1}
      else
         {System.showInfo Number2}
      end
   end
in
   {PrintGreater 10 89}
end
