function Fitness=calculateFitness(fObjV)     %计算蜜源适应度值
Fitness=zeros(size(fObjV));
ind=find(fObjV>=0);
Fitness(ind)=1./(fObjV(ind)+1);
ind=find(fObjV<0);
Fitness(ind)=1+abs(fObjV(ind));