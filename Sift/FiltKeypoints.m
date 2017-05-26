function modifyKeys = FiltKeypoints(candKeys, Dog)
	[numScale,M,N] = size(Dog);
	[C,D] = size(candKeys);

	filt_keys = zeros(3, 0);
	for i = 1:C
		
		% co-ordinates of keypoint
		col = candKeys(i,2) + 1;
		row = candKeys(i,3) + 1;
		lay = candKeys(i,1) + 2;
		dog = Dog(lay, :, :);

		% check edge response to determine if point lies on edge, if yes,
		% then discard
		if (checkEdgeResponse(dog, row, col))

			% quadratic fit to determine location accurately
			[offset val] = QuadraticFit(Dog, lay, row, col);			
			maxMoves = 5; newrow = row; newcol = col;
			while (1)
				if (maxMoves == 0)
					break;
				end
				maxMoves = maxMoves - 1;
				
				r = newrow; c = newcol;
				if ( offset(2) > 0.5 && newrow < M - 2 )
					newrow = newrow + 1;
				elseif ( offset(2) < -0.5 && newrow > 3 )
					newrow = newrow - 1;
				end

				if ( offset(3) > 0.5 && newcol < N - 2 )
					newcol = newcol + 1;
				elseif ( offset(3) < -0.5 && newcol > 3 )
					newcol = newcol - 1;
				end						

				if (r == newrow && c == newcol)
					break;
				end

				[offset val] = QuadraticFit(Dog, lay, newrow, newcol);					
			end

			% the point has been moved, not determine whether to include
			% or not
			if (abs(val) < 0.01)
				continue;
			end
				
			if (abs(offset(1)) > 1.5 || abs(offset(2)) > 1.5 || ... 
				abs(offset(3)) > 1.5)
				continue;
			end

			% add this point to list of filtered keypoints
			lay = round(lay + offset(1));
			row = round(newrow + offset(2));
			col = round(newcol + offset(3));			
			modifyKeys = [modifyKeys; [lay, col, row]];
		end

	end