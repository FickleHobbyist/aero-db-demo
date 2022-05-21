% this utilizes code from the following FEX package:
% https://www.mathworks.com/matlabcentral/fileexchange/68298-sqlite3

clearvars;clc;
dbfile = 'example_wt_data.db';

rs_file = 'run_sched.csv';
tp_file = 'test_points.csv';
% The insert operation via sqlite3 MEX is pretty slow for some reason. It
% can be done much quicker via command line.
tic
build_db_table(dbfile, 'run_sched', rs_file);
toc
tic
build_db_table(dbfile, 'test_points', tp_file);
toc
%%
run_vars = fieldnames(sqlite3(dbfile, 'SELECT * from run_sched LIMIT 1'));
tp_vars = fieldnames(sqlite3(dbfile, 'SELECT * from run_sched LIMIT 1'));
query = [
    'SELECT * FROM run_sched r ',...
    'LEFT JOIN test_points tp USING(run) ',...
    'WHERE ',... 
	'r.description LIKE ''%Baseline%'' AND r.beta_sched = 0;'
    ];
tic;
out = sqlite3(dbfile, query);
toc;