
function value = cardPointValue(card)
    % CARDPOINTVALUE Calculates point value of a given card. Note that the
    % cardsOrder variable is repeated in the main script, however, passing 
    % that variable in each time this function is called would make the
    % code longer and less readable.
    
    
    % all possible card faces in order of value from lowest to highest, 
    % such that their index is equal to their point value (A=1, 5=5, K=13)
    cardsOrder = ["A" 2:10 "J" "Q" "K"]; 
    
    % since card suit does not affect point value, the suit indicator is 
    % removed from the card variable (by removing the last letter of the string)
    card = extractBetween(card, 1, strlength(card)-1);
    
    % find command does not work on vectors of strings, so contains
    % function first creates a vector where matches are represented by 1 
    match = find(contains(cardsOrder, card));
    
    if length(match) == 1 % only one match should be possible
        value = match;
    end
end

