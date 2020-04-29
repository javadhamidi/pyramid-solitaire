
% NOTE: Moved some code to a new 'generateBoard' function, as it may be
% repeatedly used throughout the script. Haven't met mvp yet.

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
    % clears screen and prints current board
    clc
    fprintf(board + "\n");
    
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


            board = generateBoard(pyramid, boardSize);

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
