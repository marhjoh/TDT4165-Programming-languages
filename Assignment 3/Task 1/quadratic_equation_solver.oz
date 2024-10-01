declare QuadraticEquation in

proc {QuadraticEquation A B C ?RealSol ?X1 ?X2}
    % Check for no real solutions
    if B*B-4.0*A*C<0.0 then 
        RealSol = false
    % Bind solutions to X1 and X2
    else 
        X1 = (0.0-B-{Sqrt B*B-4.0*A*C})/(2.0*A)
        X2 = (0.0-B+{Sqrt B*B-4.0*A*C})/(2.0*A)
        RealSol = true
    end
end

% Test on equation with solutions
local X1 X2 RealSol in 
   {QuadraticEquation 2.0 1.0 ~1.0 RealSol X1 X2}
   {Show RealSol}  % Expected: true
   {Show X1}       % Expected: -1.0
   {Show X2}       % Expected: 0.5
end

% Test on equation with no solutions
local _ _ RealSol in 
   {QuadraticEquation 2.0 1.0 2.0 RealSol _ _}
   {Show RealSol}  % Expected: false
end