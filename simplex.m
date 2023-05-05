format short
clear all
clc

info=[];
b=[];
%% Input (a)
num_var = input('Enter the number of variables');

%% Input (b)
num_con = input('Enter the number of constraints');

%% Input (c)
less_than = input('Enter the number of less than or equal to constraints');
    
%% Input (c)
g_than = input('Enter the number of greater than or equal to constraints');

%% Input (c)
equal_to = input('Enter the number of equal to constraints');

%% Input (d)
if(less_than~=0)
    A_less = input('Enter the coefficients of less than constraints');
    info = [A_less];
    %% Input (d)
    b_less = input('Enter the RHS of the less than constraints');
    b = [b_less];
end



%% Input (e)
if(g_than~=0)
    A_great = input('Enter the coefficients of greater than constraints');
    info = [info;-1*A_great];
    %% Input (e)
    b_great = input('Enter the RHS of the greater than constraints');
    b = [b;-1*b_great];
end



%% Input (f)
if(equal_to~=0)
    A_equal = input('Enter the coefficients of equal to constraints');
    info = [info;A_equal;-1*A_equal];
    %% Input (f)
    b_equal = input('Enter the RHS of the equal to constraints');
    b = [b;b_equal;-1*b_equal];
end

%% Input (g)
obj = input('Write MIN if the problem is minimization and MAX if it is maximization','s');

%% Input (h)
coeff_of_objf = input('Enter the coefficient (row) matrix for the objective function');
if obj=='MIN'
    coeff_of_objf = -1*coeff_of_objf;
end

%% convert all constraints into <= sign and objective function to maximization type

%total num of variables + no of slack variables for less than constraints +
%no of slack variables for greater than constraints + 2*no of equal to
%constraints since each equal to constraint is broken into two constraints,
%one <= and one >= and 1 for solution 
s_var = num_var+less_than+g_than+ (2*equal_to) + 1;

temp = zeros(1,less_than+g_than+(2*equal_to)+1);
cost = [coeff_of_objf temp];


%input
%obj = 'MIN'
%for i=1:s_var
 %   var = {var,}
%var = {'x_1','x_2','x_3','s_1','s_2','s_3','s_4','sol'};
%M = 1000;
%cost = [3 -1 2 0 0 0 0 0];
%A = [3 1 0 0 1 0 3; 4 3 -1 0 0 1 6; 1 2 0 1 0 0 3];
%info = [1 3 1;-2 1 -1;4 3 -2;-4 -3 2];
%b = [5;-2;5;-5];
RUN=true;
fprintf('Slack Variables = ');
for i=num_var+1:s_var-1
    fprintf('X%d ',i);
end
fprintf('\n');

s = eye(size(info,1));
A = [info s b];




%%INPUT parameters
%num_var = 6;

obj='MAX'
C = [40 30 0 0 0];
info = [1 1;2 1];
b = [12; 16];




[m n] = size(info);
RUN=true


s = eye(m);
A = [info s b];
cost = C;

%% Find the starting Basic variable in A
bv = [];
for j=1:size(s,2)
    for i = 1: size(A,2)
        if A(:,i)==s(:,j)
            bv = [bv i];
        end
    end
end

fprintf('Basic Variables (BV) = ')
disp(bv);

%bv = num_var+1:size(A,2)-1;  %columns of bv
zjcj = cost(bv)*A - cost;

%print table
zcj = [zjcj;A];
simptable = array2table(zcj);
simptable.Properties.VariableNames(1:size(zcj,2)) = {'x_1','x_2','s_1','s_2','sol'}
while(RUN)
    if any(zjcj<0)
        fprintf('The current BFS is not optimal \n')
        fprintf('\n =============== The next iteration results =============\n')
        
    else
        RUN=false
        disp('Optimal Solution reached');
        fprintf('Optimal Value of the objective function = ');
        if obj=='MIN'
            disp(-1*zcj(1,size(zcj,2)));
        else
            disp(zcj(1,size(zcj,2)));
        end
        break;
        
    end
    
    %Entering variable
    [pivotele, pivotcol] = min(zjcj(1:size(zjcj,2)-1))
    fprintf('Min Zj-Cj is %d \n', pivotele);
    fprintf('Entering variable is %d \n',pivotcol);
    
    %leaving variable
    sol = A(:,end)
    p_col = A(:,pivotcol)
    if all(p_col<=0)
        error('LPP is unbounded. All enteries are <=0 in the pivot column %d',p_col);
    else
    for i = 1:size(p_col,1)
        if p_col(i)>0
            ratio(i) = sol(i)./p_col(i)
        else
            ratio(i) = inf
        end 
    end
    [minratio, minidx] = min(ratio)
    fprintf('Min ratio is %d \n', minratio);
    fprintf('Leaving variable is %d \n',bv(minidx));
    end
    
    bv(minidx) = pivotcol;
    disp('New Basic variables are = ');
    disp(bv);
    pvt_ele = A(minidx,pivotcol);
    
    A(minidx,:) = A(minidx,:)./pvt_ele;
    for i = 1:size(A,1)
        pivot_ele = A(i,pivotcol);
        for j = 1:size(A,2)
            if i~=minidx
                A(i,j) = A(i,j)-(pivot_ele*A(minidx,j));
            end
        end
    end
    zjcj = zjcj - zjcj(pivotcol).*A(minidx,:);
    %print table
    zcj = [zjcj;A];
    simptable = array2table(zcj);
    simptable.Properties.VariableNames(1:size(zcj,2)) = {'x_1','x_2','s_1','s_2','sol'}
    %disp(ratio)

end


