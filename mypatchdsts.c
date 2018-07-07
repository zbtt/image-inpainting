#include "mex.h"
#include <limits.h>


void mypatchdst(const int mm, const int nn, const int m, const int n,
			const double *img1,const double *img2,const double *img3, const double *Ip1, const double *Ip2,const double *Ip3,
			const mxLogical *toFill, const mxLogical *sourceRegion,
			double *best, double *indexm, double *indexn, double *dd) 
{
  register int i,j,ii,jj,ii2,jj2,M,N,I,J,ndx,ndx2,mn=m*n,mmnn=mm*nn;
  double patchErr=0.0,err1=0.0,err2=0.0,err3=0.0;
  int s=0;
  /* foreach patch */
  N=nn-n+1;  M=mm-m+1;
  for (j=1; j<=N; ++j) 
  {
    J=j+n-1;
    for (i=1; i<=M; ++i) 
	{
      I=i+m-1;
      /*** Calculate patch error ***/
      /* foreach pixel in the current patch */
      for (jj=j,jj2=1; jj<=J; ++jj,++jj2) 
	  {
		for (ii=i,ii2=1; ii<=I; ++ii,++ii2) 
		{
			ndx=ii-1+mm*(jj-1);
			 if (!sourceRegion[ndx])
				goto skipPatch;
			 ndx2=ii2-1+m*(jj2-1);
			 if (!toFill[ndx2]) 
			  {
				err1=img1[ndx] - Ip1[ndx2]; 
                err2=img2[ndx] - Ip2[ndx2];
                err3=img3[ndx] - Ip3[ndx2];
				patchErr += (err1*err1+err2*err2+err3*err3);
			  }
		}
      }
      /*** Update ***/
		 
		best[s] = patchErr ;
		indexm[s] = i;
        indexn[s] = j;
 		s=s+1;
		
      /*** Reset ***/
    skipPatch:
      patchErr = 0.0; 
    }
  }
  *dd=s;
}

/* best = bestexemplarhelper(mm,nn,m,n,img,Ip,toFill,sourceRegion); */
void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[]) //nlhs 输出个数；nrhs 输入个数
{
  int mm,nn,m,n,i,ii,iii;
  double *img1,*img2,*img3,*Ip1,*Ip2,*Ip3,*best,*indexm,*indexn,*dd;
  mxLogical *toFill,*sourceRegion;

  /* Extract the inputs */
  mm = (int)mxGetScalar(prhs[0]);//把通过prhs[0]传递进来的mxArray类型的指针指向的数据（标量）赋给C程序里的变量
  nn = (int)mxGetScalar(prhs[1]);
  m  = (int)mxGetScalar(prhs[2]);
  n  = (int)mxGetScalar(prhs[3]);
  img1 = mxGetPr(prhs[4]);//从指向mxArray类型数据的prhs[0]获得了指向double类型的指针
  img2 = mxGetPr(prhs[5]);
  img3 = mxGetPr(prhs[6]);
  Ip1  = mxGetPr(prhs[7]);
  Ip2  = mxGetPr(prhs[8]);
  Ip3  = mxGetPr(prhs[9]);
  toFill = mxGetLogicals(prhs[10]);
  sourceRegion = mxGetLogicals(prhs[11]);
  
  
  /* Setup the output */
  plhs[0] = mxCreateDoubleMatrix(1000000,1,mxREAL);//实现内存的申请，m：待申请矩阵的行数(500000) ； n：待申请矩阵的列数(1)
  best = mxGetPr(plhs[0]);
  
  plhs[1] = mxCreateDoubleMatrix(1000000,1,mxREAL);
  indexm = mxGetPr(plhs[1]);
  
  plhs[2] = mxCreateDoubleMatrix(1000000,1,mxREAL);
  indexn = mxGetPr(plhs[2]);
  
plhs[3] = mxCreateDoubleMatrix(1,1,mxREAL);
  dd = mxGetPr(plhs[3]);
  /* Do the actual work */
  mypatchdst(mm,nn,m,n,img1,img2,img3,Ip1,Ip2,Ip3,toFill,sourceRegion,best,indexm,indexn,dd);
}
