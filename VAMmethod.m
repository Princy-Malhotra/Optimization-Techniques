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

%% VAM CODE
icost = cost;
[m,n] = size(cost);
X=zeros(size(cost));

bfs = m+n-1;

for i=1:m*n
    col = sort(cost,1);     %arrange elements in a column in ascending order
    disp(col);
    row = sort(cost,2);
    pRow = row(:,2)-row(:,1);
    pCol = col(2,:)-col(1,:);
    r = max(pRow);
    c = max(pCol);
    r_max = find(pRow==max(r,c));
    c_max = find(pCol==max(r,c));
    cr = cost(r_max,:);
    cc = cost(:,c_max);
    if max(pRow)~=max(pCol)
        if max(pRow)>max(pCol)
            [rowind,colind] = find(min(min(cr))==cost(r_max,:));
            row1 = r_max(rowind);
            col1 = colind;
        else
            [rowind,colind]=find(min(min(cc))==cost(:,c_max));
            row1=rowind;
            col1 = c_max(colind);
        end
        x11 = min(A(row1), B(col1));
        [val,ind] = max(x11);
        ii = row1(ind);
        jj=col1(ind);
    else
        [rowind1,colind1] = find(min(min(cr))==cost(r_max,:));
        row1 = r_max(rowind1);
        col1=colind1;
        c1=cost(row1,col1);
    
        [rowind2, colind2] = find(min(min(cc))==cost(:,c_max));
        row2 = rowind2;
        col2 = c_max(colind2);
        c2 = cost(row2,col2);
    
        if c1<c2
            x11 = min(A(row1), B(col1));
            [val,ind] = max(x11);
            ii = row1(ind);
            jj = col1(ind);
        else
            x11 = min(A(row2), B(col2));
            [val,ind]=max(x11);
            ii = row2(ind);
            jj = col2(ind);
        end
    end
    y11 = min(A(ii), B(jj));
    X(ii,jj) = y11;
    A(ii) = A(ii)-y11;
    B(jj) = B(jj)-y11;
    cost(ii,jj) = inf;

end
disp(X);
initial_cost = sum(sum(icost.*X));
fprintf('Initial BFS cost = %d\n',initial_cost);
