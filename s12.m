
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

winScreen = " ========= YOU WIN! =========";

% initialising variables
board = ""; % stores the visualised game board printed on screen

lastCommand = "restart force"; % initialises with indicator reset board without user confirmation
message = " Welcome to pyramid! If this is your first time playing you can find the rules \n in 'instructions.txt' or by typing the command 'instructions' below."; % first time user message

% these two messages are used repeatedly in the loop, and thus are defined here for later use
movePairMessage = "Sorry, the combined values of the cards must be equal to 13 to create a pair, try again.";
moveKingMessage = "Invalid move, only kings can be moved directly to the discard pile.";

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
        case "instructions"
            fileContent = fileread('instructions.txt');
            
            clc;
            fprintf("%s", fileContent); % prints instructions.txt
            input("\n* Press enter to return to the game ...\n", 's'); %  user must press enter to continue
        
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
                
                tic; % starts stopwatch
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
            % must have three non-empty parts, source, destination, and the phrase 'move'
            if length(commandSections) == 3 && commandSections(2, 1) ~= "" && commandSections(3, 1) ~= "" 
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
                            
                if isDrawn2Foundation
                    % stores the two indicated cards in their original form (AC, 4S, KH, etc.) 
                    moveSourceCard = drawn(1); % first card in drawn pile
                    moveDestinationCard = cardAtPosition(pyramid, moveDestination);
                    
                    % finds point value of both cards combined
                    pairPointValue = cardPointValue(moveSourceCard) + cardPointValue(moveDestinationCard);
                    
                    if pairPointValue == 13
                        % move source card to discard pile
                        discard = [ discard drawn(1) ];
                        drawn = drawn(2:end);
                        
                        [ discard, pyramid ] = pyramid2Discard(moveDestinationCard, pyramid, discard); % move destination card to discard pile 
                    else
                        message = movePairMessage;
                    end
                    
                elseif isFoundation2Foundation
                    % stores the two indicated cards in their original form (AC, 4S, KH, etc.) 
                    moveSourceCard = cardAtPosition(pyramid, moveSource);
                    moveDestinationCard = cardAtPosition(pyramid, moveDestination);
                    
                    % finds point value of both cards combined
                    pairPointValue = cardPointValue(moveSourceCard) + cardPointValue(moveDestinationCard);
                    
                    if pairPointValue == 13
                        % move source and destination cards to discard pile
                        [ discard, pyramid ] = pyramid2Discard(moveSourceCard, pyramid, discard); 
                        [ discard, pyramid ] = pyramid2Discard(moveDestinationCard, pyramid, discard);
                    else
                        message = movePairMessage;
                    end
                    
                elseif isFoundationKing2Discard
                    % converts the card to its original form (AC, 4S, KH, etc.) 
                    moveSourceCard = cardAtPosition(pyramid, moveSource);
                    
                    if startsWith(moveSourceCard, "K") % confirms that a king is being provided
                        [ discard, pyramid ] = pyramid2Discard(moveSourceCard, pyramid, discard); % moves king to discard pile
                    else
                        message = moveKingMessage;
                    end
                    
                elseif isDrawnKing2Discard
                    % converts the card to its original form (AC, 4S, KH, etc.)  
                    moveSourceCard = drawn(1);
                    
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
    
    % checks if user has completed the pyramid
    if isempty(find(~ismember(pyramid, ""), 1)) % checks if all elements of pyramid are empty
        elapsedTime = toc; % measures elapsed time in seconds
        elapsedTime = elapsedTime / 60; % converts elapsed time to minutes
        
        % prints formatted win message
        fprintf("\n%s\n \n\tYou tackled the pyramid \n\tin %0.2f minutes!\n\n ============================\n\n", winScreen, elapsedTime);
        
        input(" Press enter to return to the\n game ...\n", 's'); % prompts the user to press the enter key to continue
        clc; 
    end
    
    % generates printable board with initial values and updates pyramid
    [ pyramid, board ] = generateBoard(pyramid, boardSize, stock, drawn, discard);
    fprintf(title + board + "\n"); % prints current board
    
    fprintf(message + "\n"); % prints status message 
    
    lastCommand = input("> ", 's');
    
    message = ""; % resets message variable
end

fprintf("Thanks for playing!\n\n"); % message printed when user quits the game
