clear all
close all

start_time=tic;% 启动秒表计时器
%cd('D:\adaptdic\fangzhen\fangzhen\myMethod');
ImgNo =7;
MaskType =7;

switch ImgNo
     case 1
          OrgName = 'dambar512.png';
       
     case 2
%         OrgName = 'beachdam.png';
%         OrgName = 'curveball1.png';
%           OrgName='house.tiff';
OrgName='catdam.png';
     case 3
%         OrgName='bardam.png';
        OrgName='cowdam.bmp';
    case 4
        OrgName='lenacolor.png';%lena
    case 5
         OrgName='lenadam.png';
    case 6
        %OrgName='bar512dam.png';
         OrgName='dambaboon3.png';
        %OrgName='bar512dam.png';
    case 7
        OrgName='elephant-input.png';
    case 8
%         OrgName='bengjidam.png';
%         OrgName='erie1.png';
%         OrgName='newball1.png';
            OrgName='fengche1.png';
    case 9
        OrgName='ship-input.png';
    case 10
%         OrgName='house.tiff';
%         OrgName='lena256.png';
       
        OrgName='window256.jpg';
    case 11
        OrgName='bridge-input.png';
    case 12
        OrgName='peppers.jpg';
    case 13
        OrgName='peppers.tiff';
    case 14
        OrgName='house.tiff';
    case 15
        OrgName='peppersdam.png';
    case 16
%         OrgName='damHouse.png';
        OrgName='damPep.png';
    case 17
        OrgName='damDesk.png';
    case 18
        OrgName='damWin.png';
    case 19
        OrgName='zoo.jpg';
        
end


x_org = imread(OrgName);
[n,m,dim]=size(x_org);



x_org=double(x_org);

switch MaskType
    case 1
                mask=ones(512,512);%barbara
                %mask(253:273,258:278)=0;
                %mask(260:280,280:300)=0;%围巾
                %mask(339:359,199:219)=0;
                %mask(162:182,177:197)=0;
                %mask(246:266,50:70)=0;
%                 mask(349-15:349+15,211-15:211+15)=0;%Tex
%                 mask(232-15:232+15,125-15:125+15)=0;%桌子
%                 mask(269-15:269+15,282-15:282+15)=0;%手
                mask(347-10:347+10,429-10:429+10)=0;
                O=mask;
        
    case 2
                mask=ones(256,256);%baboon
                 mask(114-15:114+15,44-15:44+15)=0;
                mask(82-15:82+15,143-15:143+15)=0;
                mask(124-15:124+15,104-15:104+15)=0;
                mask(206-15:206+15,201-15:201+15)=0;

                O=mask;
    case 3
                mask=x_org(:,:,1)==255&x_org(:,:,2)==255&x_org(:,:,3)==255;
                O=~mask;
    case 4
                mask=ones(512,512);%lena
                %mask(395:415,320:345)=0;
                %mask(400:420,330:355)=0;
                %mask(123:143,326:346)=0;
                %mask(84:104,234:254)=0;
                %mask(96:116,123:143)=0;
                %mask(418:438,105:125)=0;
                %mask(411:431,121:141)=0;
                %mask(140-10:140+10,122-10:122+10)=0;%帽子
                 mask(178-10:178+10,118-10:118+10)=0;%帽子
%                   mask(431-10:431+10,361-10:361+10)=0;%肩膀
                 mask(407-10:407+10,344-10:344+10)=0;
                   mask(57-10:57+10,267-10:267+10)=0;
                   
                   mask(86-10:86+10,147-10:147+10)=0;
                   mask(236-10:236+10,413-10:413+10)=0;
                   mask(161-10:161+10,324-10:324+10)=0;
                   mask(456-10:456+10,368-10:368+10)=0;
                    mask(223-10:223+10,64-10:64+10)=0;%1
                   mask(422-10:422+10,124-10:124+10)=0;%10
                   mask(469-10:469+10,285-10:285+10)=0;%9
                O=mask;
    case 5
        mask=x_org(:,:,1)==255&x_org(:,:,2)==0&x_org(:,:,3)==0;
        O=~mask;
    case 6
        mask=x_org(:,:,1)==0&x_org(:,:,2)==0&x_org(:,:,3)==0;
        O=~mask;
    case 7
        mask=rgb2gray(double(imread('elephant-mask.png')));
        O=mask;
    case 8
        mask=x_org(:,:,1)==255&x_org(:,:,2)==255&x_org(:,:,3)==255;
        O=~mask;
    case 9
        mask=rgb2gray(double(imread('ship-mask.png')));
        O=mask;
    case 10
        mask=rgb2gray(double(imread('Text256.png')));
        O=mask;
    case 11
        mask=rgb2gray(double(imread('bridge-mask.png')));
        O=mask;
    case 12
        O = true(n, m);
lines_y = 10;
lines_x = round(m / 2);
nr_x = 1;
nr_y = 3;
i1 = floor(m/4);
i2 = floor(n/(nr_y+1));
for i = 1:nr_x
    ind1 = i*i1;
    for j = 1:nr_y        
        ind2 = j*i2;
        O(ind1:ind1+lines_x-1, ...
            ind2:ind2+lines_y-1) = false(lines_x, lines_y);
    end
end

    case 13
                mask=x_org(:,:,1)==255&x_org(:,:,2)==255&x_org(:,:,3)==255;
                 O=~mask;
   case 14
                mask=ones(size(x_org,1),size(x_org,2));%lena
                %mask(395:415,320:345)=0;
                mask(115-15:115+15,45-15:45+15)=0;
                %mask(123:143,326:346)=0;
                %mask(84:104,234:254)=0;
                %mask(96:116,123:143)=0;
                %mask(418:438,105:125)=0;
                %mask(411:431,121:141)=0;
                O=mask;
    case 15
        mask=x_org(:,:,1)==255&x_org(:,:,2)==255&x_org(:,:,3)==255;
                 O=~mask;
    case 16
        mask=x_org(:,:,1)==0&x_org(:,:,2)==0&x_org(:,:,3)==0;
        O=~mask;
    case 17
        mask=x_org(:,:,1)==255&x_org(:,:,2)==255&x_org(:,:,3)==255;
        O=~mask;
    case 18
        mask=x_org(:,:,1)==255&x_org(:,:,2)==0&x_org(:,:,3)==0;
        O=~mask;
    case 19
        mask=double(imread('zoo-mask.bmp'))~=0;
        O=mask;
    case 20
        mask=ones(512,512);
        mask(142-15:142+15,384-15:384+15)=0;
        mask(469-15:469+15,136-15:136+15)=0;
        mask(315-15:315+15,178-15:178+15)=0;
        mask(139-15:139+15,384-15:384+15)=0;
         mask(82-15:82+15,161-15:161+15)=0;
         mask(223-15:223+15,307-15:307+15)=0;
%         for i=1:5
%         for    j=1:5
%             mask(89*i-10:89*i+10,85*j-10:85*j+10)=0;
%         end
%         end
        O=mask;
end

O=repmat(O,[1 1 3]);

y= x_org.* O;
y=double(y);
Opts = [];

%imwrite(uint8(y),'stonedam.jpg');

if ~isfield(Opts,'PatchSize')
            Opts.PatchSize = 9;
end

if ~isfield(Opts,'alg')
     Opts.alg = 4;
end

if ~isfield(Opts,'SlidingDis')
    Opts.SlidingDis = 4;
 
end

if ~isfield(Opts,'ArrayNo')
    Opts.ArrayNo = 200;
end

if ~isfield(Opts,'SearchWin')
    Opts.SearchWin = 20;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%[x_inpainted,MSE]=adaptdic_inpainting2(Opts,x_org,y,O);
[x_inpainted,MSE,xNum]=my_inpainting(Opts,x_org,y,O);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Save Images
        %img_inpait_name = strcat(OrgName,'_',num2str(csnr(x,x_final,0,0)),'_random_GSR.png');
        %img_inpait_plot_name = strcat(OrgName,'_ratio',num2str(ratio),'_',num2str(csnr(x,x_final,0,0)),'_random_plot_GSR.png');
        %img_missing_name = strcat(OrgName,'_ratio',num2str(ratio),'_',num2str(csnr(x,y,0,0)),'_random_missing.png');
        %imwrite(uint8(x_inpainted),strcat('jinggang',OrgName));
       
        %imwrite(uint8(y),strcat('missing',OrgName));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Sd_time=toc(start_time)
x_org=imread('bar512.bmp');
x_org=double(x_org);
PSNR=psnr_color(x_org, x_inpainted, 255)
SSIM=ssim(x_org, x_inpainted)
img_inpait_name=strcat('my',OrgName,'_psnr',num2str(PSNR),'_time',num2str(Sd_time),'_block.png');
%imwrite(uint8(x_inpainted),strcat('Results\',img_inpait_name));

imshow(uint8(x_inpainted))











