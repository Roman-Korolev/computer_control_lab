in = fopen('C:\Users\Roman\Desktop\computer control\input.txt');
for i = 1:5
    matrix = fgetl(in);
    eval(matrix);
end
fclose(in);
X = X';
U = U';
N = N';
Y = Y';
A = randn(length(X));
B = randn(length(X),length(U));
E = randn(length(X),length(N));
C = randn(length(Y),length(X));
D = randn(length(Y),length(U));
F = randn(length(Y),length(N));

a = eig(A);
stability = 0;
for i=1:size(a,1) 
    if (abs(a(i))>1)
       stability = 0; 
    elseif (abs(a(i))==1)
       stability = 2; 
    end
end

if (stability == 0)
    disp('Система неустойчива'); 
elseif (stability == 1)
	disp('Система устойчива');
elseif (stability == 2)
	disp('Система на границе устойчивости');
end

X_log = zeros(length(X),T);
Y_log = zeros(length(Y),T);
alpha = 0.3;

for i = 1:T
    if(i == 1)
        X = A*X + B*U + E*N;
        X_f = X;
    else
        X_f = X_f + alpha*(X - X_f);
        X = A*X_f + B*U + E*N;
    end
    Y = C*X + D*U + F*N;
    X_log(:,i) = X;
    Y_log(:,i) = Y;
end

dlmwrite('C:\Users\Roman\Desktop\computer control\output.txt',  Y_log); 

figure(1);
plot(X_log');
grid on;
title('X');


figure(2);
plot(Y_log');
grid on;
title('Y');

Y_d_log = zeros(size(Y,1),T/2);
extreme_num = 1;
extreme = 0;
for i = 1:(T-1)
   if(((Y_log(:,i+1) - Y_log(:,i))*(-1)^mod(extreme_num - 1,2)) > 0)
        
   else
        Y_d_log(:,extreme_num) = Y_log(:,i);
        extreme_num = extreme_num + 1;
   end
end
pr = (max(Y_d_log) - Y_log(T))/Y_log(T)*100;
disp('Перерегулирование: ');
disp(pr);
