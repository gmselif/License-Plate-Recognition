function plateCoordinates=FindPlate(originalImage, binaryImage)

    I = originalImage;
    Ibin = binaryImage;

    originalRow = size(I) * [1;0;0];
    originalProportion = originalRow/400;

    horizontalRectangularShape = [];
    proportions = [];
    hasBlue = [];

    Iprops = regionprops(Ibin,'BoundingBox','Image');
    boundingBox = Iprops(1).BoundingBox;

    %-------------------------------------------------------------------------------------------------------------------
    if numel(Iprops) > 1

        %The indexes of the image parts
        %whose rows are smaller than the number of columns
        %are placed in the horizontalRectangularShape array.
        for i=1:numel(Iprops)
            [row column dep] = size(Iprops(i).Image);

            if row < column
                horizontalRectangularShape = [horizontalRectangularShape i];
            endif
        endfor


        %----------------------------------------------------------------------------------------------------------------
        if length(horizontalRectangularShape) > 1

            %The index value of the image part containing the blue color is saved in the hasBlue array.
            for m=1:length(horizontalRectangularShape)
                Icrop = imcrop(I, Iprops(horizontalRectangularShape(m)).BoundingBox*originalProportion);
                Igray = rgb2gray(Icrop);
                diff_im = imsubtract(Icrop(:,:,3), Igray);
                BW = diff_im > 50;      %Set pixels with RGB value less than 50 to 1 (white), and large ones to 0(black).
                nonzero = find(BW);

                if length(nonzero) > 20
                    hasBlue = [hasBlue horizontalRectangularShape(m)];
                endif
            endfor

            %If the number of image parts containing the blue color is one,
            %the coordinates of this image part are returned.
            %If the number of image fragments containing the color blue is more than one,
            %the column/row ratio of these image parts are saved in the propportions array.
            %--------------------------------------------------------------------------------------------------------------
            k=0;
            if length(hasBlue) > 1

                for j=1:length(hasBlue)
                    [row column dep] = size(Iprops(hasBlue(j)).Image);
                    oran1 = (column/row);
                    proportions = [proportions oran1];
                    k++;
                    if k == length(hasBlue);
                      break;
                    endif
                endfor

                %The coordinates of the image part with the largest column/row ratio is returned.
                for s=1:length(proportions)
                    if s+1 <= length(proportions)
                        if proportions(s) < proportions(s+1)
                            boundingBox = Iprops(hasBlue(s+1)).BoundingBox;
                        endif
                    endif
                endfor

                plateBoundingBox = boundingBox*originalProportion;
                plateCoordinates = plateBoundingBox;

            elseif length(hasBlue) == 1
                display('Only 1 image part containing the color blue could be found.');
                boundingBox = Iprops(hasBlue(1)).BoundingBox;
                plateCoordinates = boundingBox*originalProportion;

            else
                display('No image parts containing the color blue were found.');
                display('Random selection among those with a horizontal rectangular shape.');
                r=randi(horizontalRectangularShape, 1, 1);
                randCoordinates = Iprops(r).BoundingBox;
                plateCoordinates = randCoordinates*originalProportion;
            endif
            %------------------------------------------------------------------------------------------------------------------

        elseif length(horizontalRectangularShape) == 1
            display('Only 1 image part with a horizontal rectangular shape was found.');
            boundingBox = Iprops(horizontalRectangularShape(1)).BoundingBox;
            plateCoordinates = boundingBox*originalProportion;
        else
            display('No image part with horizontal rectangular shape was found. Random guessing:');
            r=randi([1 numel(Iprops)], 1, 1);
            randCoordinates = Iprops(r).BoundingBox;
            plateCoordinates = randCoordinates*originalProportion;
        endif
        %------------------------------------------------------------------------------------------------------------------------


    elseif numel(Iprops) == 1
        display('Only one Bounding Box could be detected.');
        boundingBox = Iprops(1).BoundingBox;
        plateCoordinates = boundingBox*originalProportion;
    else
        display('No bounding boxes detected.');
        plateCoordinates = originalImage;
    endif
    %-------------------------------------------------------------------------------------------------------------------------------
end
