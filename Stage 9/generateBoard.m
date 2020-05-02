
function [ pyramid, board ] = generateBoard(pyramid, boardSize, stock, drawnCards, discard)
    % GENERATEBOARD is given information about the game, and produces a
    % string that can be printed to visualise the game board.
    
    % ADD FOUNDATION VALUES TO CARD PYRAMID

    % loop checks for the pyramids foundations, and marks spaces with a *. Only
    % cards on the foundation can be affected directly by user action
    for row=1:boardSize
        for col=1:row
            % checks to make sure a card value is in the given position
            if pyramid(row, col) ~= "" && pyramid(row, col) ~= "*" 
                % ensures both cell directly below, and cell below to the right are both empty
                if pyramid(row+1, col) == "" && pyramid(row+1, col+1) == ""
                    pyramid(row+1, col) = "*"; % star is used to represent available space on the foundation
                end
            end
        end
    end

    % PRINT ARRAY IN PYRAMID FORMAT & PRINT MARKERS FOR THE PYRAMID'S FOUNDATION

    board = ""; % initialises visualised game board to be printed on screen

    foundationMarker = 1; % foundation markes will be represented by numbers from zero to one

    % loop formats each row of the pyramid vector to a printable string format and adds it to 'board' 
    for row=1:boardSize+1
        % the left padding needed decreases as the number of elements in the row increases
        leftPadding = strjoin(repelem(" ", boardSize+1-row));

        pyramidRow = "";

        for col=1:boardSize
            currentCell = pyramid(row, col); % current cell to manipulate and print

            % numbers exposed parts of the foundation, marked by asterisks
            if currentCell == "*"
                pyramidRow = pyramidRow + " " + foundationMarker + "  ";
                foundationMarker = foundationMarker + 1;

            % checks for empty cells (within the pyramid structure) and adds extra spacing
            elseif currentCell == "" && col < row
                pyramidRow = pyramidRow + "    ";

            % all card values (A, 2, 3, Q, K) are one character long, except
            % for 10, which offsets the spacing of each row. Two avoid this,
            % only one trailing space is added, instead of two like all other values 
            elseif startsWith(currentCell, "10")
                pyramidRow = pyramidRow + pyramid(row, col) + " "; % only one space added

            % adds double spacing for all card values (7C, 2D, etc.), other than 10   
            else
                pyramidRow = pyramidRow + pyramid(row, col) + "  "; % each element of each row is separated by two spaces for tidyness
            end
        end
        
        switch row
            case 1 % add card stock indicator at the end of the first row
                pyramidRow = pyramidRow + "CARDS IN STOCK: " + length(stock);
            case 2 % add drawn card indicator at the end of the second row
                pyramidRow = pyramidRow + "DRAWN CARD: ";
                if ~isempty(drawnCards) % outputs 'None' if vector is empty, otherwise gives first element
                    pyramidRow = pyramidRow + drawnCards(1);
                else
                    pyramidRow = pyramidRow + "None";
                end
            case 4 % add discard pile indicator at the end of the fourth row
                pyramidRow = pyramidRow + "CARDS IN DISCARD: " + length(discard);
        end
        
        board = board + leftPadding + pyramidRow + "\n"; % assembles each new row with the board
    end
end
