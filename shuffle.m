
function shuffledDeck = shuffle(originalDeck)
    % SHUFFLE uses a modern version of the Fisher–Yates shuffling method to
    % randomly change the order of elements in a given vector of any length.
    shuffledDeck = originalDeck;
    
    for i=length(originalDeck):-1:2
        swapIndex = randi([1, i]); % random index to swap current element with
        shuffledDeck([i swapIndex]) = shuffledDeck([swapIndex i]);
    end
end
