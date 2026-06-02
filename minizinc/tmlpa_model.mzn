% tmlpa_model.mzn
int: n_clients;
int: n_hubs;
int: d_max;
int: P;
int: P_min;

array[1..n_clients] of int: q;         % Demands
array[1..n_clients] of float: w;       % Weights
array[1..n_hubs] of float: f;          % Fixed costs
array[1..n_hubs] of float: o;          % Operational costs
array[1..n_hubs] of int: L;            % Capacities
array[1..n_clients, 1..n_hubs] of int: d; % Distance matrix

% Decision Variables
array[1..n_hubs] of var 0..1: y;                        % Hub activation
array[1..n_clients, 1..n_hubs] of var 0..1: x;          % Client-to-Hub assignment

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

% Objective Function
var float: total_cost = 
    sum(j in 1..n_hubs)(f[j] * y[j]) + 
    sum(i in 1..n_clients, j in 1..n_hubs)(o[j] * q[i] * x[i,j]) + 
    sum(i in 1..n_clients, j in 1..n_hubs)(w[i] * int2float(d[i,j]) * x[i,j]);

solve minimize total_cost;

output ["Optimal Cost: ", show(total_cost), "\ny = ", show(y)];