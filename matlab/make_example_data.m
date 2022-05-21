clearvars; close all; clc;
dvars.alpha_sched = 1;
dvars.beta_sched = -10:5:10;
dvars.tail_left = -20:5:20;
dvars.tail_right = -20:5:20;

tbl = create_cases(dvars);

dE_id = @(tbl) tbl.tail_left == tbl.tail_right;
dR_id = @(tbl) tbl.tail_left == -tbl.tail_right;
dR = @(tbl) (tbl.tail_left - tbl.tail_right) ./ 2;
mix_id = @(tbl) abs(tbl.tail_left) == abs(2*tbl.tail_right) |...
            abs(tbl.tail_left) == abs(3*tbl.tail_right);
right_only = @(tbl) tbl.tail_left == 0 & tbl.tail_right ~= 0;

tbl = tbl(dE_id(tbl) | (dR_id(tbl) & dR(tbl) > 0) | mix_id(tbl) | right_only(tbl), :);

tbl(tbl.tail_left == tbl.tail_right & tbl.beta_sched < 0, :) = [];

hold off;
scatter(tbl.tail_right, tbl.tail_left, 'filled', 'DisplayName', 'Planned Test Points')
xlabel('right tail')
ylabel('left tail')
grid off
grid on
grid minor
hold on
xlim([-30, 30])
ylim([-30, 30])
sym_id = tbl.tail_left == tbl.tail_right;
scatter(tbl.tail_left(~sym_id), tbl.tail_right(~sym_id), 'Marker', 'x', 'DisplayName', 'Mirror Symmetry Points')
legend(gca, 'show')

tbl.run = (1:size(tbl,1))';
tbl = tbl(:,[5 1:4]);

base_id = tbl.tail_left == 0 & tbl.tail_right == 0;
tbl.description = repmat({''}, size(tbl.run));
tbl.description(base_id) = {'Baseline'};
tbl.description(tbl.tail_left == tbl.tail_right & ~base_id) = {'Tail Study - Elevator'};
tbl.description(tbl.tail_left == -tbl.tail_right & ~base_id) = {'Tail Study - Rudder'};
tbl.description(right_only(tbl)) = {'Tail Study - Right Only'};
tbl.description(~(dR_id(tbl) | dE_id(tbl) | base_id | right_only(tbl))) = {'Tail Study - Mixed Deflections'};

%% now generate fictitious CL data
dvars2.alpha_sched = 1;
dvars2.alpha = -10:2:24;

tbl2 = create_cases(dvars2);

CL0 = 0.05;
dCL_dT = @(dT) (0.005.*dT - (abs(dT)-10).^2./400);
CL = @(alpha, beta, left_tail, right_tail) bsxfun(@minus, 2.*pi.*alpha*pi/180 + CL0 - (alpha>8).*((alpha-8).^2 ./ 100) + (alpha>12).*(alpha-12).^3/2000, ...
    abs(beta.^2)./200) + dCL_dT(left_tail) + dCL_dT(right_tail);
tbl3 = outerjoin(tbl, tbl2, 'MergeKeys', true);
tbl3.Properties.VariableNames = strrep(tbl3.Properties.VariableNames, 'beta_sched', 'beta');

tbl3.CL = CL(tbl3.alpha, tbl3.beta, tbl3.tail_left, tbl3.tail_right);
tbl3(:,{'alpha_sched', 'tail_left', 'tail_right', 'description'}) = [];

% beta = -10:1:10;
% cla reset
% plot(tbl.alpha, CL(tbl.alpha, beta), 'x-')
% xlabel('alpha')
% ylabel('CL')
% grid off
% grid on
% grid minor

figure
plot(tbl2.alpha, CL(tbl2.alpha, 0, 0, 0), 'x-')
xlabel('alpha')
ylabel('CL')
grid off
grid on
grid minor

writetable(tbl, 'run_sched.csv')
writetable(tbl3, 'test_points.csv')