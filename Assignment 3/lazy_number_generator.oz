declare LazyNumberGenerator in

fun {LazyNumberGenerator N} F in 
    % F is a function that takes no arguments 
    % and returns the value of this function with N=N+1
    F = fun {$} {LazyNumberGenerator N+1} end
    % Return a tuple of the current "count" and 
    % the function F that generates the next count
    laz(1:N 2:F) 
end

% Test LazyNumberGenerator
{Show {LazyNumberGenerator 0}.1}                     % Expected: 0
{Show {{LazyNumberGenerator 0}.2}.1}                 % Expected: 1
{Show {{{{{{LazyNumberGenerator 0}.2}.2}.2}.2}.2}.1} % Expected: 5