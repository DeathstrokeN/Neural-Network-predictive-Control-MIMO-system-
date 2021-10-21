function J = evalcritc(u, r, Hp, Hc, lambda, phi, xi1, ai2, ukm1, stoch)

Nu=size(xi1,1);

rpred = repmat(r,1,Hp);

deltau=[u(:,1)-ukm1 diff(u,1,2)];
uHp=[u repmat(u(:,end),1,Hp-Hc)];

ypred=NNc(uHp,xi1, ai2);

J = phi*sum((ypred+stoch - rpred).^2,2) + lambda*sum(deltau.^2,2);

end
