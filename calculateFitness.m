function Fitness=calculateFitness(fObjV)     %������Դ��Ӧ��ֵ
Fitness=zeros(size(fObjV));
ind=find(fObjV>=0);
Fitness(ind)=1./(fObjV(ind)+1);
ind=find(fObjV<0);
Fitness(ind)=1+abs(fObjV(ind));