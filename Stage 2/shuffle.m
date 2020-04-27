
function shuffledDeck = shuffle(originalDeck)
    shuffledDeck = originalDeck;
    
    for i=length(originalDeck):-1:2
        swapIndex = randi([1, i]);
        shuffledDeck([i swapIndex]) = shuffledDeck([swapIndex i]);
    end
end
