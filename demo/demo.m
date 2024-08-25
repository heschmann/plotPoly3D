
figure()
plotPolytope([eye(3);-eye(3); 1 1 1; 1.5 1 -1;-1 -1.3 0.1],[ones(6,1);0.4;0.6;1.3],'b',0.7,4)
grid on

%%
figure()
R = (1-2*rand(100,3));
plotPolytope([eye(3);-eye(3);R./vecnorm(R')'],[ones(6+size(R,1),1)],'rand',1)
grid on