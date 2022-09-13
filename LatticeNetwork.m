function [G,centerNode] = LatticeNetwork(dimension,design)

% generates a graph G that encodes a square network connectivity 4 or 8

num_nodes = dimension^2;

A = zeros(num_nodes);

if mod(dimension,2) == 0 % even
    centerNode = round((num_nodes + dimension)/2);
elseif mod(dimension,2) == 1 % odd
    centerNode = round(num_nodes/2);
end

switch design
    
    case 4
        
        for n = 1:num_nodes
            
            [r,c] = ind2sub(dimension*ones(1,2),n);
            neigh = nan*ones(1,4);
            
            if r-1 >= 1
                neigh(1) = sub2ind(dimension*ones(1,2),r-1,c);
            end
            
            if c+1 <= sqrt(num_nodes)
                neigh(2) = sub2ind(dimension*ones(1,2),r,c+1);
            end
            
            if r+1 <= sqrt(num_nodes)
                neigh(3) = sub2ind(dimension*ones(1,2),r+1,c);
            end
            
            if c-1 >= 1
                neigh(4) = sub2ind(dimension*ones(1,2),r,c-1);
            end
            
            neigh(isnan(neigh))= [];
            A(n,neigh) = 1;
            
        end
        
    case 8
        
        for n = 1:num_nodes
            
            [r,c] = ind2sub(dimension*ones(1,2),n);
            neigh = nan*ones(1,8);
            
            if r-1 >= 1
                neigh(1) = sub2ind(dimension*ones(1,2),r-1,c);
            end
            
            if and(r-1 >= 1,c+1 <= sqrt(num_nodes))
                neigh(2) = sub2ind(dimension*ones(1,2),r-1,c+1);
            end
            
            if c+1 <= sqrt(num_nodes)
                neigh(3) = sub2ind(dimension*ones(1,2),r,c+1);
            end
            
            if and(r+1 <= sqrt(num_nodes),c+1 <= sqrt(num_nodes))
                neigh(4) = sub2ind(dimension*ones(1,2),r+1,c+1);
            end
            
            if r+1 <= sqrt(num_nodes)
                neigh(5) = sub2ind(dimension*ones(1,2),r+1,c);
            end
            
            if and(r+1 <= sqrt(num_nodes),c-1 >= 1)
                neigh(6) = sub2ind(dimension*ones(1,2),r+1,c-1);
            end
            
            if c-1 >= 1
                neigh(7) = sub2ind(dimension*ones(1,2),r,c-1);
            end
            
            if and(r-1 >= 1,c-1 >= 1)
                neigh(8) = sub2ind(dimension*ones(1,2),r-1,c-1);
            end
            
            neigh(isnan(neigh))= [];
            A(n,neigh) = 1;
            
        end
        
end

G = graph(A);

%% END

