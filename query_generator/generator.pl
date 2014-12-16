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
    #@tables[$sth->rows()];
    my @relation_graph = ();
    for (my $j = 0; $j < 5; $j++)
    {
        push(@relation_graph, [0]);
        for(my $k = 0; $k < 5 -1; $k++)
        {
            push(@{$relation_graph[$j]}, 0);
        }
    }
    #print Dumper(@relation_graph);
    my $i = 0;
    #print "Number of rows is: ", $sth->rows();

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
            #print Dumper(@tables);
            for my $node (@tables)
            {
                #print Dumper($node);
                #print "The current constraint name is: $$row{constraint_name} \n";
                for my $node2 (@tables)
                {
                    if(index($$row{constraint_name}, "$$node{name}_$$node2{name}_id") != -1)
                    {
                        #print "There is a hit constraint name: $$row{constraint_name}, node1: $$node{name}, node2: $$node2{name}\n";
                        my $main_table_id = -1;
                        my $foreign_table_id = -1;
                        for (my $k = 0; $k < scalar(@tables); $k++)
                        {
                            if($tables[$k]{name} eq $$node{name})
                            {
                                $main_table_id = $tables[$k]{id};
                            }

                            if($tables[$k]{name} eq $$node2{name})
                            {
                                $foreign_table_id = $tables[$k]{id};
                            }
                        }
                        $relation_graph[$main_table_id][$foreign_table_id] = 1;
                        #print "The id of the main table is: $main_table_id, the id of the foreign table is $foreign_table_id \n";
                    }
                }
            }
        }
    }
    print "Dumping the relation graph: ", Dumper(@relation_graph);
}

Main();
