
% Experimentation with unicode symbols for suits, not used in 

cards = ["A" 2:10 "J" "Q" "K"]; % card values representing ace through king
suits = ["\x2663" "\x2665" "\x2660" "\x2666"]; % symbol for each suit is referenced as a unicode value 

deck = []; % initialises deck variable to store all 52 cards

% loop finds all combinations of the cards and suits vectors and assigns
% them to the single deck vector
for card=1:length(cards)
    for suit=1:length(suits)
        deck = [deck cards(card) + suits(suit)];
    end
end

unicodeDeck = []; % unicode values cannot be written directly into a MATLAB script, but can be stored in vectors

% each coded value is turned into a glyph using sprintf, appended to a new vector
for i=1:length(deck)
    unicodeDeck = [unicodeDeck sprintf(deck(i))]; 
end

disp(unicodeDeck); % vector is displayed for testing purposes
