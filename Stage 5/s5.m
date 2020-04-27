
lastCommand = "";

while lastCommand ~= "quit"
    commandPrefix = extractBefore(lastCommand, " ");
    
    switch commandPrefix
        case ""
            break
        case ""
            break
        otherwise
            fprintf("The command %s is unrecognised, please try again\n", commandPrefix);
    end
    
    lastCommand = input();
end

fprintf("Thanks for playing!\n");
