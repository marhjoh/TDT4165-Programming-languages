declare fun {ExpressionTreeInternal Tokens ExpressionStack}
    case Tokens of Head | Tail then
        local NewTail = Tail in 
            case Head of 
                number(N) then
                    {ExpressionTreeInternal NewTail N|ExpressionStack}
                [] operator(type:Op) then
                    case ExpressionStack of
                      Num1 | Num2 | Rest then
                        case Op of
                          plus then
                            {ExpressionTreeInternal NewTail plus(Num1 Num2)|Rest}
                          [] minus then
                            {ExpressionTreeInternal NewTail minus(Num1 Num2)|Rest}
                          [] multiply then
                            {ExpressionTreeInternal NewTail multiply(Num1 Num2)|Rest}
                          [] divide then
                            {ExpressionTreeInternal NewTail divide(Num1 Num2)|Rest}
                          [] _ then
                            {System.showInfo "Invalid operator"}
                        end
                      end
                end
            end
        else
            ExpressionStack
    end
end

{Browse {ExpressionTreeInternal [number(2) number(3) operator(type:plus) number(5) operator(type:divide)] nil}}


declare fun {ExpressionTree Tokens}
    {ExpressionTreeInternal Tokens nil}
end

{Browse {ExpressionTree [number(3) number(10) number(9) operator(type:multiply) operator(type:minus) number(7) operator(type:plus)]}}