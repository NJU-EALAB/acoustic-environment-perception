function ch = circHarmReal(phi,m)
arguments
    phi (:,1)
    m (1,:)
end
ch = zeros(length(phi),length(m));
ch(:,m<0) = 1./sqrt(pi)*sin(phi*abs(m(m<0)));
ch(:,m==0) = 1./sqrt(2*pi);
ch(:,m>0) = 1./sqrt(pi)*cos(phi*m(m>0));

end