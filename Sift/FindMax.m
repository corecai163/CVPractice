function localMax = FindMax(DoG,numScale,M,N)

for j = 2 : numScale-2
        for m = 2:M-1
            for n = 2:N-1
                isMax = true;
                temp = DoG(j,m,n);
                for x = [-1,1]
                    for y = [-1,1]
                        for z = [-1,1]
                            if DoG(j+x,m+y,n+z) > temp
                                isMax = false;
                            end
                        end
                        if ~isMax
                            break;
                        end
                    end
                    if ~isMax
                        break;
                    end
                end
                if isMax
                   localMax = [localMax; [j,m,n]];
                end
            end
        end
end
    