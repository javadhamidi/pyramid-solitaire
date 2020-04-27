
lastCommand = "start";

while lastCommand ~= "quit"
    clc
    
    if contains(lastCommand, " ")
        commandPrefix = extractBefore(lastCommand, " ");
    else
        commandPrefix = lastCommand;
    end
    
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

fprintf("Thanks for playing!\n\n");
