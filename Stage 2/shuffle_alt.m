
function shuffledDeck = shuffle(originalDeck)
    % SHUFFLE uses a modern version of the Fisher–Yates shuffling method to
    % randomly change the order of elements in a given vector of any length.
    shuffledDeck = originalDeck;
    
    for i=length(originalDeck):-1:2
        % Originally used the rand function instead of randi, code is less
        % clear here.
        swapIndex = round(rand()*(i-1))+1; % random index to swap current element with
        shuffledDeck([i swapIndex]) = shuffledDeck([swapIndex i]);
    end
end
