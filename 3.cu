#include<stdio.h>
#include<cuda.h>
#define row1 2 // Number of rows of first matrix
#define col1 3 // Number of columns of first matrix
#define row2 3 // Number of rows of second matrix
#define col2 2 // Number of columns of second matrix

__global__ void matproduct(int *a,int *b, int *c)
{
    int row = blockIdx.y*row1+threadIdx.y;
    int col = blockIdx.x*col2+threadIdx.x;
    //printf("%d,%d\n",row,col);
    if(row < row1 && col < col2)
    {
        int val = 0;
        for(int k=0;k<row2;k++)
        {
           val += a[row*col1+k]*b[k*col2+col];
        }
        c[row*col2+col] = val;
    }
}

int main()
{
    int a[row1][col1];
    int b[row2][col2];
    int c[row1][col2];
    int *d_a,*d_b,*d_c;

    printf("elements of the first matrix: \n");
    for(int i=0;i<row1;i++)
    {
        for(int j=0;j<col1;j++)
        {
            a[i][j] = rand()%10;
            printf("%d ",a[i][j]);
        }
        printf("\n");
    }
    printf("elements of the second matrix: \n");
    for(int i=0;i<row2;i++)
    {
        for(int j=0;j<col2;j++)
        {
            b[i][j] = rand()%10;
            printf("%d ",b[i][j]);
        }
        printf("\n");
    }

    cudaMalloc((void **)&d_a,row1*col1*sizeof(int));
    cudaMalloc((void **)&d_b,row2*col2*sizeof(int));
    cudaMalloc((void **)&d_c,row1*col2*sizeof(int));

    cudaMemcpy(d_a,a,row1*col1*sizeof(int),cudaMemcpyHostToDevice);
    cudaMemcpy(d_b,b,row2*col2*sizeof(int),cudaMemcpyHostToDevice);


    dim3 grid((col2+31)/32,(row1+31)/32,1);
    dim3 block(32,32,1);

    matproduct<<<grid,block>>>(d_a,d_b,d_c);
    cudaDeviceSynchronize();
    cudaMemcpy(c,d_c,row1*col2*sizeof(int),cudaMemcpyDeviceToHost);
    printf("Product of two matrices:\n");
    for(int i=0;i<row1;i++)
    {
        for(int j=0;j<col2;j++)
        {
              printf("%d ",c[i][j]);
        }
        printf("\n");
    }
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);

    return 0;
}