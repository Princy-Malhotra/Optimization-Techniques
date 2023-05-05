format short
clear all
clc

%% INPUT DATA
%{
cost = [11 20 7 8;21 16 10 12;8 12 18 9]; 
A = [50 40 70];     %Supply
B = [30 25 35 40];    %Demand
%}

cost = [14 56 48 27; 82 35 21 14;99 31 71 63];
A = [13 19 76];
B = [7 14 21 46];
%% CHECKING FOR BALANCED/UNBALANCED PROBLEM
if sum(A)==sum(B)
    fprintf('Balanced Transportation Problem \n');
else
    fprintf('Unbalanced Transportation Problem \n');
    if sum(A)<sum(B)
        cost(end+1,:) = zeros(1,size(B,2));
        A(end+1) = sum(B)-sum(A);
    elseif sum(B)<sum(A)
        cost(:,end+1) = zeros(1,size(A,2));
        B(end+1) = sum(A)-sum(B);
    end
end

%% LEAST COST METHOD
icost = cost;

X = zeros(size(cost));
[m,n] = size(cost);
bfs = m+n-1;

for i=1:size(cost,1)
    for j=1:size(cost,2)
        hh = min(cost(:));
        [row_ind, col_ind] = find(hh==cost);
        x11 = min(A(row_ind),B(col_ind));
        [val,ind] = max(x11);
        ii = row_ind(ind);
        jj = col_ind(ind);
        
        y11 = min(A(ii),B(jj));
        X(ii,jj) = y11;
        A(ii) = A(ii)-y11;
        B(jj) = B(jj)-y11;
        cost(ii,jj) = Inf;      %to avoid this value being selected again
    end
end

%% PRINT INITIAL BFS
fprintf('Initial BFS = \n');
IB = array2table(X);
disp(IB);

%% CHECK FOR DEGENERATE/NON-DEGENERATE
bfs_calc = length(nonzeros(X));
if bfs_calc==bfs
    fprintf('Initial BFS is Non-Degenerate\n');
else
    fprintf('Initial BFS is Degenerate\n');
end

%% COMPUTE THE INITIAL COST
initial_cost = sum(sum(icost.*X));
fprintf('Initial BFS cost = %d\n',initial_cost);



