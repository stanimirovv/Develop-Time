use lib '~/projects/query_generator';
use QueryGenerator;
use Data::Dumper;

sub Main()
{
    my $dbh = DBI->connect('dbi:Pg:dbname=practice_01;host=localhost','postgres','123',{AutoCommit=>1,RaiseError=>1,PrintError=>0});
    my $query_builder = QueryGenerator::CreateQueryBuilder($dbh);
    $query_builder->BuildRelationGraph();
    print Dumper($query_builder);
    my @foo = $query_builder->FindPath("a", "c");
    my $query = $query_builder->BuildQuerry(\@foo);
    print "QUEERRRYYYY:  ", $query;
}

Main();
