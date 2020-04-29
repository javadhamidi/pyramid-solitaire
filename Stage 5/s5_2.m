
% NOTE: Added code from previous stages. Implementation is a bit janky.

cards = ["A" 2:10 "J" "Q" "K"]; % card values representing ace through king
suits = ["C" "H" "S" "D"]; % suits refered to by first letter (clubs, hearts, spades and diamonds)

orderedDeck = []; % deck with cards in order, to be copied and shuffled later

% a typical game has the same number of rows and columns, and thus a single
% value can be used here
boardSize = 7;

% loop finds all combinations of the cards and suits vectors and assigns
% them to the single deck vector
for card=1:length(cards)
    for suit=1:length(suits)
        orderedDeck = [orderedDeck cards(card) + suits(suit)];
    end
end

board = ""; % stores the visualised game board printed on screen

lastCommand = "start"; % initialises with indicator to run starting sequence

while lastCommand ~= "quit"
    clc
    fprintf(board);
    
    % given user commads my include parameters, separated by spaces. 
    % If spaces are included, the parameters are removed, before assigning
    % the command prefix (draw, move, etc.) to a variable
    if contains(lastCommand, " ")
        commandPrefix = extractBefore(lastCommand, " ");
    else
        commandPrefix = lastCommand;
    end
    
    % executes functionality based on command given
    switch commandPrefix
        case "start"
            % copies ordered deck and shuffles it 
            deck = orderedDeck;
            deck = shuffle(deck);
            
            % DEAL PYRAMID ARRAY

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
            
            board = ""; % resets the board variable
            
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

                board = board + leftPadding + pyramidRow + "\n"; % assembles each new row with the board
            end

            fprintf("Welcome to pyramid! The rules are simple ...\n");
        case "draw"
            fprintf("The stock is empty, try command 'reset' to first reset it.\n");
        case "move"
            break
        case "reset"
            fprintf("The stock needs to be empty before it can be reset, try command 'draw' to get more cards from the stock.\n");
        case "restart"
            fprintf("Are you sure you want to restart? You may loose all game progress! [type yes or no]\n");
        otherwise
            fprintf("The command %s is unrecognised, please try again.\n", commandPrefix);
    end
    
    lastCommand = input("> ", 's');
end

fprintf("Thanks for playing!\n\n"); % message printed when user quits the game
