function dis = polygon2distance(vertexPos)
arguments
    vertexPos (:,2)
end
N = size(vertexPos,1);
vertexPos = [vertexPos;vertexPos(1,:)];
normVec = zeros(N,2);
for ii = 1:N
    normVec(ii,:) = lin2normVec(vertexPos(ii,:),vertexPos(ii+1,:));
end
dis = vecnorm(normVec,2,2);
if 1
    figure;
    plot(vertexPos(:,1),vertexPos(:,2));
    axis equal
    hold on
    str = {'polygon'};
    for ii = 1:N
        plot([0,normVec(ii,1)],[0,normVec(ii,2)])
        str = [str,{num2str(ii)}];
    end
    legend(str)
end
end

function normVec = lin2normVec(p1,p2)
p1 = p1(:);
p2 = p2(:);
k = p1.'*(p1-p2)./norm(p2-p1).^2;
normVec = (k*(p2-p1)+p1);
end