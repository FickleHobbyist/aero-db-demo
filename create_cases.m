function [ tbl ] = create_cases( dvars )
c = struct2cell(dvars);
[C{1:numel(c)}] = ndgrid(c{:});
C = cellfun(@(x) x(:), C, 'uni', 0);
C = horzcat(C{:});
f = fieldnames(dvars);
tbl = array2table(C, 'VariableNames', f);
end

