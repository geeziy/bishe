clear all
close all
clc
%% ABC算法的控制参数
%初始化种群参数
NP=20;                          %/*群体数量的大小（引领蜂与侦察蜂之和）*/
FoodNumber=NP/2;                %/*蜜源的数量等于群体数量的一半*/
limit=100;                      %/*一个蜜源最大搜索次数（一个蜜源通过limit次实验后无法改善则被雇佣蜂遗弃）*/
maxCycle=2500;                  %/*最大迭代次数（觅食的周期数）*/

%% 问题具体变量
objfun='rastrigin';                %/被优化函数/
D=100;                          %/*参数维数*/
ub=ones(1,D)*100;               %/*参数的下限*/
lb=ones(1,D)*(-100);            %/*参数的上限*/
runtime=10;                      %/*算法可以运行多次以查看其鲁棒性*/
GlobaMins=zeros(1,runtime);           %/*最优解*/
tempiter=ones(1,maxCycle);      %/*用于存储数据*/
tempGlobaMin=ones(1,maxCycle);  %/*用于存储数据*/
Min=0;                          %/*取GlobaMins中的最小值*/


%% 变量解释
%{
Foods [FoodNumber][D]; /*Foods是蜜源的数量.Foods矩阵的每一行都是一个保存要优化的D参数的向量.Foods矩阵行的个数等于FoodNumber*/
Fitness[FoodNumber]; /*fitness是一个存放与蜜源有关的适应度值的向量*/
trial[FoodNumber]; /*trial是一个存放那些无法改进的节的实验数量的向量*/
prob[FoodNumber]; /*prob是一个存放蜜源（解）被选择的概率的向量*/
ObjValSol; /*新解的目标函数值*/
FitnessSol; /*新解的Fitness值*/
neighbour, param2change; /*在等式中 v_{ij}=x_{ij}+\phi_{ij}*(x_{kj}-x_{ij})的param2change对应于j, neighbour对应于k */
GlobalMin; /* ABC算法得到的最优解*/
GlobalParams[D]; /*最优解的参数*/
GlobalMins[runtime]; /*GlobalMins保存多次运行中每次运行的GlobalMin*/
%}


for r=1:runtime
    % /*所有蜜源初始化*/
    %/*变量在范围[lb，ub]中初始化。 如果每个参数的范围不同，使用数组lb [j]，ub [j]代替lb和ub*/
    Range=repmat((ub-lb),[FoodNumber 1]);
    Lower=repmat(lb,[FoodNumber 1]);
    Foods=rand(FoodNumber,D).*Range+Lower;
    %计算适应复值
    ObjVal=feval(objfun,Foods);
    Fitness=calculateFitness(ObjVal);
    %初始化搜索次数
    trial=zeros(1,FoodNumber);
    %记录最好的食物源，找出最小值
    BestInd=find(ObjVal==min(ObjVal));
    BestInd=BestInd(end);
    GlobaMin=ObjVal(BestInd);
    GlobalParams=Foods(BestInd,:);
    
    iter=1;
    while((iter<=maxCycle)),
%% 引领蜂阶段
        for i=1:(FoodNumber)
            
            %要更改的参数是随机确定的
            Param2Change=fix(rand*D)+1;
            
            %随机选择的解用于生成解i的突变解
            neighbour=fix(rand*(FoodNumber))+1;
            
            %随机选择的解必须与解i不同
            while(neighbour==i)
                neighbour=fix(rand*(FoodNumber))+1;
            end;
            sol=Foods(i,:);
            
            % v_{ij}=x_{ij}+\phi_{ij}*(x_{kj}-x_{ij}) 
            sol(Param2Change)=Foods(i,Param2Change)+(Foods(i,Param2Change)-Foods(neighbour,Param2Change))*(rand-0.5)*2;
            
            %如果生成的参数值超出边界，则会移至边界。确保新产生的解（蜜源）在参数范围内
            ind=find(sol<lb);
            sol(ind)=lb(ind);
            ind=find(sol>ub);
            sol(ind)=ub(ind);
            
            %评估新解，计算新蜜源的适应度值
            ObjValSol=feval(objfun,sol);
            FitnessSol=calculateFitness(ObjValSol);
            
            %在当前的解i和它的突变解之间应用贪婪选择
            if(FitnessSol>Fitness(i))   %/*如果突变体解比当前的解更好，则用突变体替换解，并重置解i的试验计数器，搜索次数清0*/
                Foods(i,:)=sol;
                Fitness(i)=FitnessSol;
                ObjVal(i)=ObjValSol;
                trial(i)=0;
            else
                trial(i)=trial(i)+1;    %/*如果解无法改进，搜索次数加1*/
            end;
        end;
        
%% 根据适应度值计算引领蜂被跟随的概率
     %选择食物源的概率与其质量成正比
        prob=(0.9.*Fitness./max(Fitness))+0.1;
        
%% 跟随蜂阶段
        i=1;
        t=0;
        while(t<FoodNumber)
            if(rand<prob(i))    %按概率选择要跟随的引领蜂
                t=t+1;
                Param2Change=fix(rand*D)+1;
                neighbour=fix(rand*(FoodNumber))+1;
                while(neighbour==i)
                    neighbour=fix(rand*(FoodNumber))+1;
                end;
                sol=Foods(i,:);
                sol(Param2Change)=Foods(i,Param2Change)+(Foods(i,Param2Change)-Foods(neighbour,Param2Change))*(rand-0.5)*2;
                %   /*确保新产生的解在范围内*/
                ind=find(sol<lb);
                sol(ind)=lb(ind);
                ind=find(sol>ub);
                sol(ind)=ub(ind);
                
                %计算新蜜源的适应度值
                ObjValSol=feval(objfun,sol);
                FitnessSol=calculateFitness(ObjValSol);
                %  /*贪婪选择*/
                if(FitnessSol>Fitness(i))   %/*若找到更好的蜜源，搜索次数清0*/
                    Foods(i,:)=sol;
                    Fitness(i)=FitnessSol;
                    ObjVal(i)=ObjValSol;
                    trial(i)=0;
                else
                    trial(i)=trial(i)+1;    %/*否则，搜索次数加1*/
                end;
            end;
            i=i+1;
            if(i==(FoodNumber)+1)
                i=1;
            end;
        end;
        
        %/*记录最好的解*/
        ind=find(ObjVal==min(ObjVal));
        ind=ind(end);
        if(ObjVal(ind)<GlobaMin)
            GlobaMin=ObjVal(ind);
            GlobalParams=Foods(ind,:);
        end;
        
%% 侦察蜂阶段
%确定试验计数器超过“极限”值的食物源
%在基本ABC中，每个周期只允许发生一次侦察
        ind=find(trial==max(trial));
        ind=ind(end);
        if(trial(ind)>limit)  %若搜索次数超过极限值，进行随机搜索产生新的解
            Bas(ind)=0;
            sol=(ub-lb).*rand(1,D)+lb;
            ObjValSol=feval(objfun,sol);
            FitnessSol=calculateFitness(ObjValSol);
            Foods(ind,:)=sol;
            Fitness(ind)=FitnessSol;
            ObjVal(ind)=ObjValSol;
        end;
        fprintf('iter=%d GlobaMin=%g\n',iter,GlobaMin);
        tempiter(iter)=iter;   %存储迭代次数，用来绘图
        tempGlobaMin(iter)=GlobaMin;    %存储每一次迭代后的最优解，用来绘图
        iter=iter+1;
        
    end   %ABC算法结束

   GlobaMins(r)=GlobaMin;

end;   %运行结束
GlobaMins                  %输出GlobaMins
Min=min(GlobaMins)         %输出GlobaMins中的最小值，既多次运行后取最小值
%% 绘图
% plot(tempiter,tempGlobaMin)
% xlabel('迭代次数');
% ylabel('目标函数值');
% figure(2)
%DrawSphere
%DrawRosenbrock
%DrawRastrigin
%DrawGriewank
%Drawackley
save all