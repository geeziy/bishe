clear all
close all
clc
%% ABC�㷨�Ŀ��Ʋ���
%��ʼ����Ⱥ����
NP=20;                          %/*Ⱥ�������Ĵ�С�������������֮�ͣ�*/
FoodNumber=NP/2;                %/*��Դ����������Ⱥ��������һ��*/
limit=100;                      %/*һ����Դ�������������һ����Դͨ��limit��ʵ����޷������򱻹�Ӷ��������*/
maxCycle=2500;                  %/*��������������ʳ����������*/

%% ����������
objfun='rastrigin';                %/���Ż�����/
D=100;                          %/*����ά��*/
ub=ones(1,D)*100;               %/*����������*/
lb=ones(1,D)*(-100);            %/*����������*/
runtime=10;                      %/*�㷨�������ж���Բ鿴��³����*/
GlobaMins=zeros(1,runtime);           %/*���Ž�*/
tempiter=ones(1,maxCycle);      %/*���ڴ洢����*/
tempGlobaMin=ones(1,maxCycle);  %/*���ڴ洢����*/
Min=0;                          %/*ȡGlobaMins�е���Сֵ*/


%% ��������
%{
Foods [FoodNumber][D]; /*Foods����Դ������.Foods�����ÿһ�ж���һ������Ҫ�Ż���D����������.Foods�����еĸ�������FoodNumber*/
Fitness[FoodNumber]; /*fitness��һ���������Դ�йص���Ӧ��ֵ������*/
trial[FoodNumber]; /*trial��һ�������Щ�޷��Ľ��Ľڵ�ʵ������������*/
prob[FoodNumber]; /*prob��һ�������Դ���⣩��ѡ��ĸ��ʵ�����*/
ObjValSol; /*�½��Ŀ�꺯��ֵ*/
FitnessSol; /*�½��Fitnessֵ*/
neighbour, param2change; /*�ڵ�ʽ�� v_{ij}=x_{ij}+\phi_{ij}*(x_{kj}-x_{ij})��param2change��Ӧ��j, neighbour��Ӧ��k */
GlobalMin; /* ABC�㷨�õ������Ž�*/
GlobalParams[D]; /*���Ž�Ĳ���*/
GlobalMins[runtime]; /*GlobalMins������������ÿ�����е�GlobalMin*/
%}


for r=1:runtime
    % /*������Դ��ʼ��*/
    %/*�����ڷ�Χ[lb��ub]�г�ʼ���� ���ÿ�������ķ�Χ��ͬ��ʹ������lb [j]��ub [j]����lb��ub*/
    Range=repmat((ub-lb),[FoodNumber 1]);
    Lower=repmat(lb,[FoodNumber 1]);
    Foods=rand(FoodNumber,D).*Range+Lower;
    %������Ӧ��ֵ
    ObjVal=feval(objfun,Foods);
    Fitness=calculateFitness(ObjVal);
    %��ʼ����������
    trial=zeros(1,FoodNumber);
    %��¼��õ�ʳ��Դ���ҳ���Сֵ
    BestInd=find(ObjVal==min(ObjVal));
    BestInd=BestInd(end);
    GlobaMin=ObjVal(BestInd);
    GlobalParams=Foods(BestInd,:);
    
    iter=1;
    while((iter<=maxCycle)),
%% �����׶�
        for i=1:(FoodNumber)
            
            %Ҫ���ĵĲ��������ȷ����
            Param2Change=fix(rand*D)+1;
            
            %���ѡ��Ľ��������ɽ�i��ͻ���
            neighbour=fix(rand*(FoodNumber))+1;
            
            %���ѡ��Ľ�������i��ͬ
            while(neighbour==i)
                neighbour=fix(rand*(FoodNumber))+1;
            end;
            sol=Foods(i,:);
            
            % v_{ij}=x_{ij}+\phi_{ij}*(x_{kj}-x_{ij}) 
            sol(Param2Change)=Foods(i,Param2Change)+(Foods(i,Param2Change)-Foods(neighbour,Param2Change))*(rand-0.5)*2;
            
            %������ɵĲ���ֵ�����߽磬��������߽硣ȷ���²����Ľ⣨��Դ���ڲ�����Χ��
            ind=find(sol<lb);
            sol(ind)=lb(ind);
            ind=find(sol>ub);
            sol(ind)=ub(ind);
            
            %�����½⣬��������Դ����Ӧ��ֵ
            ObjValSol=feval(objfun,sol);
            FitnessSol=calculateFitness(ObjValSol);
            
            %�ڵ�ǰ�Ľ�i������ͻ���֮��Ӧ��̰��ѡ��
            if(FitnessSol>Fitness(i))   %/*���ͻ�����ȵ�ǰ�Ľ���ã�����ͻ�����滻�⣬�����ý�i�����������������������0*/
                Foods(i,:)=sol;
                Fitness(i)=FitnessSol;
                ObjVal(i)=ObjValSol;
                trial(i)=0;
            else
                trial(i)=trial(i)+1;    %/*������޷��Ľ�������������1*/
            end;
        end;
        
%% ������Ӧ��ֵ��������䱻����ĸ���
     %ѡ��ʳ��Դ�ĸ�����������������
        prob=(0.9.*Fitness./max(Fitness))+0.1;
        
%% �����׶�
        i=1;
        t=0;
        while(t<FoodNumber)
            if(rand<prob(i))    %������ѡ��Ҫ����������
                t=t+1;
                Param2Change=fix(rand*D)+1;
                neighbour=fix(rand*(FoodNumber))+1;
                while(neighbour==i)
                    neighbour=fix(rand*(FoodNumber))+1;
                end;
                sol=Foods(i,:);
                sol(Param2Change)=Foods(i,Param2Change)+(Foods(i,Param2Change)-Foods(neighbour,Param2Change))*(rand-0.5)*2;
                %   /*ȷ���²����Ľ��ڷ�Χ��*/
                ind=find(sol<lb);
                sol(ind)=lb(ind);
                ind=find(sol>ub);
                sol(ind)=ub(ind);
                
                %��������Դ����Ӧ��ֵ
                ObjValSol=feval(objfun,sol);
                FitnessSol=calculateFitness(ObjValSol);
                %  /*̰��ѡ��*/
                if(FitnessSol>Fitness(i))   %/*���ҵ����õ���Դ������������0*/
                    Foods(i,:)=sol;
                    Fitness(i)=FitnessSol;
                    ObjVal(i)=ObjValSol;
                    trial(i)=0;
                else
                    trial(i)=trial(i)+1;    %/*��������������1*/
                end;
            end;
            i=i+1;
            if(i==(FoodNumber)+1)
                i=1;
            end;
        end;
        
        %/*��¼��õĽ�*/
        ind=find(ObjVal==min(ObjVal));
        ind=ind(end);
        if(ObjVal(ind)<GlobaMin)
            GlobaMin=ObjVal(ind);
            GlobalParams=Foods(ind,:);
        end;
        
%% ����׶�
%ȷ��������������������ޡ�ֵ��ʳ��Դ
%�ڻ���ABC�У�ÿ������ֻ������һ�����
        ind=find(trial==max(trial));
        ind=ind(end);
        if(trial(ind)>limit)  %������������������ֵ������������������µĽ�
            Bas(ind)=0;
            sol=(ub-lb).*rand(1,D)+lb;
            ObjValSol=feval(objfun,sol);
            FitnessSol=calculateFitness(ObjValSol);
            Foods(ind,:)=sol;
            Fitness(ind)=FitnessSol;
            ObjVal(ind)=ObjValSol;
        end;
        fprintf('iter=%d GlobaMin=%g\n',iter,GlobaMin);
        tempiter(iter)=iter;   %�洢����������������ͼ
        tempGlobaMin(iter)=GlobaMin;    %�洢ÿһ�ε���������Ž⣬������ͼ
        iter=iter+1;
        
    end   %ABC�㷨����

   GlobaMins(r)=GlobaMin;

end;   %���н���
GlobaMins                  %���GlobaMins
Min=min(GlobaMins)         %���GlobaMins�е���Сֵ���ȶ�����к�ȡ��Сֵ
%% ��ͼ
% plot(tempiter,tempGlobaMin)
% xlabel('��������');
% ylabel('Ŀ�꺯��ֵ');
% figure(2)
%DrawSphere
%DrawRosenbrock
%DrawRastrigin
%DrawGriewank
%Drawackley
save all