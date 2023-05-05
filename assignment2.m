%C = [12 30 21 15; 18 33 9 31; 44 25 24 21; 23 30 28 14];
%n=4;

n=5;
C=[8 4 2 6 1; 0 9 5 5 4; 3 8 9 2 6; 4 3 1 0 3; 9 5 8 9 5];

ori_C = C;


    
%Subtracting by row minimum
for i=1:n
    x = min(C(i,:));
    C(i, :) = C(i, :)-x;
    
end

%Subtracting by col minimum
for i=1:n
    x=min(C(:,i));
    C(:,i)=C(:,i)-x;

end

%Finding max_no of independ zeros
%enrectangle=-1
%cross=-2
C
r=0;
while r~=n
    %finding row with exactly one zero
    C_2 = C;
    for i=1:n
        countz=0;
        for j=1:n
            if C(i, j)==0
                countz=countz+1;
            end
        end
        if countz==1
            for j=1:n
                if C(i, j)==0 
                    C(i,j)=-1; %enrectangles
                    r=r+1;
                    %crossing other zeros in that column
                    for k=1:n
                        if C(k, j)==0
                            C(k, j)=-2;                    
                        end
                    end
                    C
                    break;
                end
            end
    
            
            
            
        end
    end
    
    
    %finding column with exactly one zero
    for j=1:n
        countz=0;
        for i=1:n
            if C(i, j)==0
                countz=countz+1;
            end
        end
        if countz==1
            for i=1:n
                if C(i, j)==0
                    C(i,j)=-1; %enrectangles
                    r=r+1;
                    %crossing other zeros in that column
                    for k=1:n
                        if C(i, k)==0
                            C(i, k)=-2;
                        end
                    end
                    C
                    break;
                end
            end
    
            
            
            
        end
    end
    
    
    %if still zeros remaining
    %finding column with exactly one zero
    for j=1:n
        for i=1:n
            if C(i, j)==0
                C(i,j)=-1; %enrectangles
                r=r+1;
                %crossing other zeros in that column
                for k=1:n
                    if C(i, k)==0
                        C(i, k)=-2;
                    end
                end
                %crossing other zeros in its row
                for k=1:n
                    if C(k, j)==0
                        C(k, j)=-2;
                    end
                end
            end
    
            
            
            
        end
    end
    
    
    if r==n
        fprintf('Optimal assg');
        break;
    else
        %some places assignment not made
        rows_mark=[];
        cols_mark=[];
    
        for i=1:n
            assg=0;
            for j=1:n
                if C(i, j)==-1
                   assg=1;
                end
            end
    
            if assg==0
                rows_mark=[rows_mark 1];
            else
                rows_mark=[rows_mark 0];
            end
    
    
        end
        
            
        for j=1:n
            cross=0;
            for i=1:n
                if rows_mark(i)==1 
                    if C(i, j)==-2
                        cross=1;
                    end
                end
            end

            if cross==0
                cols_mark = [cols_mark 0];
            else
                cols_mark = [cols_mark 1];
            end
        end
            
        
        for i=1:n
            assg=0;
            for j=1:n
                if cols_mark(j)==1
                    if C(i, j)==-1
                        assg=1;
                    end
                end
            end

            if assg==1
                rows_mark(i)=1;
            end
        end
        

        %lines
        %C_2 has actual values, C has -1, -2
        minval=Inf;
        for i=1:n
            for j=1:n
                if rows_mark(i)==1 && cols_mark(j)==0
                    if C_2(i, j)<minval
                        minval=C_2(i, j);
                    end
                end
                

            end
        end

        for i=1:n
            for j=1:n
                if rows_mark(i)==1 && cols_mark(j)==0
                    C_2(i, j)=C_2(i, j)-minval;
                end
                if rows_mark(i)==0 && cols_mark(j)==1
                    C_2(i, j)=C_2(i, j)+minval;
                end
            end
        end


        C=C_2;
        
    
    end
end



z=0;
for i=1:n
    for j=1:n
        if C(i, j)==-1
            z = z + ori_C(i, j);
            
        end
    end
end

z

C
ori_C