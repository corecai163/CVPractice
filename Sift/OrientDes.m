% To achieve rotation invariance
% Compute central derivatives, gradient magnitude and direction of L (smooth
% image) at the scale of key point (x,y)
function keyPoints = OrientDes(keys, I)
    % Create a weighted direction
    % histogram in a neighborhood of
    % a key point (36 bins)
    num_bins = 36;
	ortHist = zeros(num_bins, 1);
	keyPoints = [];
    
    [S,M,N] = size(I);
    for scale = 1:S-1
        temp = find(keys(:,1) == scale);
        if ~isempty(temp)
            [gx,gy] = gradient(I(scale,:,:));
            grad = sqrt(gx.^2+gy.^2);
            ort = atan2(gy./gx);
            for ind = 1:len(temp)
                x = round(temp(ind,2));
                y = round(temp(ind,3));
                	% iterate through all points in the window
                for i = 2:M-1
                    for j = 2:N-1
                        distnc =  norm([i j] - [x y]);
                        gradVal = grad(i, j);
                        if  gradVal > 0			
                            ortAng = ort(i, j);
                            binNo = round(num_bins * (ortAng + pi) / (2 * pi));
                            if (binNo == 0)
                                binNo = num_bins;
                            end
                            w = exp(-1 * distnc * distnc / ( 2 * sig * sig ));	
                            ortHist(binNo) = ortHist(binNo) + w * gradVal;			
                        end
                    end
                end

                % smooth the histogram
                ortHist = smoothHist(ortHist);

                % the threshold for creating a keypoint is 80% of the 
                % highest peak in the histogram
                thresh = 0.8 * max(ortHist);

                % iterate through the histogram, looking for
                % peaks that are local maxima and higher than threshold
                for i = 1:num_bins
                    if (i == 1)
                        prev = num_bins;
                    else
                        prev = i - 1;
                    end
                    if (i == num_bins)
                        next = 1;
                    else
                        next = i + 1;
                    end
                    if (ortHist(i) > ortHist(prev) && ortHist(i) > ortHist(next) ... 
                        && ortHist(i) > thresh)

                        % make a parabolic fit over the three histogram bars
                        peakVal = fitParabola(ortHist(prev), ortHist(i), ortHist(next));

                        % compute orientation angle and create a keypoint at (x, y)
                        ortAngle = ( ((i + peakVal) / num_bins) * 2 * pi ) - pi;

                        % build the descriptor for this point
                        desc = buildDesc(grad, ort, scale, x, y, ortAng, 0.5);
                        keypoints = [keypoints; desc];

                    end
                end
            end
        end
    end
end