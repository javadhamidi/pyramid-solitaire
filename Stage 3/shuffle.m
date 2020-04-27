
function shuffledDeck = shuffle(originalDeck)
    shuffledDeck = originalDeck;
    
    for i=length(originalDeck):-1:2
        swapIndex = round(rand()*(i-1))+1;
        shuffledDeck([i swapIndex]) = shuffledDeck([swapIndex i]);
    end
end
