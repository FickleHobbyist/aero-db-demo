function build_db_table( dbfile, tblName, tblFile )
%% find sqlite3 executable
s = dir('*/sqlite3.exe');
sqlexe = fullfile(s.folder, s.name);
%%
typeMap = containers.Map({'double', 'cell', 'char'}, {'REAL', 'TEXT', 'TEXT'}); % map MATLAB data types to sqlite data types
opts = detectImportOptions(tblFile);
vars = opts.VariableNames;
matTypes = opts.VariableTypes;
sqlTypes = cellfun(@(x) typeMap(x), matTypes, 'uni', 0);

colStr = strjoin(cellfun(@(v, t) sprintf('%s %s', v, t), vars, sqlTypes, 'uni', 0), ', ');

tbl_drop = @(name) sprintf('DROP TABLE IF EXISTS %s;', name);
tbl_create = @(name, cols) sprintf('CREATE TABLE IF NOT EXISTS %s (%s);', name, cols);
% tbl_insert = @(name, cols) sprintf('INSERT INTO %s (%s) VALUES (%s);',...
%     name, strjoin(cols, ', '), strjoin(repmat({'?'}, 1, numel(cols)), ', '));

% sqlite3(dbfile, tbl_drop(tblName));
% sqlite3(dbfile, tbl_create(tblName, colStr));
% sqlite3(dbfile, tbl_insert(tblName, vars), table2struct(tbl)); % this is very slow

%% write commands to import data to a text file for system call
where_hdr = strjoin(cellfun(@(v) sprintf('%s=''%s''', v, v), vars, 'uni', 0), ' AND ');
cmds = {
    '.mode csv'
    tbl_drop(tblName)
    tbl_create(tblName, colStr)
    sprintf('.import %s %s', tblFile, tblName) % use built in sqlite csv import
    sprintf('DELETE FROM %s WHERE %s;', tblName, where_hdr) % delete accidental inclusion of header row
    };
cmd_file = fullfile(tempdir, 'sqlite_cmds.txt');
fid = fopen(cmd_file, 'w');
fprintf(fid, '%s\n', strjoin(cmds, '\n'));
fclose(fid);
%% execute system call
sys_call = sprintf('"%s" %s < "%s"', sqlexe, dbfile, cmd_file);
[status, cmdout] = system(sys_call);
if status ~= 0 
    keyboard
end

delete(cmd_file);
end

