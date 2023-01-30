function finalImage=DrawOnImage(originalImage, plateCoordinates, numberPlate)

    fh=figure;
    imshow(originalImage);
    hold on;

    %Draws an rectangle around the license plate.
    rectangle('Position', plateCoordinates, 'EdgeColor', "#4DBEEE", 'LineWidth', 2);

    %Prints the previously found license plate code on the image.
    text( plateCoordinates(1),...
          plateCoordinates(2),...
          numberPlate,...
          'Color', 'w',...
          'FontWeight', 'bold',...
          'FontSize', 12,...
          'Margin', 1,...
          'BackgroundColor',"#4DBEEE",...
          'VerticalAlignment', 'baseline',...
          'HorizontalAlignment', 'left');

    finalImage = gcf;
end
