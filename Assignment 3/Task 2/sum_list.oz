declare Sum in

fun {Sum List}
    % Add the numbers of the list recursively
    case List of Head|Tail then 
        Head + {Sum Tail}
    else 
        0 
    end 
end 

% Test for Sum
{Show {Sum [1 2 3 4]}}  % Expected: 10