
function result = isFoundationNumber(number2Check, board)
    % ISFOUNDATIONNUMBER Checks if given number currently exists in the
    % pyramid foundation. Made into a function as this check is repeated in
    % multiple places in the script.
    
    % condition checks if number2Check is a number (as all foundational
    % values are numbers) and if board contains number2Check (since all 
    % foundational values are followed by a trailing space)
    if isnumeric(str2num(number2Check)) && contains(board, number2Check + " ")
        result = true;
    else
        result = false;
    end
end

