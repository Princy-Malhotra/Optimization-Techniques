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
fprintf('---------Iteration 1----------\n');
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

%% COMPUTE Zj-Cj
zjcj = cost(bv)*A - cost;

X = [zjcj;A];

%% PRINT THE RESULTING TABLE
fprintf('THE LAST COLUMN OF THE TABLE SHOWS THE SOLUTION COLUMN\n')
simptable = array2table(X);
disp(simptable);
%simptable.Properties.VariableNames(1:size(A,2)) = var


num_iters=2;
%% DUAL SIMPLEX START

while RUN
    sol = A(:,end);
    if any(sol<0)
        fprintf('The current BFS is NOT FEASIBLE\n');
    
        % Find leaving var
        [minval p_row] = min(sol);
        fprintf('Leaving variable = %d \n',p_row);
    
        % Find the entering variable
        pvt_row = A(p_row,1:end-1);
        zj = zjcj(:,1:end-1);
        
        for i=1:size(pvt_row,2)
            if pvt_row(i)<0
                ratio(i) = abs(zj(i)./pvt_row(i));
            else
                ratio(i) = inf;
            end
        end
        [mincol, p_col] = min(ratio);
        if(mincol==inf)
            fprintf('INFEASIBLE SOLUTION\n');
            RUN = false;
        end
        fprintf('Entering variable = %d \n',p_col);
        
        fprintf("\n---------Iteration %d----------\n",num_iters);
        num_iters=num_iters+1;
        % Update the Basic Variables
        bv(p_row) = p_col;
        fprintf('New Basic variables = ')
        disp(bv); 
        
        % Update the table
        pvt_key = A(p_row, p_col);
        A(p_row,:) = A(p_row,:)./pvt_key;
        for i=1:size(A,1)
            if i~=p_row
                A(i,:) = A(i,:) - A(i,p_col).*A(p_row,:);
            end
        end
        zjcj = zjcj - zjcj(p_col).*A(p_row,:);
        X = [zjcj;A];
        simptable = array2table(X);
        disp(simptable);
        %simptable.Properties.VariableNames(1:size(A,2)) = var
    else
        RUN=false;
        fprintf('The Current BFS is feasible and optimal \n');
        fprintf('Optimal Value of the objective function = ');
        if obj=='MIN'
            disp(-1*X(1,size(X,2)));
        else
            disp(X(1,size(X,2)));
        end
        fprintf('\n Basic Variables for optimal solution = ');
        disp(bv);
        fprintf('\n Value of basic variables = \n');
        X_new = X;
        X_new([1],:)=[];
        disp(X_new(:,size(X_new,2)))
    end
end

%% END OF CODE

