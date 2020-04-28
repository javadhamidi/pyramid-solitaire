
% NOTE: Added marker for foundational spots on the pyramid

% CREATE DECK

cards = ["A" 2:10 "J" "Q" "K"]; % card values representing ace through king
suits = ["C" "H" "S" "D"]; % suits refered to by first letter (clubs, hearts, spades and diamonds)

deck = []; % initialises deck variable to store all 52 cards

% loop finds all combinations of the cards and suits vectors and assigns
% them to the single deck vector
for card=1:length(cards)
    for suit=1:length(suits)
        deck = [deck cards(card) + suits(suit)];
    end
end

deck = shuffle(deck);


% DEAL PYRAMID ARRAY

% a typical game has the same number of rows and columns, and thus a single
% value can be used here
boardSize = 7;

% following convention, a 7x7 board with 28 cards will be created (given the boardSize variable)
pyramid = strings(boardSize, boardSize);
dealCount = 1;

% since the first column should have 1 card, the second two, the third three,
% etc. (to form a pyramid shape), the range of j increases with each pass. 
for row=1:boardSize
    for col=1:row
        pyramid(row, col) = deck(dealCount);
        dealCount = dealCount + 1;
    end
end

pyramid = vertcat(pyramid, strings(1, boardSize)); % adds an empty bottom row for foundational values
pyramid = horzcat(pyramid, strings(boardSize+1, 1)); % adds an empty side row to prevent index errors


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

% PRINT ARRAY IN PYRAMID FORMAT

board = ""; % stores the visualised game board printed on screen

% loop formats each row of the pyramid vector to a printable string format and adds it to 'board' 
for row=1:boardSize
    % the left padding needed decreases as the number of elements in the row increases
    leftPadding = strjoin(repelem(" ", boardSize+1-row));
    pyramidRow = strjoin(pyramid(row,:), "  "); % each element of each row is separated by two spaces for tidyness
    board = board + leftPadding + pyramidRow + "\n";
end


% clc % command window is cleared on each pass so that changed boards don't visually stack on each other
fprintf(board);
