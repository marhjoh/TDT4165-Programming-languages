local
   fun {IncUntil Start Stop} A in
      {System.showInfo "Pushing Start: "#Start}
      if Start < Stop then
	 A = {IncUntil Start+1 Stop}
      else
	 A = Stop
      end
      {System.showInfo "Popping Start: "#Start}
      A
   end
in
   {System.showInfo {IncUntil 10 15}}
end