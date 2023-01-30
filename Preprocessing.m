function processedImage=Preprocessing(carImage)

    f=imresize(carImage,[400 NaN]);                                                                         %Resmi 400 satır yapar. Sütunu otomatik ayarlanır.

    g=rgb2gray(f);

    g=medfilt2(g,[3 3]);                                                                                    %Resimdeki noise giderilir ve bulanıklaşır

    se=strel('disk',1, 0);
    gi=imdilate(g,se);                                                                                      %Beyaz yerler daha da beyaz olur.

    ge=imerode(g,se);                                                                                       %1 yarıçaplı diskle aşındırma yapılarak kenarlar keskinleşiyor.

    gdiff=imsubtract(gi,ge);                                                                                %gi ve ge arasındaki fakl alınarak edge oluşturuyor.

    gdiff=mat2gray(gdiff);                                                                                  %Kenar çizgileri daha beyaz oluyor.Resimdeki en yüksek ve düşük piksel değerini seçiyor. Bütün resim bu 2 değerden oluşacak şekilde ayarlanıyor.

    gdiff=conv2(gdiff,[1 1;1 1]);                                                                           %C=conv2(A,B) --> A=mxn, B=kxh --> C=(m+k-1)x(n+h-1) olur. gdiff için satır ve sütun sayısı değişmez. Kenar çizgileri daha da beyaz olur.

    gdiff=imadjust(gdiff,[0.5 0.7],[0 1]);                                                                  %Kontrast artırır.

    B=round(gdiff);                                                                                         %gdiff'in tüm elemanları en yakın tamsayıya yuvarlanır.

    F=imfill(gdiff,'holes');

    H=bwmorph(F,'thin',1);                                                                                  %thin operasyonunu 1 kere uygular. Yani resimdeki çizgiler inceleştirilir.

    H=imerode(H,strel('line',3,90));                                                                        %90 derecelik 3 uzunluğunda line oluşturulur. Buna eşit veya küçük olan çizgiler silinir.

    final=bwareaopen(H,100);                                                                                %Boyu veya genişliği 100 den küçük olanları siler.

    processedImage=final;
end
