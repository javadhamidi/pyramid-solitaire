
function card = cardAtPosition(pyramid, position)
    % CARDATPOSITION Summary of this function goes here
    
    occurrence = 0;
    
    [ rows, columns ] = size(pyramid);
    
    for row=1:rows
        for col=1:columns
            if pyramid(row, col) == "*"
                occurrence = occurrence + 1;
                
                if occurrence == str2num(position)
                    card = pyramid(row-1, col);
                    return;
                end
            end
        end
    end
end

