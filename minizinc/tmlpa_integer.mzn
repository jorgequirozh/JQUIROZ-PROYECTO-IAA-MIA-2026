% tmlpa_integer.mzn
int: n_clients;
int: n_hubs;
int: d_max;
int: P;
int: P_min;

array[1..n_clients] of int: q;         % Demands
array[1..n_clients] of float: w;       % Weights (We will scale this to integers)
array[1..n_hubs] of float: f;          % Fixed costs
array[1..n_hubs] of float: o;          % Operational costs
array[1..n_hubs] of int: L;            % Capacities
array[1..n_clients, 1..n_hubs] of int: d; % Distance matrix

% SCALE FACTOR: Multiplying float coefficients by 100 turns them into clean integers 
% preserving 2 decimal points of academic precision without floating-point tracking lag.
int: scale = 100;

array[1..n_hubs] of int: f_scaled = [ round(f[j] * int2float(scale)) | j in 1..n_hubs ];
array[1..n_hubs] of int: o_scaled = [ round(o[j] * int2float(scale)) | j in 1..n_hubs ];
array[1..n_clients] of int: w_scaled = [ round(w[i] * int2float(scale)) | i in 1..n_clients ];

% Decision Variables
array[1..n_hubs] of var 0..1: y;                        
array[1..n_clients, 1..n_hubs] of var 0..1: x;          

% Constraints
constraint forall(i in 1..n_clients, j in 1..n_hubs) (
    x[i,j] <= y[j]
);

constraint forall(i in 1..n_clients) (
    sum(j in 1..n_hubs)(x[i,j]) == 1
);

constraint forall(j in 1..n_hubs) (
    sum(i in 1..n_clients)(q[i] * x[i,j]) <= L[j] * y[j]
);

constraint forall(i in 1..n_clients, j in 1..n_hubs) (
    d[i,j] * x[i,j] <= d_max
);

constraint sum(j in 1..n_hubs)(y[j]) >= P_min;
constraint sum(j in 1..n_hubs)(y[j]) <= P;

% Objective Function using optimized Integer math
var int: total_cost_scaled = 
    sum(j in 1..n_hubs)(f_scaled[j] * y[j]) + 
    sum(i in 1..n_clients, j in 1..n_hubs)(o_scaled[j] * q[i] * x[i,j]) + 
    sum(i in 1..n_clients, j in 1..n_hubs)(w_scaled[i] * d[i,j] * x[i,j]);

solve minimize total_cost_scaled;

% Convert back to standard display values in the output window
var float: total_cost = int2float(total_cost_scaled) / int2float(scale);

output ["Optimal Cost: ", show(total_cost), "\ny = ", show(y)];