// unit square
//
len = 0.1;    // Characteristic length controlling the mesh size

Point(1) = {0,0,0,len}; 
Point(2) = {1,0,0,len};
Point(3) = {1,1,0,len}; 
Point(4) = {0,1,0,len};
Line(1) = {1,2}; 
Line(2) = {2,3};
Line(3) = {3,4}; 
Line(4) = {4,1};

Line Loop(5) = {1,2,3,4};
Plane Surface(1) = {5};

// 生成标准三角元，最后的参数可以是Left, Right, 或者Alternate
//Transfinite Surface{1}={1,2,3,4} Alternate;

// 通过合并三角元生成标准矩形元
// Recombine Surface{1};

Physical Line(1) = {1,2,3,4};
Physical Surface(1) = {1};
