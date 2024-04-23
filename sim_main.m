% elements in damage for each node 
% Building number 
% Building type (1 - moderate, 2 - severe, 3 - collapse)
% Total number of damaged elements
% Number of elements in damage state 1 (moderate)
% Number of elements in damage state 2 (severe)
% Number of elements in damage state 3 (collapse)
% Total number of damaged elements (sum of columns 4-6)

%C capcity of road link in the network (the first rank is the sum)

%PGA is peak ground acceleration 

%who want to use the code to test their own data could write a generator to
%generate damage and substitue the Capcity matrix with their own data
%following the same structure.



% moderate 1 severe 2 collapse 3

schedule = 1:sum(damage(:,7));
schedule = schedule';



damage1 = damage;
j = 1;
for i = 1:37
	for j = j:(j+damage1(i,7))
		schedule(j,2) = i;
		schedule(j,7) = damage1(i,2);
	end
end


f=@(f1,f2,f3,f4)(-2.539 + 1.985 *f3 + f1 .*(2.003 - 0.594* f2 - 0.746* f3 - 0.535* f4) + f2 .*(1.397 - 0.557 *f3 - 0.202* f4) + 1.344 *f4 - 0.556 *f3 *f4)

num = 1;
damage1 = damage;

% Loop through each building sector

num = 1;
damage1 = damage;
for i= 1:37
	while(damage1(i,4)>0)
		schedule(num,3) =1;
		schedule(num,4) =1;
		num = num+1;
		damage1(i,4) = damage1(i,4)-1;
	end
	while(damage1(i,5)>0)
		schedule(num,3) =2;
		schedule(num,4) =12;
		num = num+1;
		damage1(i,5) = damage1(i,5)-1;
	end
	while (damage1(i,6)>0)
		schedule(num,3) =3;
		schedule(num,4) =36;
		num = num+1;
		damage1(i,6) = damage1(i,6)-1;
	end
end
% Initialize schedule columns
for i = 1:length(schedule)
schedule(i,5) = 0; % Repair finished?
schedule(i,6) = 0; % Elapsed repair time
end
schedule(length(schedule),:) = [];
% Column definitions
% schedule col 1: building number
% col 2: joint number
% col 3: damage state
% col 4: repair time
% col 5: finished?
% col 6: elapsed repair time

% col 7: building type
% col 8: score

%schedule col 1,building number col 2, joint number col 3,damage state col 4,repair time col 5,finished? col 6, repair time 
%col7 building type col 8 score 

% Objective function term for building type 1
func(1) = 1 - sum(1-schedule(find(schedule(:,7)==1),6)./schedule(find(schedule(:,7)==1),4))/sum(damage(find(damage(:,2) == 1),3));
% Find entries in schedule for building type 1
% Calculate repair progress ratio for each entry
% Sum and normalize by total damage
% Objective function term for building type 2
func(2) = 1- sum(1-schedule(find(schedule(:,7)==2),6)./schedule(find(schedule(:,7)==2),4))/sum(damage(find(damage(:,2) == 2),3));
% Repeat for building types 3 and 4
func(3) = 1- sum(1-schedule(find(schedule(:,7)==3),6)./schedule(find(schedule(:,7)==3),4))/sum(damage(find(damage(:,2) == 3),3));
func(4) = 1- sum(1-schedule(find(schedule(:,7)==4),6)./schedule(find(schedule(:,7)==4),4))/sum(damage(find(damage(:,2) == 4),3));
% Evaluate overall objective function
FUNC = f(func(1),func(2),func(3),func(4));


% Capacity
C1=C;
num = 38;
schedule_leanth_total = 38+length(schedule);
% Set capacities for buildings
for i = 1:37
for j = 1:damage(i,7)

C1(i+1,num+j) = 5;
end
num = (num+damage(i,7));
end
% Set capacities for contractors
for i = 39:schedule_leanth_total
C1(i,schedule_leanth_total+1) = 5;
end
C1(schedule_leanth_total+1,schedule_leanth_total+1) = 0;
% Cost array
b = zeros(schedule_leanth_total+1) + realmin*rand()*1000;
% Set costs for contractors
for i = 39:schedule_leanth_total
b(i,schedule_leanth_total+1) = rand()*50;
end
% Call min cost flow
tic;
[f1 wf zwf] = BGf(C1,b);
toc;
% Copy schedule
schedule0 = schedule;
% f1 - flow matrix
% wf - total flow
% zwf - min cost







%%%%%%%%%%%
irr1 = 1;

for irr = irr1:10000
irr


schedule = schedule0;
C1=round(C/8);
num = 38;
%%%%%%bridge damage
for i = 1:23;
a(i) = 0.015;
end
for i = 24:37;
a(i) = 0.018;
end
b = 0.97;
sigma = 0.7;
%PGA = 0.25;
for i = 1:37;
epsilon = exp(normrnd(0, sigma));
theta(i) = a(i) * PGA ^ b * epsilon;
if theta(i) < 0.01
    t(i) = 0;
end
if (theta(i) < 0.015 & theta(i) >= 0.01)
t(i) = 0.2;
end 

if (theta(i) < 0.02 & theta(i) >= 0.015)
    t(i) = 0.5;
end 
if theta(i) >= 0.02
        t(i) = 1;
end
end
['bridge_damage:' num2str(sum(t))]
%%%%%%%%%%%
for i = 1:37
    C1(i+1,1:38) =  C1(i+1,1:38)*(1-t(i));
    C1(1:38,i+1) =  C1(1:38,i+1)*(1-t(i));
end



for i = 1:37
	for j = 1:damage(i,7)
		C1(i+1,num+j) = 5;
	end	
	num = (num+damage(i,7));
end

for i = 39:schedule_leanth_total
	C1(i,schedule_leanth_total+1) = 5;
end
C1(schedule_leanth_total+1,schedule_leanth_total+1) = 0;


func(1) = 1- sum(1-schedule(find(schedule(:,7)==1),6)./schedule(find(schedule(:,7)==1),4))/sum(damage(find(damage(:,2) == 1),3));
func(2) = 1- sum(1-schedule(find(schedule(:,7)==2),6)./schedule(find(schedule(:,7)==2),4))/sum(damage(find(damage(:,2) == 2),3));
func(3) = 1- sum(1-schedule(find(schedule(:,7)==3),6)./schedule(find(schedule(:,7)==3),4))/sum(damage(find(damage(:,2) == 3),3));
func(4) = 1- sum(1-schedule(find(schedule(:,7)==4),6)./schedule(find(schedule(:,7)==4),4))/sum(damage(find(damage(:,2) == 4),3));

Func = f(func(1),func(2),func(3),func(4));

for month = 1:12
if mod(month,5) == 0
    month
end

schedule1 = schedule;
%schedule col 1,building number col 2, joint number col 3,damage state col 4,repair time col 5,finished? col 6, repair time 
%col7 building type col 8 score 
schedule(:,5) = min(schedule(:,5)+floor(schedule(:,6)./schedule(:,4)),1);

func(1) = 1- sum(1-schedule(find(schedule(:,7)==1),6)./schedule(find(schedule(:,7)==1),4))/sum(damage(find(damage(:,2) == 1),3));
func(2) = 1- sum(1-schedule(find(schedule(:,7)==2),6)./schedule(find(schedule(:,7)==2),4))/sum(damage(find(damage(:,2) == 2),3));
func(3) = 1- sum(1-schedule(find(schedule(:,7)==3),6)./schedule(find(schedule(:,7)==3),4))/sum(damage(find(damage(:,2) == 3),3));
func(4) = 1- sum(1-schedule(find(schedule(:,7)==4),6)./schedule(find(schedule(:,7)==4),4))/sum(damage(find(damage(:,2) == 4),3));

Func = f(func(1),func(2),func(3),func(4));

score(month,1) = month;
score(month,1+irr) = Func;

t1(:,1+irr) = t;

% Initialize schedule columns for i = 1:246 schedule(i,5) = 0; schedule(i,6) = 0; end
% Evaluate objective function func(1) = ...
% Capacity array C1=C;
% Cost array b = zeros(285)+realmin*rand()*1000;
% Call min cost flow [f1 wf zwf] = BGf(C1,b);
% Optimization loop for irr = irr1:1000
% Reset arrays
% Set capacities based on collapse probability
% Evaluate objective
% Repair loop
% Increment repair time
% Evaluate objective
% Calculate score
% Min cost flow
% Update schedule

for i = 1:length(schedule)
	if schedule(i,5) == 0
		schedule1(i,6) = 1;
		func1(1) = 1- sum(1-schedule1(find(schedule(:,7)==1),6)./schedule(find(schedule(:,7)==1),4))/sum(damage(find(damage(:,2) == 1),3));
		func1(2) = 1- sum(1-schedule1(find(schedule(:,7)==2),6)./schedule(find(schedule(:,7)==2),4))/sum(damage(find(damage(:,2) == 2),3));
		func1(3) = 1- sum(1-schedule1(find(schedule(:,7)==3),6)./schedule(find(schedule(:,7)==3),4))/sum(damage(find(damage(:,2) == 3),3));
		func1(4) = 1- sum(1-schedule1(find(schedule(:,7)==4),6)./schedule(find(schedule(:,7)==4),4))/sum(damage(find(damage(:,2) == 4),3));
		Func1 = f(func1(1),func1(2),func1(3),func1(4));
		schedule(i,8) = (Func1*1000)-Func*1000;
		schedule1 = schedule;
	end
	
	if (schedule(i,5) < 1)
		if (schedule(i,5) > 0)
			schedule(i,8) = max(schedule(:,8)*1.5)/1.25;%maximum efficiency -1
		end
	end

	if (schedule(i,5) == 1)
			C1(:,i+38) = 0;%maximum efficiency -1
	end
end


f1 = 1;
while(f1 == 1)
b = zeros(schedule_leanth_total+1)+realmin*rand()*1000;
%cost
for i = 39:schedule_leanth_total
	b(i,schedule_leanth_total) =  (max(schedule(:,8)*1.5)*month - schedule(i-38,8)*month)+rand()*35/month^(0.5);
end

%f1 flow matrix wf total flow zwf mincost
%tic;
%%%%BGf changed, if too long time, then f1=1;
[f1 wf zwf] = BGf(C1,b);
%toc;


score1(month,1) = month;
temp_list = intersect((find(schedule(:,5)==0)+38),39:schedule_leanth_total);
%length(temp_list) 
if length(temp_list) == 0
    score1(month,1+irr) = 1;
else
    score1(month,1+irr) = sum(f1(temp_list,schedule_leanth_total+1).*b(temp_list,schedule_leanth_total))/sum(C1(temp_list,schedule_leanth_total+1).*b(temp_list,schedule_leanth_total));
end


end


temp = f1(39:schedule_leanth_total,schedule_leanth_total+1)/5;

schedule(:,6) = schedule(:,6)+temp;



end


end










