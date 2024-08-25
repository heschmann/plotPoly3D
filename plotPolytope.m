function plotPolytope(A,b,color,alpha,linewidth,tol)

if nargin<6
    tol = 1e-10;
end
if nargin<5
    linewidth = 1.5;
end
if nargin<4
    alpha = 0.7;
end
if nargin<3
    color = 'blue';
end

% reduce
V = con2vert(A,b);
[A,b] = noredund(A,b);
V = V.';

if ~strcmp(color,'rand')
    [k2,~] = convhull(V(1,:),V(2,:),V(3,:),'Simplify',true);
    trisurf(k2,V(1,:),V(2,:),V(3,:),'FaceColor',color,'Facealpha',alpha,'EdgeColor','none')
end

hold on
for i = 1:size(A,1)
    % dir
    mag = norm(A(i,:));
    dir = A(i,:)/mag;
    dist = b(i)/mag;
    
    % get points in plane
    V_plane = V(:,(abs(dir*V-dist)<=abs(dist)*tol)); % relative error
    
    % tangent space
    if abs(dir(2))>eps || abs(dir(1))>eps
        T1 = [dir(2) -dir(1) 0];
        T2 = cross(dir.',T1.').';
    else
        % exception for [0 0 x]
        T1 = [0 -dir(3) dir(2)];
        T2 = cross(dir.',T1.').';
    end
    
    % projection and convex hull
    V_proj = [T1;T2]*V_plane;
    if size(V_proj,2)>=3
        k_line = convhull(V_proj(1,:),V_proj(2,:),'Simplify',true);
        
        % select and plot
        V_line = V_plane(:,k_line);
        plot3(V_line(1,:),V_line(2,:),V_line(3,:),'k','LineWidth',linewidth)
        scatter3(V_line(1,:),V_line(2,:),V_line(3,:),20*linewidth,'k.') %smoother line caps for export
        if strcmp(color,'rand')
            fill3(V_line(1,:),V_line(2,:),V_line(3,:),hsv2rgb([rand,1,1]),'Facealpha',alpha)
        end
    end
end