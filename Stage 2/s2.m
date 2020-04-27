
cards = ["A" 2:10 "J" "Q" "K"];
suits = ["C" "H" "S" "D"];

deck = [];

for card=1:length(cards)
    for suit=1:length(suits)
        deck = [deck cards(card) + suits(suit)];
    end
end

deck = shuffle(deck);

disp(deck);
