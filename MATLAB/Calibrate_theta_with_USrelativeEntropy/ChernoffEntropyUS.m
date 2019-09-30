function rho = ChernoffEntropyUS(etaU,etaS,zgrid,param)
% zgrid should be 1*Nz
% Note that U is the H in Distortion.m; S is the R in Distortion.m

% Read param

q = param.q;

alphayhat = param.alphayhat;
alphazhat = param.alphazhat;
betahat = param.betahat;
kappahat = param.kappahat;
sigmay = param.sigmay;
sigmaz = param.sigmaz;
delta = param.delta;

% rho1 = param.rho1;
% rho2 = param.rho2;
% zbar = param.zbar;
sigma = param.sigma;
a = param.a;
b = param.b;
d = param.d;

% Target function

function rhos = Rhos(s)
    Dz = zgrid(2)-zgrid(1);
    Nz = size(zgrid,2);
    
    Q = [];
    for j = 2:(Nz-1)
        one = -(sigmaz.'*(s*etaU(:,j)+(1-s)*etaS(:,j))+alphazhat-kappahat*zgrid(j))/(2*Dz) + 0.5*norm(sigmaz)^2/(Dz^2);
        two = -s*(1-s)/2*norm(etaU(:,j)-etaS(:,j))^2 - norm(sigmaz)^2/Dz^2;
        three = (sigmaz.'*(s*etaU(:,j)+(1-s)*etaS(:,j))+alphazhat-kappahat*zgrid(j))/(2*Dz) + 0.5*norm(sigmaz)^2/(Dz^2);
        row = [zeros(1,j-2),one,two,three,zeros(1,Nz-j-1)];
        Q = [Q;row];
    end
    
%     two = (-s*(1-s)/2*norm(eta(:,1))^2 - norm(sigmaz)^2/Dz^2);
%     three = norm(sigmaz)^2/(Dz^2);
%     row1 = [two,three,zeros(1,Nz-2)];
%     
%     two = (-s*(1-s)/2*norm(eta(:,Nz))^2 - norm(sigmaz)^2/Dz^2);
%     one = norm(sigmaz)^2/(Dz^2);
%     rowNz = [zeros(1,Nz-2),one,two];
    
%     Q = [row1;Q;rowNz];
%     [tmpV,tmpD] = eig(Q);
%     rhos = max(real(diag(tmpD)));  
    
    one = -s*(1-s)/2*norm(etaU(:,1)-etaS(:,1))^2 - (sigmaz.'*(s*etaU(:,1)+(1-s)*etaS(:,1))+alphazhat-kappahat*zgrid(1))/Dz + 0.5 * norm(sigmaz)^2/Dz^2;
    two = (sigmaz.'*(s*etaU(:,1)+(1-s)*etaS(:,1))+alphazhat-kappahat*zgrid(1))/Dz - norm(sigmaz)^2/(Dz^2);
    three = 0.5*norm(sigmaz)^2/(Dz^2);
    row1 = [one,two,three,zeros(1,Nz-3)];
    
    three = -s*(1-s)/2*norm(etaU(:,Nz)-etaS(:,Nz))^2 + (sigmaz.'*(s*etaU(:,Nz)+(1-s)*etaS(:,Nz))+alphazhat-kappahat*zgrid(Nz))/Dz + 0.5 * norm(sigmaz)^2/Dz^2;
    two = -(sigmaz.'*s*(etaU(:,Nz)+(1-s)*etaS(:,Nz))+alphazhat-kappahat*zgrid(Nz))/Dz - norm(sigmaz)^2/(Dz^2);
    one = 0.5*norm(sigmaz)^2/(Dz^2);
    rowNz = [zeros(1,Nz-3),one,two,three];
    
    Q = [row1;Q;rowNz];
    [tmpV,tmpD] = eig(Q);
%     tmp = sum(real(tmpV)>0,1);
%     pick = find(tmp==Nz | tmp==0);
%     diagD = real(diag(tmpD));
%     rhos = diagD(pick);
    rhos = max(real(diag(tmpD)));  
    
end

% Calculate Chernoff Entropy

[s,rho] = fmincon(@Rhos,0.5,[],[],[],[],0,1);
rho = -rho;

end