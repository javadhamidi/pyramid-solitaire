
function [ newStock, newDrawnPile ] = drawCard(stock, drawnPile)
    % DRAWCARD Summary of this function goes here
    % 
    
    newDrawnPile = [ stock(end) drawnPile ];
    newStock = stock(1:end-1);
end
