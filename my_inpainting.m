function [x_inpainted,MSE,xNum]=my_inpainting(Opts,x_org,y,mask);

SearchWin=Opts.SearchWin;
PatchSize    =    Opts.PatchSize;
PatchSize2    =   PatchSize*PatchSize;
mm=Opts.SearchWin*2+1;
nn=mm;
m=Opts.PatchSize*3;
n=m;
error=5;
beta=0.25;

alg=Opts.alg;
% orderType='gradientSum';
orderType='Sparse';
landa=0.5;
Img=y;

[Hight Width ~]   =   size(y);

strucsparse=zeros(Hight, Width);
strucsparseT=zeros(Hight, Width);
Pixstrucsparse=zeros(Hight, Width);
xNum=[];

fillRegion=~mask(:,:,1);
sourceRegion = ~fillRegion;
sz = [size(y,1) size(y,2)];

C = double(sourceRegion);
%D = repmat(-.1,sz);



while any(fillRegion(:))%%%1值为待修复点
    
    PatchSize=Opts.PatchSize;
    w=(Opts.PatchSize-1)/2;
    
    ArrayNo   =   Opts.ArrayNo;
    
    dR = find(conv2(double(fillRegion),[1,1,1;1,-8,1;1,1,1],'same')>0);%进行卷积以找到边界，dR为一组列向量，表示边界坐标
    
    
    
    kk=1;
    for k = dR'
        [Hp,rows,cols] = getpatch(sz,k,w);%Hp为一7*7矩阵，矩阵值是待修复块坐标
        [Hp41,rows41,cols41] = getpatch(sz,k,SearchWin);
        q = Hp(~(fillRegion(Hp)));%q为一个列向量矩阵,为该修复块已知像素点的坐标
        %q41 = Hp41(~(fillRegion(Hp41)));
        C(k) = sum(C(q))/numel(Hp);%计算置信度
        
       % C(dR)=(1-0.2)/(max(C(dR)-min(C(dR))))*(C(dR)-min(C(dR)))+0.2;%置信度映射到（0.2-1）
        
        knowind=find(fillRegion(Hp)==0);
        unknowind=find(fillRegion(Hp)==1);
        knowind=[knowind;knowind+PatchSize*PatchSize;knowind+2*PatchSize*PatchSize];
        y1=y(rows,cols,1);
        y2=y(rows,cols,2);
        y3=y(rows,cols,3);
        %patchgoal=reshape(y(rows,cols,:),PatchSize2*3,1);
        %[rowsp,colsp]=ind2sub(size(y,1),k);
        %[CurArray,Dp,wpNv,wpAll,CurArrayAll]  =  PatchSearchline3(rowsp, colsp, ArrayNo, SearchWin, fillRegion,y,PatchSize,patchgoal,knowind);
        imgpatch1=y(rows41,cols41,1);
        imgpatch2=y(rows41,cols41,2);
        imgpatch3=y(rows41,cols41,3);
        origImg1=y(rows,cols,1);
        origImg2=y(rows,cols,2);
        origImg3=y(rows,cols,3);
        toFill1 = fillRegion(Hp);
        fillRegionp=~fillRegion(Hp41);
        
      
        [best,indexm,indexn,dd]=mypatchdsts(41,41,PatchSize,PatchSize,imgpatch1,imgpatch2,imgpatch3,origImg1,origImg2,origImg3,toFill1,fillRegionp);
        
        best=best(1:dd);
        
        
        wp=exp(-sqrt(best)/25);
        wp=wp./sum(wp);
        Dp=norm(wp,2)*sqrt(dd/((41-7)^2));
       
        j_num=numel(wp);
        ns=sqrt(j_num/((mm-m)*(nn-n)));
        nS=sqrt(1/((mm-m)*(nn-n)));
        strucsparse(k)=(0.8*Dp+0.2*ns-nS)/(ns-nS);
        strucsparseT(k)=Dp;
        strucsparseVec(kk)=strucsparse(k);
        kk=kk+1;
        
        
          
        
    end

 % Compute patch priorities = confidence term * data term
 
 
    
   unuseind=find(strucsparse==0);
   %Pixstrucsparse(dR)=(1-0.2)/(max(Pixstrucsparse(dR)-min(Pixstrucsparse(dR))))*(Pixstrucsparse(dR)-min(Pixstrucsparse(dR)))+0.2;
   strucsparse(unuseind)=0;%没又足够的相似块，置零
   
    priorities =strucsparse(dR).*C(dR);
    %priorities =strucsparse(dR)*0.5+C(dR)*0.5;
     % Find patch with maximum priority, Hp
    [unused,ndx] = max(priorities);
    p = dR(ndx(1));%p为待修复块的中心坐标点
    [rowsp,colsp]=ind2sub(size(y,1),p);
    [Hp,rows,cols] = getpatch(sz,p,w);%找到优先权最大的块，Hp为一7*7矩阵，矩阵值是待修复块坐标
    
    
    patchgoal=reshape(y(rows,cols,:),PatchSize2*3,1);
    maskind=find(fillRegion(Hp)==1);
    maskind=[maskind;maskind+PatchSize*PatchSize;maskind+2*PatchSize*PatchSize];
    knowind=find(fillRegion(Hp)==0);
    knowind=[knowind;knowind+PatchSize*PatchSize;knowind+2*PatchSize*PatchSize];
    bmask=~fillRegion(Hp);
    bmask=bmask(:);
    bmask=repmat(bmask,3,1);
    
        [rowsp,colsp]=ind2sub(size(y,1),p);
        
        Dp=strucsparse(p)
        
       
        
        
       [CurArray,Dp,wpNv,wpAll,CurArrayAll]  =  PatchSearchline4(rowsp,colsp, ArrayNo, SearchWin, fillRegion,y,PatchSize,patchgoal,knowind,mm);
       
       %[G]=Gmatrix(patchgoal,CurArray,bmask);
       [W,meanCurArray]=Wmatrix(patchgoal,CurArray,maskind,bmask,wpNv);
       
       
        estPatch=patchgoal+meanCurArray.*(~bmask);
        v=repmat(estPatch,1,size(CurArray,2));
 
      
       
        [repatch]=xu_norm0_inpainting(CurArray,patchgoal,estPatch,error,beta,bmask);
       
        
       toFill=fillRegion(Hp);
       fillRegion(Hp)=0;
       sourceRegion=~fillRegion;
       
       
       
       repatch=reshape(repatch,[PatchSize,PatchSize,3]);
       
       repatch=reshape(repatch,[PatchSize,PatchSize,3]);
       y(rows,cols,:)=repatch;
       
       
        
       C(Hp(toFill))  = C(p);%更新置信度
       clear strucsparseVec
       
       
       
       figure(2);
       imshow(uint8(y));
       title('Inpainting in progress...');
        
%end   
end
%x_inpainted = ImgTemp./(ImgWeight+eps);

x_inpainted=y;
MSE=sum(sum((x_inpainted-x_org).^2))/numel(x_inpainted);

return