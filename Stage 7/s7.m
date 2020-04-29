
% NOTE: Added indicators for the title, number of cards in stock and
% discard piles, and the currently drawn card. Also implemented game
% restarting functionality.

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

title = " ========= PYRAMID =========\n\n";

% initialising variables
board = ""; % stores the visualised game board printed on screen

lastCommand = "restart force"; % initialises with indicator reset board without user confirmation
message = "Welcome to pyramid! The rules are simple ..."; % first time user message

while lastCommand ~= "quit"           
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
        case "restart"
            % will skip user confirmation and automatically continue restarting the game
            if lastCommand == "restart force"
                confirmRestart = "yes";
            else % otherwise asks user to confirm restart request
                clc;
                fprintf("Are you sure you want to restart? You will loose all game progress!\n");
                confirmRestart = input("[type yes to confirm]> ", 's');
            end
            
            if confirmRestart == "yes"
                % reset deck variables
                stock = [];
                drawn = []; % cards drawn from stock
                discard = []; % discard pile

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

                cardsInPyramid = (boardSize^2 + boardSize)/2; % calculates number of cards in the pyramid
                stock = deck(cardsInPyramid+1:end); % puts remaining cards in stock
            end
        case "draw"
            if ~isempty(stock)
                [stock, drawn] = drawCard(stock, drawn); % uses drawCard to manipulate vectors
            else
                message = "The stock is empty, try command 'reset' to first reset it.";
            end
        case "move"
            break
        case "reset"
            if isempty(stock)
                stock = drawn;
                drawn = [];
            else
                message = "The stock needs to be empty before it can be reset, try command 'draw' to get more cards from the stock.";
            end
        otherwise
            message = sprintf("The command %s is unrecognised, please try again.", commandPrefix);
    end
    
    clc; % clears screen
    
    % generates printable board with initial values
    board = generateBoard(pyramid, boardSize, stock, drawn, discard);
    fprintf(title + board + "\n"); % prints current board
    
    fprintf(message + "\n");
    
    lastCommand = input("> ", 's');
    
    message = ""; % resets message variable
end

fprintf("Thanks for playing!\n\n"); % message printed when user quits the game
