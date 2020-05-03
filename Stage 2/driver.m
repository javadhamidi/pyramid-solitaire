
% driver tests that the shuffled deck vector is the expected length and
% that each element only occurs once, two signs that the code works as
% expected

s2

if length(deck) == 52 && length(unique(deck)) == 52 
    fprintf("Success!\n");
else
    fprintf("Test Failed\n");
end