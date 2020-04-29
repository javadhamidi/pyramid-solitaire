
% Skeleton code for what processing user input would look like. Not all
% command functionality has been implemented yet.

lastCommand = "start"; % initialises indicator to run starting sequence

while lastCommand ~= "quit"
    clc
    
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
        case "draw"
            fprintf("The stock is empty, try command 'reset' to first reset it.\n");
        case "move"
            break
        case "reset"
            fprintf("The stock needs to be empty before it can be reset, try command 'draw' to get more cards from the stock.\n");
        case "start"
            fprintf("Welcome to pyramid! The rules are simple ...\n");
        case "restart"
            fprintf("Are you sure you want to restart? You may loose all game progress! [type yes or no]\n");
        otherwise
            fprintf("The command %s is unrecognised, please try again.\n", commandPrefix);
    end
    
    lastCommand = input("> ", 's');
end

fprintf("Thanks for playing!\n\n"); % message printed when user quits the game
