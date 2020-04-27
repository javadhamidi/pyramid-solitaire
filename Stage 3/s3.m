
% CREATE DECK

cards = ["A" 2:10 "J" "Q" "K"];
suits = ["C" "H" "S" "D"];

deck = [];

for card=1:length(cards)
    for suit=1:length(suits)
        deck = [deck cards(card) + suits(suit)];
    end
end

deck = shuffle(deck);


% DEAL PYRAMID ARRAY

pyramid = strings(6, 6);
dealCount = 1;

for i=1:6
    for j=1:i
        pyramid(i, j) = deck(dealCount);
        dealCount = dealCount + 1;
    end
end


% PRINT ARRAY IN PYRAMID FORMAT

board = "";

for i=1:6
    leftPadding = strjoin(repelem(" ", 7-i));
    pyramidRow = strjoin(pyramid(i,:), "  ");
    board = board + leftPadding + pyramidRow + "\n";
end

clc
fprintf(board);
