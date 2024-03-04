function nrmmatrix = nrmrnd(mu, sigma, sz1, sz2)
    nrmmatrix = mu+sigma*randn(sz1,sz2);
end