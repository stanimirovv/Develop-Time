package QueryGenerator;
use strict;
#use warnings;
use DBI;
use Data::Dumper;

my @tables;
my @relation_graph;

=pod
 Class constructor
=cut
sub CreateQueryBuilder($)
{
    my ($dbh) = @_;

    my $class = shift;
    my $self = {
        dbh => $dbh,
        tables => {},
        relation_graph => {},
    };
    bless $self;
    return $self;
}

=pod
    TODO Add documentation
=cut
sub BuildRelationGraph($)
{
    my ($self) = @_;

    # TODO make the query a parameter.
    my $sth = $$self{dbh}->prepare("select table_name, constraint_name, CASE WHEN constraint_type = 'PRIMARY KEY' THEN 1 else 100 END AS order_by
    from information_schema.table_constraints
    where constraint_type ='FOREIGN KEY' OR constraint_type = 'PRIMARY KEY'
    order by order_by asc;");
    $sth->execute();
    my @tables = ();
    my @relation_graph = ();
    for (my $j = 0; $j < 5; $j++)
    {
        push(@relation_graph, [0]);
        for(my $k = 0; $k < 5 -1; $k++)
        {
            push(@{$relation_graph[$j]}, 0);
        }
    }

    my $i = 0;
    while(my $row = $sth->fetchrow_hashref())
    {
        if($$row{order_by} == 1)
        {
            push(@tables, FetchNewNode($i, $$row{table_name}));
            $i++;
        }
        elsif($$row{order_by} == 100)
        {
            for my $node (@tables)
            {
                for my $node2 (@tables)
                {
                    if(index($$row{constraint_name}, "$$node{name}_$$node2{name}_id") != -1)
                    {
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
                    }
                }
            }
        }
    }
    $$self{tables} = \@tables;
    $$self{relation_graph} = \@relation_graph;
}

=pod
    A wrapper functino which prepares the input for the FindPathHelper
    which does most of the processing.
    It (FindPath) also prepares the output.
=cut
sub FindPath($$$)
{
    my ($self, $start, $end) = @_;

    my $start_id = -1;
    my $end_id = -1;

    my @tables = @{$$self{tables}};
    for my $node (@tables)
    {
        if($$node{name} eq $start)
        {
            $start_id = $$node{id};
        }

        if($$node{name} eq $end)
        {
            $end_id = $$node{id};
        }
    }

    my $path = $self->FindPathHelper($start_id, $end_id);
    $path = $start_id.",".$path;
    my @true_path  = split(',', $path);
    return @true_path;
}

=pod
This function is the brain behind the FindPath function and does most of the work.
=cut
sub FindPathHelper
{
    my ($self, $from, $to) = @_;

    for (my $i = 0; $i < @{$$self{relation_graph}[$from]}; $i++)
    {

        if($$self{relation_graph}[$from][$i] == 0){
            next;
        }

        if($i == $to)
        {
            print "Finally in $to\n";
            return $i;
        }

        #print "starting search from $i";
        my $pth = $self->FindPathHelper($i, $to);
        if($pth ne "false")
        {
            return $i.",".$pth;
        }
    }
    return "false";
}

=pod
    Takes a path and output's the corresponding querry.
=cut
sub BuildQuerry($$)
{
    my ($self, $path1) = @_;
    my @path = @$path1;
    print "Dumping true path: ", Dumper(@path);

    my $query = "SELECT * FROM $$self{tables}[$path[0]]{name}";
    for (my $i = 1; $i < scalar(@path); $i++)
    {
        $query .= " JOIN $$self{tables}[$path[$i]]{name} ON $$self{tables}[$path[$i-1]]{name}.$$self{tables}[$path[$i]]{name}_id__nn = $$self{tables}[$path[$i]]{name}.id";
    }
    $query .= ";";

    return $query;
}

=pod
    Utility function used for generating the table object.
=cut
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

=pod
    Use it when you are not sure if the package is included or not.
=cut
sub Ping()
{
    print "Pong!\n";
}


1;
