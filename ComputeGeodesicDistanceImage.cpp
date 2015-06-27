
#include"mex.h"          /* Matlabのデータ構造の読み込み */

#include <algorithm>

using namespace std;




void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] )
{
  /*
   * 0: Img (double 2D)
   * 1: Si (logical 2D)
   * 2: gamma (double)
   * 3: T (doule)
   */
  
  int rows = mxGetM(prhs[1]);
  int cols = mxGetN(prhs[1]);
  int N = rows * cols;
  
  double *Img  = (double*)mxGetData(prhs[0]);
  double *mask = (double*)mxGetData(prhs[1]);
  double gamma = mxGetScalar(prhs[2]);
  int T = (int)mxGetScalar(prhs[3]);
  
  plhs[0] = mxCreateDoubleMatrix(rows, cols, mxREAL);
  double *geodist = (double*)mxGetData(plhs[0]);
  
  // initialize
  for ( int i = 0; i < N; i++ ){
      if ( mask[i] > 0 )
          geodist[i] = 0;
      else
          geodist[i] = 10000000;
  }
  
  double *imgR = &Img[N*0];
  double *imgG = &Img[N*1];
  double *imgB = &Img[N*2];
  
  for ( int t = 0; t < T; t++ ){
      for ( int j = 0, n = 0; j < cols; j++ ){
          for ( int i = 0; i < rows; i++,n++ ){
              double current = geodist[n];

              if ( i && j ) {
                  int m = (i-1) + (j-1)*rows;
                  double dr = imgR[m]-imgR[n];
                  double dg = imgG[m]-imgG[n];
                  double db = imgB[m]-imgB[n];
                  
                  double proposal = sqrt(2.0 + gamma*(dr*dr+dg*dg+db*db)) + geodist[m];
                  current = min(current, proposal);
              }
              if ( j ) {
                  int m = i + (j-1)*rows;
                  double dr = imgR[m]-imgR[n];
                  double dg = imgG[m]-imgG[n];
                  double db = imgB[m]-imgB[n];
                  
                  double proposal = sqrt(1.0 + gamma*(dr*dr+dg*dg+db*db)) + geodist[m];
                  current = min(current, proposal);
              }
              if ( i < rows-1 && j ) {
                  int m = (i+1) + (j-1)*rows;
                  double dr = imgR[m]-imgR[n];
                  double dg = imgG[m]-imgG[n];
                  double db = imgB[m]-imgB[n];
                  
                  double proposal = sqrt(2.0 + gamma*(dr*dr+dg*dg+db*db)) + geodist[m];
                  current = min(current, proposal);
              }
              if ( i ) {
                  int m = (i-1) + j*rows;
                  double dr = imgR[m]-imgR[n];
                  double dg = imgG[m]-imgG[n];
                  double db = imgB[m]-imgB[n];
                  
                  double proposal = sqrt(1.0 + gamma*(dr*dr+dg*dg+db*db)) + geodist[m];
                  current = min(current, proposal);
              }
              geodist[n] = current;
          }
      }

      
      for ( int j = cols-1, n = N-1; j >= 0; j-- ){
          for ( int i = rows-1; i >= 0; i--, n-- ){
              double current = geodist[n];

              if ( i  && j < cols-1 ) {
                  int m = (i-1) + (j+1)*rows;
                  double dr = imgR[m]-imgR[n];
                  double dg = imgG[m]-imgG[n];
                  double db = imgB[m]-imgB[n];
                  
                  double proposal = sqrt(2.0 + gamma*(dr*dr+dg*dg+db*db)) + geodist[m];
                  current = min(current, proposal);
              }
              if ( j < cols-1 ) {
                  int m = i + (j+1)*rows;
                  double dr = imgR[m]-imgR[n];
                  double dg = imgG[m]-imgG[n];
                  double db = imgB[m]-imgB[n];
                  
                  double proposal = sqrt(1.0 + gamma*(dr*dr+dg*dg+db*db)) + geodist[m];
                  current = min(current, proposal);
              }
              if ( i < rows-1 && j < cols-1 ) {
                  int m = (i+1) + (j+1)*rows;
                  double dr = imgR[m]-imgR[n];
                  double dg = imgG[m]-imgG[n];
                  double db = imgB[m]-imgB[n];
                  
                  double proposal = sqrt(2.0 + gamma*(dr*dr+dg*dg+db*db)) + geodist[m];
                  current = min(current, proposal);
              }
              if ( i < rows-1 ) {
                  int m = (i+1) + j*rows;
                  double dr = imgR[m]-imgR[n];
                  double dg = imgG[m]-imgG[n];
                  double db = imgB[m]-imgB[n];
                  
                  double proposal = sqrt(1.0 + gamma*(dr*dr+dg*dg+db*db)) + geodist[m];
                  current = min(current, proposal);
              }
              geodist[n] = current;
          }
      }
  }
}