use strict;
use warnings;
use DBI;
use Data::Dumper;

sub BuildRelationGraph($)
{
    my ($dbh) = @_;
}

sub FindPath($$$)
{
    my ($from, $to, $graph)
}

sub FetchNewNode(;$$$)
{
    my ($id, $name, $is_ljoin) = @_;

    $id = $id || 0;
    $name = $name || "";
    $is_ljoin = $is_ljoin || 0;

    return {
                id => $id,
                name => $name,
                is_ljoin => $is_ljoin,
           };
}

sub Main()
{
    my $dbh = DBI->connect('dbi:Pg:dbname=practice_01;host=localhost','postgres','123',{AutoCommit=>1,RaiseError=>1,PrintError=>0});

    my $sth = $dbh->prepare("select table_name, constraint_name, CASE WHEN constraint_type = 'PRIMARY KEY' THEN 1 else 100 END AS order_by
                            from information_schema.table_constraints
                            where constraint_type ='FOREIGN KEY' OR constraint_type = 'PRIMARY KEY'
                            order by order_by asc;");
    $sth->execute();
    my @tables = ();
    @tables[$sth->rows()];
    my @relation_graph = ();
    my $i = 0;
    print "Number of rows is: ", $sth->rows();

    while(my $row = $sth->fetchrow_hashref())
    {
        if($$row{order_by} == 1)
        {
            push(@tables, FetchNewNode($i, $$row{table_name}));
            $i++;
        }
        elsif($$row{order_by} == 100)
        {
            # find base table
            for my $node (@tables)
            {
                print $$node{id}, "\n\n";
                if(index($str, "$$node{table_name}_") != -1)
                {

                }
                elsif(index($str, "_$$node{table_name}"))
                {

                }
            }
            # find point to table
            # insert into
        }
    }
    for (my $j = 0; $j < scalar(@tables); $j++)
    {
#        print $j, "   ", $tables[$j]{id}, "\n";
    }
}

Main();
