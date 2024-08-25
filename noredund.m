function [Ared, bred] = noredundV2(A,b,check)

% check option allows you to only check selected constraints in case the
% polytope is proceedingly generated, which can save time

scale = vecnorm(A')';
A = A./scale;
b = b./scale;

if nargin == 2
    check = 1:length(b); % check all
end

opts = optimoptions(@linprog,'display','off'); %,'Algorithm','interior-point'

selCurr = 1:length(b);
for i = flip(check)
    sel = selCurr; % all valid
    sel(sel==i) = []; % delete current
    [Xopt,~,flag] = linprog(-A(i,:),A(sel,:),b(sel),[],[],[],[],opts);

    if flag ~= -3 && A(i,:)*Xopt-b(i)<=0 % not unbounded and redundant
        selCurr(selCurr==i) = []; % delete redundant for future linprog calls
    end
end

Ared = A(selCurr,:);
bred = b(selCurr);