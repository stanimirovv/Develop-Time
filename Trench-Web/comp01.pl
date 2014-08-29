#!/usr/bin/env perl
use Mojolicious::Lite;

get '/' => sub {
  my $self = shift;
  $self->render('index');
};

any [qw(GET POST)] => '/daily/:name' => sub {
                my $self = shift;
                
                my ($sec,$min,$hour,$mday) = localtime();
                my $name_ascii = $self->param("name");
                $name_ascii=~s/(.)/ord($1)/eg;
                my $percent = (($mday * 13) + $name_ascii) % 100;   
                $self->render("daily", name => $self->param("name"), percent => $percent);
             };

get '/quote' => sub{
    my $self = shift;
    my @quotes = ('foo', 'bar', 'tt1', 'pie');
    my $quote = $quotes[rand @quotes];
    $self->render("quote", quote => $quote);
};

get 'dice' => sub{
    my $self = shift;
    $self->render("dice", val => 3);
};

app->start;
__DATA__

@@ index.html.ep
% layout 'default';
% title 'Welcome';
Hello Mojo! <br/>
<b>Links:</b> <br/>
 daily/name <br/>
<a href="/quote"> quote</a>  <br/>
<a href="/dice"> dice</a> <br/>

@@ daily.html.ep
<%= $name  %>, percent for X today is: <%= $percent %>!

@@ quote.html.ep
<h1>Your quote is:</h1>
<%= $quote  %>

@@ dice.html.ep
<h1> You get <%= $val %> </h1>


