declare RightFold Sum2 Length2 in

fun {RightFold List Op U}
    % Pattern match to get head 
    case List of Head|Tail then 
        % Return the result of doing OP on Head 
        % and the result from the Tail of the list
        { Op Head {RightFold Tail Op U} }
    else 
        % Base case 
        U
    end 
end

% Sum2 using RightFold
fun {Sum2 List}
   {RightFold List fun {$ X Y} X + Y end 0}
end

% Test for Sum2
{Show {Sum2 [1 2 3 4]}}  % Expected: 10

% Length2 using RightFold
fun {Length2 List}
   {RightFold List fun {$ _ Y} 1 + Y end 0}
end

% Test for Length2
{Show {Length2 [1 2 3 4]}}  % Expected: 4