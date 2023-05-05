%GOMORY'S
%MAX Z=x1+2x2
%2x2<=7
%x1+x2<=7
%2x1<=11



%First doing Simplex LPP
C=[1 2 0 0 0];
A = [0 2 1 0 0;1 1 0 1 0; 2 0 0 0 1];
b=[7; 7; 11];

m=size(A, 1); %no of constraints
n=size(A, 2); %no of variables
k=m; %no of basic variables

bas_v = [3 4 5];
Y = A;
xb = b;
cb = [C(bas_v(1));C(bas_v(2));C(bas_v(3))];

done = false;
ii = 0;
while done==false

    Y 
    
    ii = ii+1;
    %calculating zj
    zj=[];
    for i=1:n
        zjj=0;
        for j=1:k
            zjj = zjj + cb(j,1)*Y(j, i);
        end

        zj = [zj, zjj];

    end
    done=true;
    

    %FINDING PIVOT
    minzjcj = Inf;
    pivotcolumn=0;
    for i=1:n

      
        
        if zj(i)-C(i)<0
            done=false;
        end
        
        if zj(i)-C(i)<minzjcj
            pivotcolumn=i;
            minzjcj=zj(i)-C(i);
        end


    end
    
    


    if done==true
        break
    end

    pivotrow=1;
    minratio=Inf;

    for i=1:m
        if Y(i, pivotcolumn)==0
            continue
        end
        ratio = xb(i,1)/Y(i, pivotcolumn);
        if ratio>0
            if ratio<minratio
                minratio=ratio;
                pivotrow = i;
            end
        end


    end

    


    if minratio==Inf
        fprintf("Unbounded solution");
    end
    
   
    
    
    if done==true
        break
    end


    bas_v(pivotrow) = pivotcolumn;
    cb = [C(bas_v(1));C(bas_v(2));C(bas_v(3))];

    

    %FINDING NEW TABLE
    pivotelement = Y(pivotrow, pivotcolumn);
    %pivotrow
    xb(pivotrow,1)=xb(pivotrow,1)/pivotelement;
    for i=1:n
        Y(pivotrow, i)=Y(pivotrow, i)/pivotelement;
    end

    %other rows
    for j=1:m
        if j==pivotrow
                continue
        end
        pivotel = Y(j, pivotcolumn);
        for i=1:n
            
            
            Y(j, i) = Y(j, i) - pivotel*Y(pivotrow, i);

        end

        xb(j, 1) = xb(j, 1) - pivotel*xb(pivotrow, 1);
    end

    
   
    
    

end


%out z and xb
xb
bas_v
z=C(1, bas_v(1))*xb(1, 1) + C(1, bas_v(2))*xb(2, 1) + C(1, bas_v(3))*xb(3, 1);
z


is_int=false;
iter=0
while is_int==false
    iter
    %checking if int
    is_int=true;
    for i=1:length(xb)
        if xb(i, 1)<0 || floor(xb(i, 1))~=xb(i, 1)
            is_int=false;
            break;
        end
    end


    if is_int==true
        break
    end

    %finding k(xi with max fraction part)
    maxfrac = 0;
    k=1;
    for i=1:length(xb)
        frac = mod(xb(i,1),1);
        if frac>maxfrac
            maxfrac=frac;
            k=i;
        end
    end


    %adding row at bottom of simplex table
    xb = [xb;-maxfrac];
    bas_v=[bas_v n+1];
    newc = [];
    for j=1:n
        
        
        newc = [newc -mod(Y(k, j), 1)];
    end

    Y = [Y; newc];
    %need to concatenate column
    newc = [];
    for i=1:m+1
        newc=[newc;0];
    end
    Y=[Y newc];
    n=n+1;
    m=m+1;
    Y(m, n)=1;
    C = [C 0];
    cb=[];
    for i=1:length(bas_v)
        cb=[cb;C(bas_v(i))];
    end
    
    
    %Dual simplex
    done = false;
    ii = 0;
    while done==false
        ii = ii+1;
        %calculating zj-cj
        zj=[];
        for i=1:n
            zjj=0;
            for j=1:k
                zjj = zjj + cb(j,1)*Y(j, i);
            end
    
            zjj = zjj-C(i);
    
            zj = [zj, zjj];
    
        end
        done=true;
        
    
        %FINDING PIVOT
        minxb = Inf;
        pivotrow=1;
        
        for i=1:m
            if xb(i, 1)<0
    
                done=false;
            end
    
            if xb(i, 1)<minxb
                pivotrow = i;
                minxb = xb(i, 1);
            end
        end
        
    
    
        if done==true
            break
        end
    
        pivotcolumn=1;
        minratio=Inf;
    
        for i=1:m
            if Y(pivotrow, i)>=0
                continue
            end
            ratio = zj(i)/Y(pivotrow, i);
            
            if ratio<minratio
                    minratio=ratio;
                    pivotcolumn = i;
            end
           
    
    
        end
    
        
    
    
        if minratio==Inf
            fprintf("Unbounded solution");
        end
        
       
        
        
        if done==true
            break
        end
    
        
        bas_v(pivotrow) = pivotcolumn;
        cb=[];
        for i=1:length(bas_v)
            cb=[cb;C(bas_v(i))];
        end
    
        
    
        %FINDING NEW TABLE
        pivotelement = Y(pivotrow, pivotcolumn);
        %pivotrow
        xb(pivotrow,1)=xb(pivotrow,1)/pivotelement;
        for i=1:n
            Y(pivotrow, i)=Y(pivotrow, i)/pivotelement;
        end
    
        %other rows
        for j=1:m
            if j==pivotrow
                    continue
            end
            pivotel = Y(j, pivotcolumn);
            for i=1:n
                
                
                Y(j, i) = Y(j, i) - pivotel*Y(pivotrow, i);
    
            end
    
            xb(j, 1) = xb(j, 1) - pivotel*xb(pivotrow, 1);
        end
    
        
       
        
        
    
    end
    
    
    %out z and xb
    
    
    
end


xb
bas_v
z=C(1, bas_v(1))*xb(1, 1) + C(1, bas_v(2))*xb(2, 1) + C(1, bas_v(3))*xb(3, 1) + C(1, bas_v(4))*xb(4, 1);
z