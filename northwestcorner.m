format short
clear all
clc

%% INPUT DATA
cost = [14 56 48 27;82 35 21 81;99 31 71 63]; 
A = [13 19 76];     %Supply
B = [7 14 21 46];    %Demand


%% Check balanced/Unbalanced

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

%% NORTH-WEST CORNER METHOD

X = zeros(size(cost));
[m,n] = size(cost);
bfs = m+n-1;
i=1; j=1;
l=0;  %counter for m+n-1
while(l<bfs & i<=size(cost,1) & j<=size(cost,2))
    if A(i)<=B(j)
        X(i,j) = A(i);
        B(j) = B(j)-A(i);
        A(i) = 0;
        i=i+1;
        l=l+1;
    elseif B(j)<=A(i)
        X(i,j) = B(j);
        A(i) = A(i)-B(j);
        B(j)=0;
        j=j+1;
        l=l+1;
    else
        break;
    end
end

