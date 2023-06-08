% findthrustforces.m
% 
%     * Find the set of forces F1...F6 around a stable operating point
%       when th=0 and ph=0.
%
%     * Bowing angle of the pilot(a) is defined as 34 degree.
%
% Usage: * eqn1...eqn6  : Forces and moments = 0. eqn2 does not exist,
%                         since no lateral thrust is produced. 
%        * eqn7...eqn12 : Define positive thrust.
%        * eqn30..eqn35 : Thrust forces < 1000
%
%     * Distances are in [m] unit, forces are in [N].
%

clear; clc;
syms F1 F2 F3 F4 F5 F6;

% Enter the motor position values manually below.
x1 = -186.91 * 10^-3; x3 =  -39.59 * 10^-3; x5 = 390.45 * 10^-3; %m
y1 =     145 * 10^-3; y3 =  445.67 * 10^-3; y5 = 601.63 * 10^-3; %m
z1 = -313.54 * 10^-3; z3 = -228.49 * 10^-3; z5 = -35.01 * 10^-3; %m
% Enter motor angles below.
a = 34 / 180 * pi; % rad

% Enter other known values.
m= 100; g= 9.80665; th=0; ph=0;

% Xg, Yg, Zg are the gravity force components at a given orientation.
Xg = -m * g * sin(th);
Yg =  m * g * cos(th) * sin(ph);
Zg =  m * g * cos(th) * cos(ph); 

% Define zero force and torque on the system
eqn1 = 0 ==  (F1 + F2 + F3 + F4)*sin(a) - (F5+F6)*cos(a) + Xg;
eqn3 = 0 == -(F1 + F2 + F3 + F4)*cos(a) - (F5+F6)*sin(a) + Zg;
eqn4 = 0 == ( (F2-F1)*y1 + (F4-F3)*y3 )*cos(a) + (F6-F5)*y5*sin(a);
eqn5 = 0 == ( (F2+F1)*x1 + (F4+F3)*x3 )*cos(a) + (F5+F6)*x5*sin(a)+ ...
            ( (F2+F1)*z1 + (F4+F3)*z3 )*sin(a) - (F5+F6)*z5*cos(a);
eqn6 = 0 == ( (F2-F1)*y1 + (F4-F3)*y3 )*sin(a) + (F5-F6)*y5*cos(a);

% Define positive thrust
eqn7 =  F1 > 0; eqn8 =  F2 > 0; eqn9 =  F3 > 0;
eqn10=  F4 > 0; eqn11=  F5 > 0; eqn12=  F6 > 0;

% Thrust upper limit
eqn30 = F1 < 1000; eqn31 = F2 < 1000; eqn32 = F3 < 1000;
eqn33 = F4 < 1000; eqn34 = F5 < 1000; eqn35 = F6 < 1000;

% Get the equations into a system
OpPoint = [ eqn1; eqn3; eqn4; eqn5; eqn6;...             % total f/m = 0
            eqn7; eqn8; eqn9; eqn10; eqn11; eqn12;...    % thrust > 0
            eqn30; eqn31; eqn32; eqn33; eqn34; eqn35]    % thrust < 1000

S = solve(OpPoint,[F1 F2 F3 F4 F5 F6],'ReturnConditions', true);
F1 = vpa(S.F1,4)
F2 = vpa(S.F2,4)
F3 = vpa(S.F3,4)
F4 = vpa(S.F4,4)
F5 = vpa(S.F5,4)
F6 = vpa(S.F6,4)
conditions= vpa(S.conditions,4)

F1r = double(subs(S.F1, S.parameters, 390));
F2r = double(subs(S.F2, S.parameters, 390));
F3r = double(subs(S.F3, S.parameters, 390));
F4r = double(subs(S.F4, S.parameters, 390));
F5r = double(subs(S.F5, S.parameters, 390));
F6r = double(subs(S.F6, S.parameters, 390));

X1 = sprintf('F1: %4f N',F1r);
disp(X1)
X2 = sprintf('F2: %4f N',F2r);
disp(X2)
X3 = sprintf('F3: %4f N',F3r);
disp(X3)
X4 = sprintf('F4: %4f N',F4r);
disp(X4)
X5 = sprintf('F5: %4f ',F5r);
disp(X5)
X6 = sprintf('F6: %4f ',F6r);
disp(X6)