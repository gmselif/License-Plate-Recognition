for i=1:100
    pathR = ['C:\Users\DELL\Desktop\Car\car' num2str(i) '.jpg']
    originalImage = imread(pathR);

    processedImage = Preprocessing(originalImage);

    plateCoordinates = FindPlate(originalImage, processedImage);

    licensePlate = imcrop(originalImage, plateCoordinates);

    numberPlate=[];
    numberPlate = FindPlateCode(licensePlate)

    if length(numberPlate) ~= 0
        finalImage = DrawOnImage(originalImage, plateCoordinates, numberPlate);

        pathW = ['C:\Users\DELL\Desktop\Car\Output\a' num2str(i) '.jpg']
        saveas(finalImage, pathW);
    endif
end
