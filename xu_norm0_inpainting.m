function [repatch]=xu_norm0_inpainting(array,goalPatch,estPatch,error,beta,bmask)
%% initialization


sm=[];
preTheta=inf;


D=bmask+sqrt(beta)*(~bmask);
patchT=estPatch.*D;

%% loop
while 1
     for i=1:size(array,2)
         curPatch=array(:,i);
         if isempty(sm)
             union4x=curPatch;
         else
         union4x=union(sm',curPatch','rows')';
         end
         X=union4x.*repmat(D,1,size(union4x,2));
         
         l=ones(size(union4x,2),1);%%列向量
         lT=l';
         
         G=(patchT*lT-X)'*(patchT*lT-X);
         a=inv(G)*l/(lT*inv(G)*l); 
         
         patchP=union4x*a;
         thetaCol(i)=norm(D.*patchP-patchT);
     end
     [valTheta,ind]=sort(thetaCol);
     curTheta=valTheta(1);
     if curTheta<preTheta && curTheta>error
         if isempty(sm)
             sm=array(:,ind(1));
         else
            sm=union(sm',array(:,ind(1))','rows')';
         end
         array(:,ind(1))=[];
     else
         break
     end
     preTheta=curTheta;
end

%%
X=sm.*repmat(D,1,size(sm,2));         
l=ones(size(sm,2),1);%%列向量
lT=l';         
G=(patchT*lT-X)'*(patchT*lT-X);
a=inv(G)*l/(lT*inv(G)*l); 

repatch=sm*a;
repatch=goalPatch+repatch.*(~bmask);
