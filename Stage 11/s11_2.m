
% Note: reduced repeated code related to 'move' input

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
                % moves card from stock to drawn cards pile
                drawn = [ stock(end) drawn ]; % adds last card of stock to drawn cards pile
                stock = stock(1:end-1); % removes that last card from stock
            else
                message = "The stock is empty, try command 'reset' to first reset it.";
            end
        case "move"
            commandSections = split(lastCommand); % splits the move command into each of its elements
            if length(commandSections) == 3 % must have three parts, source, destination, and the phrase 'move'
                moveSource = string(commandSections(2)); % second element of the move command indicates the source
                moveDestination = string(commandSections(3)); % third element indicates the destination
                
                % first allowed move: user can move card from waste to foundation if both card values add up to 13
                isDrawn2Foundation = moveSource == "drawn" && ...
                                ~isempty(drawn) && ...  % ensures a card exists in the draw pile
                                isFoundationNumber(moveDestination, board);
                
                % second allowed move: one card on the foundation can be moved onto another if the total value is 13
                isFoundation2Foundation = isFoundationNumber(moveSource, board) && ... 
                                isFoundationNumber(moveDestination, board); % checks that both are valid foundational values
                
                % third allowed move: kings can be moved directly to the discard pile if in the draw pile or on the foundation
                isFoundationKing2Discard = moveDestination == "discard" && ...
                                isFoundationNumber(moveSource, board);
                            
                isDrawnKing2Discard = moveDestination == "discard" && ...
                                ~isempty(drawn) && ...
                                moveSource == "drawn";
                
                % sets source
                if isDrawn2Foundation || isDrawnKing2Discard
                    moveSourceCard = drawn(1);
                elseif isFoundation2Foundation || isFoundationKing2Discard
                    moveSourceCard = cardAtPosition(pyramid, moveSource);
                end
                
                % sets destination
                if isDrawn2Foundation || isFoundation2Foundation
                    moveDestinationCard = cardAtPosition(pyramid, moveDestination);
                    
                    pairPointValue = cardPointValue(moveSourceCard) + cardPointValue(moveDestinationCard);
                end
                
                if isDrawn2Foundation                    
                    if pairPointValue == 13
                        % move source card to discard pile
                        discard = [ discard drawn(1) ];
                        drawn = drawn(2:end);
                        
                        % move destination card to discard pile
                        discard = [moveDestinationCard discard]; 
                        pyramid(pyramid == moveDestinationCard) = ""; % makes element blank where pyramid == moveDestinationCard 
                    else
                        message = "Sorry, the combined values of the cards must be equal to 13 to create a pair, try again.";
                    end
                    
                elseif isFoundation2Foundation

                    if pairPointValue == 13
                        % move source card to discard pile
                        discard = [moveSourceCard discard]; 
                        pyramid(pyramid == moveSourceCard) = ""; 
                        
                        % move destination card to discard pile
                        discard = [moveDestinationCard discard]; 
                        pyramid(pyramid == moveDestinationCard) = ""; 
                    else
                        message = "Sorry, the combined values of the cards must be equal to 13 to create a pair, try again.";
                    end
                    
                elseif isFoundationKing2Discard

                    if startsWith(moveSourceCard, "K") % confirms that a king is being provided
                        % moves king to discard pile
                        discard = [moveSourceCard discard]; 
                        pyramid(pyramid == moveSourceCard) = ""; 
                    else
                        message = "Invalid move, only kings can be moved directly to the discard pile.";
                    end
                    
                elseif isDrawnKing2Discard

                    if startsWith(moveSourceCard, "K") % confirms that a king is being provided
                        % moves king to discard pile (from drawn cards pile)
                        discard = [ discard drawn(1) ];
                        drawn = drawn(2:end);
                    else
                        message = "Invalid move, only kings can be moved directly to the discard pile.";
                    end 
                    
                else
                    message = "Invalid move, please ensure the source and destination exist and that a legal move is being made.";
                end
            else
                message = "The move command requires two parameters using the syntax 'move <source> <destination>', try again.";
            end
        case "reset"
            % checks if stock is empty, and moves all elements in vector drawn to stock
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
    
    pyramid(pyramid == "*") = ""; % resets foundation indicators on the board
    
    % generates printable board with initial values and updates pyramid
    [ pyramid, board ] = generateBoard(pyramid, boardSize, stock, drawn, discard);
    fprintf(title + board + "\n"); % prints current board
    
    fprintf(message + "\n"); % prints status message 
    
    lastCommand = input("> ", 's');
    
    message = ""; % resets message variable
end

fprintf("Thanks for playing!\n\n"); % message printed when user quits the game
