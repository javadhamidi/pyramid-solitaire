
cards = ["A" 2:10 "J" "Q" "K"]; % card values representing ace through king
suits = ["C" "H" "S" "D"]; % suits refered to by first letter (clubs, hearts, spades and diamonds)

deck = []; % initialises deck variable to store all 52 cards

% loop finds all combinations of the cards and suits vectors and assigns
% them to the single deck vector
for card=1:length(cards)
    for suit=1:length(suits)
        deck = [deck cards(card) + suits(suit)];
    end
end

disp(deck); % vector is displayed for testing purposes 
