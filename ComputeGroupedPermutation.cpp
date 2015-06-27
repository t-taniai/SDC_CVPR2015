
#include"mex.h"          /* Matlabのデータ構造の読み込み */

#include <vector>
#include <algorithm>

using namespace std;

int rows;
int cols;
int N;
int binN;
double *binImg;
double *distImg;
double *entireHist;
double *currentHist;
double *permImg;
double *groupsize;

double t;
double th_a;
double th_kappa;


void computeGroupledPermutation()
{
  vector<vector<pair<double, int>>> data(binN);
  vector<pair<double, int> >::iterator it; 
  
  for ( int i = 0; i < binN; i++ ){
      if ( entireHist[i] > 0 ){
          data[i].reserve( (int)entireHist[i] );
      }
  }

  for ( int i = 0; i < N; i++ ){
      int bin = (int)binImg[i] - 1;
      data[bin].push_back( pair<double, int>(distImg[i], i) );
  }

  // Compute the threshold using mean and stddev of all pairwise differences
  double mean = 0, mean2 = 0;
  int count = 0;
  for ( int i = 0; i < binN; i++ ){
      if ( entireHist[i] > 0 ){
        sort(data[i].begin(), data[i].end());
        
        for ( int j = 0; j < data[i].size()-1; j++ ){
            double diff = fabs(data[i][j+1].first - data[i][j].first);
            mean += diff;
            mean2 += diff*diff;
            count++;
        }
      }
  }
  mean2 /= count;
  mean /= count;
  double sig = sqrt(mean2 - mean*mean);
  double threshold = (mean + th_a*sig) / pow(t, th_kappa);
  
  
  // Grouping using the threshold
    for ( int i = 0; i < binN; i++ ){
        if ( data[i].size() == 0 ) continue;

        int c;
        for ( int j = 0; j < data[i].size(); j += c ){
            c = 1;
            while ( c+j < data[i].size() && fabs(data[i][j+c].first-data[i][j+c-1].first) <= threshold && data[i][j+c].first*data[i][j+c-1].first >= 0) {
                c++;
            }
            for ( int k = 0; k < c; k++ ) {
                permImg[data[i][j+k].second] = data[i].size() - j;
                groupsize[data[i][j+k].second] = c;
            }
        }
    }
}


void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[] )
{
  /* INPUT:
   * 0: binImg (int 2D)
   * 1: distImg (double 2D) ... distance image
   * 2: entireHist (double 1D)
   * 3: currentHist (doule 1D)
   */
  
  rows = mxGetM(prhs[0]);
  cols = mxGetN(prhs[0]);
  N = rows * cols;
  binN = mxGetM(prhs[2]);
  
  binImg = (double*)mxGetData(prhs[0]);
  distImg = (double*)mxGetData(prhs[1]);
  entireHist = (double*)mxGetData(prhs[2]);
  currentHist = (double*)mxGetData(prhs[3]);
  t = (double)mxGetScalar(prhs[4]);
  th_a = (double)mxGetScalar(prhs[5]);
  th_kappa = (double)mxGetScalar(prhs[6]);
  
  /* OUTPUT:
   * 0: permImg (int 2D)
   * 1: groupsize (int 2D) 
   */
  plhs[0] = mxCreateDoubleMatrix(rows, cols, mxREAL);
  permImg = (double*)mxGetData(plhs[0]);
  plhs[1] = mxCreateDoubleMatrix(rows, cols, mxREAL);
  groupsize = (double*)mxGetData(plhs[1]);
  
  computeGroupledPermutation();
}