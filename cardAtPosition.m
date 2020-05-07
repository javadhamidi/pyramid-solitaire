
function card = cardAtPosition(pyramid, position)
    % CARDATPOSITION Recieves the position indicator (the numbers at the 
    % foundation of the pyramid), and finds the card at that position.
    
    asteriskIndex = 0; % counts the occurrences of the * character
    
    % gets dimensions of the board to iterate over each cell
    [ rows, columns ] = size(pyramid); 
    
    for row=1:rows
        for col=1:columns
            if pyramid(row, col) == "*"
                asteriskIndex = asteriskIndex + 1; % counts up the number of asterisks
                
                % when the position indicator is the same as the asterisksIndex,
                % the cell above that asterisk will be the indicated card
                if asteriskIndex == str2num(position)
                    card = pyramid(row-1, col);
                    return; % ends function execution once the correct value is found
                end
            end
        end
    end
end

