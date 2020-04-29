
function [ newStock, newDrawnPile ] = drawCard(stock, drawnPile)
    % DRAWCARD moves card from stock to draw pile by removing the last
    % element from the stock vector and prepending it to the drawnPile
    % vector.
    
    newDrawnPile = [ stock(end) drawnPile ];
    newStock = stock(1:end-1);
end
