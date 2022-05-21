% Create a database file and create a table.
db_name='temp.db';
sqlite3(db_name,...
    'CREATE TABLE test (some_text TEXT, some_int INT, some_real REAL);');

% Insert values from a struct array.
x=struct;
x(1).text='hello world';
x(1).int= 1337;
x(1).dbl=exp(1);

x(2).text='foo';
x(2).int=-404;
x(2).dbl=pi;

sqlite3(db_name,...
    ['INSERT INTO test (some_text, some_int, some_real) '...
    'VALUES (?, ?, ?);'],...
    x)

% Insert values from a char array.
sqlite3(db_name,...
    ['INSERT INTO test (some_text, some_int, some_real) ',...
    'VALUES ("lorem ipsum", 42, 4.20);'])

% Query the data, with or without renaming the fields.
y = sqlite3(db_name,...
    'SELECT some_text, some_int, some_real as real FROM test;');
z = sqlite3(db_name,...
    'SELECT * FROM test;');

% Display the retrieved values.
y(1).some_text
y(2).some_int
y(3).real
disp(z)