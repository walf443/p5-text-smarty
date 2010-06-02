package  Text::Smarty::Parser::Token::Function;
use strict;
use warnings;
use base qw(Text::Smarty::Parser::Token);

sub new {
    my ($class, %args) = @_;

    bless \%args, $class;
}

sub name { $_[0]->{name} }

sub args { $_[0]->{args}->{file} }

1;
