function build_db_table( dbfile, tblName, tbl )
typeMap = containers.Map({'double', 'cell'}, {'REAL', 'TEXT'});

vars = tbl.Properties.VariableNames;
matTypes = (varfun(@class, tbl, 'outputformat','cell'));
sqlTypes = cellfun(@(x) typeMap(x), matTypes, 'uni', 0);

colStr = strjoin(cellfun(@(v, t) sprintf('%s %s', v, t), vars, sqlTypes, 'uni', 0), ', ');

tbl_drop = @(name) sprintf('DROP TABLE IF EXISTS %s', name);
tbl_create = @(name, cols) sprintf('CREATE TABLE IF NOT EXISTS %s (%s);', name, cols);
tbl_insert = @(name, cols) sprintf('INSERT INTO %s (%s) VALUES (%s);',...
    name, strjoin(cols, ', '), strjoin(repmat({'?'}, 1, numel(cols)), ', '));

sqlite3(dbfile, tbl_drop(tblName));
sqlite3(dbfile, tbl_create(tblName, colStr));
sqlite3(dbfile, tbl_insert(tblName, vars), table2struct(tbl));

end

