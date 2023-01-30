function plateCode=FindPlateCode(licensePlate)

    Igray = rgb2gray(licensePlate);

    %A median filter is used to filter out the noise.
    Igray = medfilt2(Igray ,[3 3]);

    %Set pixels with RGB value less than 50 to 0(black),
    %and large ones to 1(white).
    binary = Igray < 50;

    [row, column] = size(binary);

    %Objects inside the Plate are kept in the variable Iprops.
    Iprops = regionprops(binary, 'BoundingBox', 'Image');
    count = numel(Iprops);

    numberPlate=[];

    %All objects in the License Plate are visited one by one.
    %These objects are sent to the Letter_detection function.
    %In Letter_detection function,
      %if the object corresponds to a letter or a number,
      %it returns that letter or number.
    %This returned value is kept in the variable letter.
    %All values of the letter variable are saved in the variable numberPlate.
    for i=1:count

        [row2 column2] = size(Iprops(i).Image);

        if row2>column2 && row2>(row/4) && column2>row2/4
            letter = Letter_detection(Iprops(i).Image);
            numberPlate = [numberPlate letter];
        end
    end
    numberPlate

    if length(numberPlate) > 2
        number=['0' '1' '2' '3' '4' '5' '6' '7' '8' '9'];
        index=0;

        for a=1:2
            c1=0;
            c2=0;
            index = length(numberPlate)+1-a;

            for b=1:length(number)

                %Control of the first 2 elements of numberPlate
                if ~strcmp(numberPlate(a), number(b))
                    c1++;
                    if c1==length(number)
                        switch numberPlate(a)
                            case {'B', 'S'}
                                numberPlate(a) = '8';
                            case 'E'
                                numberPlate(a) = '5';
                            case {'O', 'D'}
                                numberPlate(a) = '0';
                            case 'Z'
                                numberPlate(a) = '2';
                            case 'L'
                                numberPlate(a) = '4';
                        end
                    endif
                endif

                %Control of the last 2 elements of numberPlate
                if ~strcmp(numberPlate(index),number(b))
                    c2++;
                    if c2==length(number)
                        switch numberPlate(index)
                            case 'B'
                                numberPlate(index) = '8';
                            case 'E'
                                numberPlate(index) = '5';
                            case {'O', 'D'}
                                numberPlate(index) = '0';
                            case 'Z'
                                numberPlate(index) = '2';
                            case 'U'
                                numberPlate(index) = '9';
                            case 'L'
                                numberPlate(index) = '4';
                            case 'J'
                                numberPlate(index) = '8';
                        end
                    endif
                endif

                %Control of the third element of numberPlate
                if strcmp(numberPlate(3), number(b))
                    switch b
                        case 1
                            numberPlate(3) = 'D';
                        case 3
                            numberPlate(3) = 'Z';
                        case 5
                            numberPlate(3) = 'A';
                        case 6
                            numberPlate(3) = 'S';
                        case 7
                            numberPlate(3) = 'G';
                        case 8
                            numberPlate(3) = 'Z';
                        case 9
                            numberPlate(3) = 'B';
                    end
                endif
            endfor
        endfor

        plateCode=numberPlate;
    else
        display('Less than 3 letters and numbers could be detected in the image.');
        plateCode=[];
    endif
end
