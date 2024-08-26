local
   proc {Circle R}
      local
         Pi A D C
      in
         Pi = 355.0 / 113.0
         A = Pi * R * R
         D = 2.0 * R
         C = Pi * D

         {System.showInfo 'Area: ' # A}
         {System.showInfo 'Diameter: ' # D}
         {System.showInfo 'Circumference: ' # C}
      end
   end
in
   {Circle 5.0}
end