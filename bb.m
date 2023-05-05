f=[-1; -2];
A = [0 2;1 1; 2 0];
b=[7; 7; 11];
Aeq=[];
beq=[];
m=size(A, 1); %no of constraints
n=size(A, 2); %no of variables

lb = [0;0];
ub = [];

[xact, zact] = solv(f, A, b, Aeq, beq, lb, ub);

xact
zact

function [x, z] = solv(f, A, b, Aeq, beq, lb, ub)
    [x, z, exitflag, output, lamda]=linprog(f, A, b, Aeq, beq, lb, ub);
    is_int=true;
    x_d=0;
    x_d_pos=0;
    for i=1:length(x)
        if x(i, 1)~=floor(x(i, 1))
            is_int=false;
            x_d=x(i, 1);
            x_d_pos=i;
        end
    end
    
    if is_int==true
        
        
    else
        
        Al = [A; zeros([1, size(A, 2)])];
        Al(size(Al, 1), x_d_pos) = 1;
        bl = [b; floor(x_d)];
        [xl, zl, exitflag, output, lamda]=linprog(f, Al, bl, Aeq, beq, lb, ub);
        
        Ar = [A; zeros([1, size(A, 2)])];
        Ar(size(Ar, 1), x_d_pos) = -1;
        br = [b; -ceil(x_d)];
        [xr, zr, exitflag, output, lamda]=linprog(f, Ar, br, Aeq, beq, lb, ub);

        %left branch  
        if isempty(xl)
            is_int_l=false;
        else
            is_int_l=true;
        end
        
        for i=1:length(xl)
            if xl(i, 1)~=floor(xl(i, 1))
                is_int_l=false;
                
            end
        end
        
        if isempty(xr)
            is_int_r=false;
        else
            is_int_r=true;
        end
        
        %right
        for i=1:length(xr)
            if xr(i, 1)~=floor(xr(i, 1))
                is_int_r=false;
                
            end
        end
        

        %both int
        if is_int_r==true && is_int_l==true
            if zl>zr
                z=zl;
                x=xl;
            else
                z=zr;
                x=xr;
            end

        else
            %left non int
            if is_int_r==true
                if zl<zr
                    z=zr;
                    x=xr;
                else
                    [xl, zl]=solv(f, Al, bl, Aeq, beq, lb, ub);
                    if isempty(xl)
                        is_int_l=false;
                    else
                        is_int_l=true;
                    end
        
                    for i=1:length(xl)
                        if xl(i, 1)~=floor(xl(i, 1))
                            is_int_l=false;
                            
                        end
                    end
                    
                    %infeasible
                    if is_int_l==false
                        z=zr;
                        x=xr;
                    %both int
                    else
                        if zl>zr
                            z=zl;
                            x=xl;
                        else
                            z=zr;
                            x=xr;
                        end
                    end

                end
            %right non int    
            else
                if zl>zr
                    z=zl;
                    x=xl;
                else
                    [xr, zr]=solv(f, Ar, br, Aeq, beq, lb, ub);
                    if isempty(xr)
                        is_int_r=false;
                    else
                        is_int_r=true;
                    end
                   
        
                    for i=1:length(xr)
                        if xr(i, 1)~=floor(xr(i, 1))
                            is_int_r=false;
                            
                        end
                    end
                    
                    %infeasible
                    if is_int_r==false
                        z=zl;
                        x=xl;
                    %both int
                    else
                        if zl>zr
                            z=zl;
                            x=xl;
                        else
                            z=zr;
                            x=xr;
                        end
                    end

                end
            end

        end
        
        
    end

end