% clearvars;  close all;
dvars2.alpha_sched = 1;
dvars2.alpha = -10:2:24;

tbl2 = create_cases(dvars2);

CL0 = 0.05;
dCL_dT = @(alpha, dT) (0.05*dT - (abs(dT)-10)^2/400);
CL = @(alpha, beta, left_tail, right_tail) bsxfun(@minus, 2.*pi.*alpha*pi/180 + CL0 - (alpha>8).*((alpha-8).^2 ./ 100) + (alpha>12).*(alpha-12).^3/2000, ...
    abs(beta.^2)./200) + dCL_dT(left_tail) + dCL_dT(right_tail);

% CD0 = 0.03;
% AR = 10;
% e = 0.8;
% CD = @(CL) CD0 + CL.^2 / (pi*e*AR);

% beta = -10:1:10;
% cla reset
% plot(tbl.alpha, CL(tbl.alpha, beta), 'x-')
% xlabel('alpha')
% ylabel('CL')
% grid off
% grid on
% grid minor
% 
% figure;
% plot(beta, CL((-10:5:20)', beta), 'x-')
% xlabel('beta')
% ylabel('CD')
% grid off
% grid on
% grid minor