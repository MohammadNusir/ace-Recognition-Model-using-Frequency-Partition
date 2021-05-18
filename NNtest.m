function W = NNtest(testImage)
hist = [] ; net = [] ; 
    load('mynet.mat')
    cls = vec2ind(net(imhist(testImage)));
    [~, n] = size(hist);
    W(1) = 0 ; 
    for i = 1 : n
        W(i) = sum(abs(cls - vec2ind(net(hist(:, i)))));
    end
end