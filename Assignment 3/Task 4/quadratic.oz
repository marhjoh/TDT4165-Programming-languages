declare Quadratic in

fun {Quadratic A B C}
    % Return a function that takes a single argument,
    % using the environment (A, B, C) to calculate 
    % the quadratric function value 
    fun {$ X }
        A * X * X + B * X + C 
    end
end

% Test for Quadratic
{Show {{Quadratic 3 2 1} 2}}  % Expected: 17