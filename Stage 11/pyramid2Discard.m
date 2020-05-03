
function [ discard, pyramid ] = pyramid2Discard(card, pyramid, discard)
    % PYRAMID2DISCARD This function moves a card in the pyramid to the
    % discard pile, a very small piece of highly repeated functionality.

    discard = [card discard]; % moves card to discard pile
    pyramid(pyramid == card) = "";  % makes element blank where pyramid == card
end

