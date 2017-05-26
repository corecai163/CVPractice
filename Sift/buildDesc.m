% Sample keypoints in a circular neighbourhood of given point and build 
% the keypoint descriptor vector
% 
% Given
% 	grad : M x N matrix of gradient magnitudes
% 	ort : M x N matrix of gradient orientations 
%	kpScale : scale of layer containing the point
%	x : row number of point
%	y : col number of point
% 	ortAng : The orientation angle of this point
%	zoomLevel : down-sampling factor
% Return
% 	desc : The descriptor vector for this keypoint
function desc = buildDesc(grad, ort, kpScale, x, y, ortAng, zoomLevel)

	[M N] = size(grad);

	% These go into the final descriptor vector	
	orig_x = zoomLevel * x; 		% keypoint position in original image
	orig_y = zoomLevel * y; 
	scl = zoomLevel * kpScale; 			% scale relative to first image in first octave		

	% we are building a 4x4 array of orientation histograms
	sampleSize = 4;	
	num_orients = 8;
	windowWid = 3 * kpScale;

	% histogram for local descriptor
	histogram = zeros(sampleSize, sampleSize, num_orients);

	% compute radius of the circle	
	radius = round(( sqrt(2) * (sampleSize + 1) * (windowWid) ) / 2);
	sig = 0.5 * sampleSize;

	% iterate through points that can lie inside the 16x16 region
	for i = -radius:radius
		for j = -radius:radius			
			
			% check if the point lies inside the image boundaries
			if (x + i >= 1 && x + i <= M && ...
				y + j >= 1 && y + j <= N)

				% rotate offset (i, j) to be relative to orientation of the keypoint			
				temp = (1 / (windowWid)) * ...
							( [cos(ortAng) -sin(ortAng); ... 
							   sin(ortAng) cos(ortAng)] * [i; j] ) + ...
								[ sampleSize / 2 + 1; sampleSize / 2 + 1 ];
				drow = temp(1); dcol = temp(2);

				% check if (drow, dcol) is a valid index into the descriptor array (4x4)
				if (drow > 0 && drow < (sampleSize + 1) && ...
					dcol > 0 && dcol < (sampleSize + 1))

					% compute the weight of this sample point
					temp = [drow; dcol] - [sampleSize / 2 + 1; sampleSize / 2 + 1];
					offr = temp(1); offc = temp(2);
					w = exp( -(offr * offr + offc * offc) / (2 * sig * sig) );
					gradVal = grad(round(x + i), round(y + j));

					% weighted value to be added into histogram
					wv = w * gradVal;

					% compute orientation w.r.t. orientation of keypoint
					ortVal = ort(round(x + i), round(y + j)) - ortAng;
					ortVal = rem(ortVal, 2 * pi);
					if (ortVal < 0)
						ortVal = ortVal + 2 * pi;
					end

					% what direction?
					dirct = num_orients * ( ortVal / (2 * pi) );	
					
					% round off the indexes
					drow_r = round(drow);
					dcol_r = round(dcol);
					dirct_r = round(dirct);
					drow_f = drow - drow_r;
					dcol_f = dcol - dcol_r;
					dirct_f = dirct - dirct_r;										

					% now update the appropriate histograms
					for it = 0:1
						ri = drow_r + it;
						if (ri >= 1 && ri <= sampleSize)
							rowt = gradVal * ite(it == 0, 1 - drow_f, drow_f);
							for jt = 0:1
								ci = dcol_r + jt;
								colwt = rowt * ite(jt == 0, 1 - dcol_f, dcol_f);
								if (ci >= 1 && ci <= sampleSize)
									for kt = 0:1
										oi = dirct_r + kt;
										if (oi > num_orients)
											oi = 1;
										end										
										ortwt = colwt * ite(kt == 0, 1 - dirct_f, dirct_f);
										if (oi >= 1 && oi <= num_orients)
											histogram(ri, ci, oi) = ...
												histogram(ri, ci, oi) + ortwt;
										end
									end
								end

							end
						end

					end					

				end

			end			

		end
	end

	% unroll the 3d histogram into a vector
	desc = reshape(histogram, 1, sampleSize * sampleSize * num_orients);
	desc = ( 1 / norm(desc) ) * desc;

	% limit values in the vector at 0.2
	desc = min(desc, 0.2);
	desc = ( 1 / norm(desc) ) * desc;

	% add the x and y position, scale and orientation
	desc = [orig_x, orig_y, scl, ortAng, desc];
	fprintf('Keypoint added: (%d, %d)\n', orig_x, orig_y);
	